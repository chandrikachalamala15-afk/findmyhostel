<?php
/**
 * Database Configuration and Connection Class
 * Find My Hostel - Production-ready Database Handler
 * 
 * This file handles database connections using PDO with proper error handling,
 * connection pooling, and security measures.
 */

class Database {
    // Database credentials
    private static $host = 'localhost';
    private static $db_name = 'findmyhostel';
    private static $username = 'root';
    private static $password = '';
    private static $charset = 'utf8mb4';
    
    // PDO options
    private static $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
        PDO::ATTR_PERSISTENT         => true, // Connection pooling
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"
    ];
    
    private static $instance = null;
    
    /**
     * Get database instance (Singleton pattern)
     * 
     * @return PDO Database connection instance
     * @throws PDOException If connection fails
     */
    public static function getInstance() {
        if (self::$instance === null) {
            try {
                $host = getenv('DB_HOST') ?: self::$host;
                $db_name = getenv('DB_NAME') ?: self::$db_name;
                $username = getenv('DB_USER') ?: self::$username;
                $password = getenv('DB_PASS') !== false ? getenv('DB_PASS') : self::$password;
                $charset = getenv('DB_CHARSET') ?: self::$charset;

                $dsn = "mysql:host=" . $host . ";dbname=" . $db_name . ";charset=" . $charset;
                self::$instance = new PDO($dsn, $username, $password, self::$options);
            } catch (PDOException $e) {
                // Log error and throw exception
                error_log("Database Connection Error: " . $e->getMessage());
                throw new PDOException("Database connection failed. Please try again later.");
            }
        }
        return self::$instance;
    }
    
    /**
     * Execute a SELECT query with parameters
     * 
     * @param string $query SQL query with placeholders
     * @param array $params Parameters to bind
     * @return array Query results
     */
    public static function select($query, $params = []) {
        try {
            $db = self::getInstance();
            $stmt = $db->prepare($query);
            $stmt->execute($params);
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            error_log("Select Query Error: " . $e->getMessage());
            return [];
        }
    }
    
    /**
     * Execute an INSERT query
     * 
     * @param string $query SQL query with placeholders
     * @param array $params Parameters to bind
     * @return int Last inserted ID
     */
    public static function insert($query, $params = []) {
        try {
            $db = self::getInstance();
            $stmt = $db->prepare($query);
            $stmt->execute($params);
            return $db->lastInsertId();
        } catch (PDOException $e) {
            error_log("Insert Query Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Execute an UPDATE query
     * 
     * @param string $query SQL query with placeholders
     * @param array $params Parameters to bind
     * @return int Number of affected rows
     */
    public static function update($query, $params = []) {
        try {
            $db = self::getInstance();
            $stmt = $db->prepare($query);
            $stmt->execute($params);
            return $stmt->rowCount();
        } catch (PDOException $e) {
            error_log("Update Query Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Execute a DELETE query
     * 
     * @param string $query SQL query with placeholders
     * @param array $params Parameters to bind
     * @return int Number of affected rows
     */
    public static function delete($query, $params = []) {
        try {
            $db = self::getInstance();
            $stmt = $db->prepare($query);
            $stmt->execute($params);
            return $stmt->rowCount();
        } catch (PDOException $e) {
            error_log("Delete Query Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Begin a transaction
     * 
     * @return bool Success status
     */
    public static function beginTransaction() {
        try {
            $db = self::getInstance();
            return $db->beginTransaction();
        } catch (PDOException $e) {
            error_log("Transaction Begin Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Commit a transaction
     * 
     * @return bool Success status
     */
    public static function commit() {
        try {
            $db = self::getInstance();
            return $db->commit();
        } catch (PDOException $e) {
            error_log("Transaction Commit Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Rollback a transaction
     * 
     * @return bool Success status
     */
    public static function rollback() {
        try {
            $db = self::getInstance();
            return $db->rollBack();
        } catch (PDOException $e) {
            error_log("Transaction Rollback Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Sanitize input data
     * 
     * @param mixed $data Data to sanitize
     * @return mixed Sanitized data
     */
    public static function sanitize($data) {
        if ($data === null) {
            return null;
        }
        if (is_array($data)) {
            return array_map('self::sanitize', $data);
        }
        return is_string($data) ? trim(strip_tags($data)) : $data;
    }
    
    /**
     * Validate email address
     * 
     * @param string $email Email to validate
     * @return bool Valid or not
     */
    public static function validateEmail($email) {
        return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
    }
    
    /**
     * Hash password using bcrypt
     * 
     * @param string $password Password to hash
     * @return string Hashed password
     */
    public static function hashPassword($password) {
        return password_hash($password, PASSWORD_BCRYPT, ['cost' => 10]);
    }
    
    /**
     * Verify password against hash
     * 
     * @param string $password Password to verify
     * @param string $hash Hash to verify against
     * @return bool Valid or not
     */
    public static function verifyPassword($password, $hash) {
        return password_verify($password, $hash);
    }
    
    /**
     * Close database connection
     */
    public static function close() {
        self::$instance = null;
    }
}

/**
 * Helper function for JSON responses
 * 
 * @param bool $success Success status
 * @param string $message Response message
 * @param mixed $data Response data
 * @param int $statusCode HTTP status code
 */
function sendJsonResponse($success, $message, $data = null, $statusCode = 200) {
    http_response_code($statusCode);
    header('Content-Type: application/json');
    $response = [
        'success' => $success,
        'message' => $message
    ];
    if ($data !== null) {
        $response['data'] = $data;
    }
    echo json_encode($response, JSON_PRETTY_PRINT);
    exit;
}

/**
 * Helper function for error responses
 * 
 * @param string $message Error message
 * @param mixed $errors Additional error details
 * @param int $statusCode HTTP status code
 */
function sendErrorResponse($message, $errors = null, $statusCode = 400) {
    http_response_code($statusCode);
    header('Content-Type: application/json');
    $response = [
        'success' => false,
        'message' => $message
    ];
    if ($errors !== null) {
        $response['errors'] = $errors;
    }
    echo json_encode($response, JSON_PRETTY_PRINT);
    exit;
}

/**
 * Helper function to get request method
 * 
 * @return string HTTP request method
 */
function getRequestMethod() {
    return $_SERVER['REQUEST_METHOD'];
}

/**
 * Helper function to get JSON input
 * 
 * @return array Decoded JSON data
 */
function getJsonInput() {
    $json = file_get_contents('php://input');
    return json_decode($json, true) ?? [];
}

/**
 * Helper function to get query parameters
 * 
 * @param string $key Parameter key
 * @param mixed $default Default value if not found
 * @return mixed Parameter value
 */
function getQueryParam($key, $default = null) {
    return $_GET[$key] ?? $default;
}

/**
 * Helper function to validate required fields
 * 
 * @param array $data Data to validate
 * @param array $requiredFields Required field names
 * @return array Validation errors
 */
function validateRequiredFields($data, $requiredFields) {
    $errors = [];
    foreach ($requiredFields as $field) {
        if (!isset($data[$field]) || empty(trim($data[$field]))) {
            $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . ' is required';
        }
    }
    return $errors;
}
?>