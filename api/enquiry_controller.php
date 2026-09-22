<?php
/**
 * Enquiry / Contact Controller
 * Find My Hostel - Student Enquiry Management API
 */

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once '../config/database.php';

class EnquiryController {
    public function submitEnquiry($data) {
        $query = "
            INSERT INTO contacts (
                name, email, phone, subject, message, hostel_id, enquiry_type, status, ip_address, user_agent
            ) VALUES (
                :name, :email, :phone, :subject, :message, :hostel_id, :enquiry_type, 'new', :ip_address, :user_agent
            )
        ";

        $params = [
            ':name' => Database::sanitize($data['name'] ?? ''),
            ':email' => Database::sanitize($data['email'] ?? ''),
            ':phone' => Database::sanitize($data['phone'] ?? ''),
            ':subject' => Database::sanitize($data['subject'] ?? 'General Enquiry'),
            ':message' => Database::sanitize($data['message'] ?? ''),
            ':hostel_id' => !empty($data['hostel_id']) ? intval($data['hostel_id']) : null,
            ':enquiry_type' => $data['enquiry_type'] ?? 'booking',
            ':ip_address' => $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1',
            ':user_agent' => substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 255)
        ];

        try {
            return Database::insert($query, $params);
        } catch (Exception $e) {
            error_log("Submit Enquiry Error: " . $e->getMessage());
            return false;
        }
    }

    public function getEnquiries($limit = 20) {
        $safeLimit = max(1, min(100, intval($limit)));
        $query = "
            SELECT c.*, h.hostel_name 
            FROM contacts c
            LEFT JOIN hostels h ON c.hostel_id = h.hostel_id
            ORDER BY c.created_at DESC
            LIMIT {$safeLimit}
        ";
        try {
            return Database::select($query, []);
        } catch (Exception $e) {
            error_log("Get Enquiries Error: " . $e->getMessage());
            return [];
        }
    }
}

// Request Handler
$controller = new EnquiryController();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = getJsonInput();

    $errors = validateRequiredFields($data, ['name', 'email', 'message']);
    if (!empty($errors)) {
        sendErrorResponse('Validation failed', $errors);
    }

    if (!Database::validateEmail($data['email'])) {
        sendErrorResponse('Validation failed', ['email' => 'Invalid email address']);
    }

    $id = $controller->submitEnquiry($data);
    if ($id) {
        sendJsonResponse(true, 'Enquiry submitted successfully! A representative will contact you soon.', ['enquiry_id' => $id], 201);
    } else {
        sendErrorResponse('Failed to record enquiry. Please try again.');
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $limit = getQueryParam('limit', 20);
    $results = $controller->getEnquiries($limit);
    sendJsonResponse(true, 'Enquiries retrieved successfully', $results);
}
?>
