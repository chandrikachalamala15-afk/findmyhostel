<?php
/**
 * Hostel Controller
 * Find My Hostel - Hostel Management API
 * 
 * Handles hostel search, filtering, and management operations
 */

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once '../config/database.php';

class HostelController {
    
    /**
     * Get all hostels with advanced filtering
     * 
     * @param array $filters Filter parameters
     * @return array Filtered hostels
     */
    public function getHostels($filters = []) {
        $baseWhere = " WHERE h.verification_status = 'verified'";
        $params = [];
        
        // Search filter
        if (!empty($filters['search'])) {
            $baseWhere .= " AND (h.hostel_name LIKE :search OR h.address LIKE :search OR h.landmark LIKE :search)";
            $params[':search'] = '%' . $filters['search'] . '%';
        }
        
        // Type filter
        if (!empty($filters['type'])) {
            $baseWhere .= " AND h.hostel_type = :type";
            $params[':type'] = $filters['type'];
        }
        
        // Price range filter
        if (!empty($filters['min_price'])) {
            $baseWhere .= " AND (SELECT MIN(monthly_fee) FROM rooms WHERE hostel_id = h.hostel_id) >= :min_price";
            $params[':min_price'] = $filters['min_price'];
        }
        
        if (!empty($filters['max_price'])) {
            $baseWhere .= " AND (SELECT MAX(monthly_fee) FROM rooms WHERE hostel_id = h.hostel_id) <= :max_price";
            $params[':max_price'] = $filters['max_price'];
        }
        
        // Distance filter
        if (!empty($filters['max_distance'])) {
            $baseWhere .= " AND h.distance_from_college_km <= :max_distance";
            $params[':max_distance'] = $filters['max_distance'];
        }
        
        // Rating filter
        if (!empty($filters['min_rating'])) {
            $baseWhere .= " AND h.rating >= :min_rating";
            $params[':min_rating'] = $filters['min_rating'];
        }
        
        // Facility filters
        if (!empty($filters['has_wifi'])) {
            $baseWhere .= " AND JSON_CONTAINS(h.facilities_available, '\"wifi\"')";
        }
        
        if (!empty($filters['has_mess'])) {
            $baseWhere .= " AND JSON_CONTAINS(h.facilities_available, '\"mess\"')";
        }
        
        if (!empty($filters['has_ac'])) {
            $baseWhere .= " AND JSON_CONTAINS(h.facilities_available, '\"ac\"')";
        }
        
        // Sorting with strict whitelist
        $sortBy = $filters['sort_by'] ?? 'recommended';
        $sortOrder = (isset($filters['sort_order']) && strtoupper($filters['sort_order']) === 'ASC') ? 'ASC' : 'DESC';
        
        $orderClause = " ORDER BY h.rating DESC, h.verified_date DESC";
        switch ($sortBy) {
            case 'price':
                $orderClause = " ORDER BY min_monthly_fee {$sortOrder}";
                break;
            case 'rating':
                $orderClause = " ORDER BY h.rating {$sortOrder}";
                break;
            case 'distance':
                $orderClause = " ORDER BY h.distance_from_college_km {$sortOrder}";
                break;
            case 'name':
                $orderClause = " ORDER BY h.hostel_name {$sortOrder}";
                break;
        }
        
        // Pagination: cast strictly to int
        $page = max(1, intval($filters['page'] ?? 1));
        $limit = max(1, min(100, intval($filters['limit'] ?? 10)));
        $offset = ($page - 1) * $limit;
        
        $selectQuery = "
            SELECT 
                h.hostel_id,
                h.hostel_name,
                h.hostel_type,
                h.address,
                h.landmark,
                h.city,
                h.state,
                h.pincode,
                h.phone,
                h.email,
                h.rating,
                h.total_capacity,
                h.current_occupancy,
                h.distance_from_college_km,
                h.latitude,
                h.longitude,
                h.description,
                h.facilities_available,
                h.verification_status,
                h.verified_date,
                (SELECT MIN(monthly_fee) FROM rooms WHERE hostel_id = h.hostel_id) as min_monthly_fee,
                (SELECT MAX(monthly_fee) FROM rooms WHERE hostel_id = h.hostel_id) as max_monthly_fee,
                (SELECT COUNT(*) FROM rooms WHERE hostel_id = h.hostel_id AND room_status = 'available') as available_rooms
            FROM hostels h
            {$baseWhere}
            {$orderClause}
            LIMIT {$limit} OFFSET {$offset}
        ";
        
        try {
            $hostels = Database::select($selectQuery, $params);
            
            // Clean, reliable total count query
            $countQuery = "SELECT COUNT(*) as total FROM hostels h {$baseWhere}";
            $countResult = Database::select($countQuery, $params);
            $totalItems = intval($countResult[0]['total'] ?? 0);
            $totalPages = $limit > 0 ? (int)ceil($totalItems / $limit) : 1;
            
            // Decode JSON facilities
            foreach ($hostels as &$hostel) {
                if (is_string($hostel['facilities_available'])) {
                    $hostel['facilities_available'] = json_decode($hostel['facilities_available'], true) ?? [];
                }
            }
            unset($hostel);
            
            return [
                'hostels' => $hostels,
                'pagination' => [
                    'current_page' => $page,
                    'per_page' => $limit,
                    'total_items' => $totalItems,
                    'total_pages' => $totalPages
                ]
            ];
            
        } catch (Exception $e) {
            error_log("Get Hostels Error: " . $e->getMessage());
            return ['hostels' => [], 'pagination' => []];
        }
    }
    
    /**
     * Get detailed information about a specific hostel
     * 
     * @param int $hostelId Hostel ID
     * @return array Hostel details
     */
    public function getHostelById($hostelId) {
        $query = "
            SELECT 
                h.*,
                (SELECT MIN(monthly_fee) FROM rooms WHERE hostel_id = h.hostel_id) as min_monthly_fee,
                (SELECT MAX(monthly_fee) FROM rooms WHERE hostel_id = h.hostel_id) as max_monthly_fee
            FROM hostels h
            WHERE h.hostel_id = :hostel_id
        ";
        
        try {
            $result = Database::select($query, [':hostel_id' => $hostelId]);
            
            if (empty($result)) {
                return null;
            }
            
            $hostel = $result[0];
            $hostel['facilities_available'] = json_decode($hostel['facilities_available'], true) ?? [];
            $hostel['images'] = json_decode($hostel['images'], true) ?? [];
            
            // Get rooms for this hostel
            $roomsQuery = "
                SELECT 
                    room_id,
                    room_number,
                    room_type,
                    floor_number,
                    capacity,
                    current_occupancy,
                    available_beds,
                    has_ac,
                    has_fan,
                    has_attached_bathroom,
                    has_study_table,
                    has_wardrobe,
                    room_area_sqft,
                    room_description,
                    monthly_fee,
                    yearly_fee,
                    security_deposit,
                    room_status
                FROM rooms
                WHERE hostel_id = :hostel_id
                ORDER BY floor_number, room_number
            ";
            
            $hostel['rooms'] = Database::select($roomsQuery, [':hostel_id' => $hostelId]);
            
            // Get occupancy summary by joining rooms
            $occupancyQuery = "
                SELECT 
                    h.hostel_id,
                    h.hostel_name,
                    h.total_capacity,
                    h.current_occupancy,
                    COUNT(r.room_id) as total_rooms,
                    SUM(CASE WHEN r.room_status = 'available' THEN 1 ELSE 0 END) as available_rooms,
                    SUM(CASE WHEN r.room_status = 'occupied' THEN 1 ELSE 0 END) as occupied_rooms,
                    COALESCE(SUM(r.available_beds), 0) as total_available_beds,
                    ROUND((h.current_occupancy / NULLIF(h.total_capacity, 0)) * 100, 2) as occupancy_percentage
                FROM hostels h
                LEFT JOIN rooms r ON h.hostel_id = r.hostel_id
                WHERE h.hostel_id = :hostel_id
                GROUP BY h.hostel_id, h.hostel_name, h.total_capacity, h.current_occupancy
            ";
            
            $occupancyResult = Database::select($occupancyQuery, [':hostel_id' => $hostelId]);
            $hostel['occupancy_summary'] = $occupancyResult[0] ?? [
                'total_rooms' => count($hostel['rooms']),
                'available_rooms' => 0,
                'occupied_rooms' => 0,
                'total_available_beds' => 0,
                'occupancy_percentage' => 0
            ];
            
            // Get weekly mess menu for this hostel
            $menuQuery = "
                SELECT 
                    menu_id,
                    day_of_week,
                    meal_type,
                    menu_items,
                    is_special,
                    special_occasion,
                    calories_per_serving,
                    protein_content
                FROM mess_menu
                WHERE hostel_id = :hostel_id
                ORDER BY FIELD(day_of_week, 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'),
                         FIELD(meal_type, 'breakfast', 'lunch', 'snacks', 'dinner')
            ";
            $hostel['mess_menu'] = Database::select($menuQuery, [':hostel_id' => $hostelId]);
            
            return $hostel;
            
        } catch (Exception $e) {
            error_log("Get Hostel By ID Error: " . $e->getMessage());
            return null;
        }
    }
    
    /**
     * Create a new hostel
     * 
     * @param array $data Hostel data
     * @return int|bool New hostel ID or false on failure
     */
    public function createHostel($data) {
        $query = "
            INSERT INTO hostels (
                hostel_name, hostel_type, address, landmark, city, state, pincode,
                phone, whatsapp_number, email, website, rating, total_capacity,
                distance_from_college_km, latitude, longitude, description,
                facilities_available, rules_regulations, verification_status
            ) VALUES (
                :hostel_name, :hostel_type, :address, :landmark, :city, :state, :pincode,
                :phone, :whatsapp_number, :email, :website, :rating, :total_capacity,
                :distance_from_college_km, :latitude, :longitude, :description,
                :facilities_available, :rules_regulations, :verification_status
            )
        ";
        
        $params = [
            ':hostel_name' => Database::sanitize($data['hostel_name']),
            ':hostel_type' => $data['hostel_type'],
            ':address' => Database::sanitize($data['address']),
            ':landmark' => Database::sanitize($data['landmark'] ?? ''),
            ':city' => Database::sanitize($data['city'] ?? 'Gudlavalleru'),
            ':state' => Database::sanitize($data['state'] ?? 'Andhra Pradesh'),
            ':pincode' => Database::sanitize($data['pincode'] ?? ''),
            ':phone' => Database::sanitize($data['phone']),
            ':whatsapp_number' => Database::sanitize($data['whatsapp_number'] ?? ''),
            ':email' => Database::sanitize($data['email'] ?? ''),
            ':website' => Database::sanitize($data['website'] ?? ''),
            ':rating' => floatval($data['rating'] ?? 0),
            ':total_capacity' => intval($data['total_capacity'] ?? 0),
            ':distance_from_college_km' => floatval($data['distance_from_college_km'] ?? 0),
            ':latitude' => floatval($data['latitude'] ?? 0),
            ':longitude' => floatval($data['longitude'] ?? 0),
            ':description' => Database::sanitize($data['description'] ?? ''),
            ':facilities_available' => json_encode($data['facilities_available'] ?? []),
            ':rules_regulations' => Database::sanitize($data['rules_regulations'] ?? ''),
            ':verification_status' => 'pending'
        ];
        
        try {
            return Database::insert($query, $params);
        } catch (Exception $e) {
            error_log("Create Hostel Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Update hostel information
     * 
     * @param int $hostelId Hostel ID
     * @param array $data Updated hostel data
     * @return bool Success status
     */
    public function updateHostel($hostelId, $data) {
        $query = "
            UPDATE hostels SET
                hostel_name = :hostel_name,
                hostel_type = :hostel_type,
                address = :address,
                landmark = :landmark,
                city = :city,
                state = :state,
                pincode = :pincode,
                phone = :phone,
                whatsapp_number = :whatsapp_number,
                email = :email,
                website = :website,
                rating = :rating,
                total_capacity = :total_capacity,
                distance_from_college_km = :distance_from_college_km,
                latitude = :latitude,
                longitude = :longitude,
                description = :description,
                facilities_available = :facilities_available,
                rules_regulations = :rules_regulations,
                updated_at = CURRENT_TIMESTAMP
            WHERE hostel_id = :hostel_id
        ";
        
        $params = [
            ':hostel_id' => $hostelId,
            ':hostel_name' => Database::sanitize($data['hostel_name']),
            ':hostel_type' => $data['hostel_type'],
            ':address' => Database::sanitize($data['address']),
            ':landmark' => Database::sanitize($data['landmark'] ?? ''),
            ':city' => Database::sanitize($data['city'] ?? 'Gudlavalleru'),
            ':state' => Database::sanitize($data['state'] ?? 'Andhra Pradesh'),
            ':pincode' => Database::sanitize($data['pincode'] ?? ''),
            ':phone' => Database::sanitize($data['phone']),
            ':whatsapp_number' => Database::sanitize($data['whatsapp_number'] ?? ''),
            ':email' => Database::sanitize($data['email'] ?? ''),
            ':website' => Database::sanitize($data['website'] ?? ''),
            ':rating' => floatval($data['rating'] ?? 0),
            ':total_capacity' => intval($data['total_capacity'] ?? 0),
            ':distance_from_college_km' => floatval($data['distance_from_college_km'] ?? 0),
            ':latitude' => floatval($data['latitude'] ?? 0),
            ':longitude' => floatval($data['longitude'] ?? 0),
            ':description' => Database::sanitize($data['description'] ?? ''),
            ':facilities_available' => json_encode($data['facilities_available'] ?? []),
            ':rules_regulations' => Database::sanitize($data['rules_regulations'] ?? '')
        ];
        
        try {
            return Database::update($query, $params) > 0;
        } catch (Exception $e) {
            error_log("Update Hostel Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Update hostel verification status
     * 
     * @param int $hostelId Hostel ID
     * @param string $status Verification status
     * @param string $notes Admin notes
     * @return bool Success status
     */
    public function updateVerificationStatus($hostelId, $status, $notes = '') {
        $query = "
            UPDATE hostels SET
                verification_status = :verification_status,
                admin_notes = :admin_notes,
                verified_date = CASE WHEN :verification_status = 'verified' THEN CURRENT_DATE ELSE verified_date END,
                updated_at = CURRENT_TIMESTAMP
            WHERE hostel_id = :hostel_id
        ";
        
        $params = [
            ':hostel_id' => $hostelId,
            ':verification_status' => $status,
            ':admin_notes' => Database::sanitize($notes)
        ];
        
        try {
            return Database::update($query, $params) > 0;
        } catch (Exception $e) {
            error_log("Update Verification Status Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Delete a hostel
     * 
     * @param int $hostelId Hostel ID
     * @return bool Success status
     */
    public function deleteHostel($hostelId) {
        $query = "DELETE FROM hostels WHERE hostel_id = :hostel_id";
        
        try {
            return Database::delete($query, [':hostel_id' => $hostelId]) > 0;
        } catch (Exception $e) {
            error_log("Delete Hostel Error: " . $e->getMessage());
            return false;
        }
    }
}

// API Endpoint Handlers
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $controller = new HostelController();
    
    // Get single hostel
    if (isset($_GET['id'])) {
        $hostelId = intval($_GET['id']);
        $hostel = $controller->getHostelById($hostelId);
        
        if ($hostel) {
            sendJsonResponse(true, 'Hostel retrieved successfully', $hostel);
        } else {
            sendErrorResponse('Hostel not found', null, 404);
        }
    }
    
    // Get hostels with filters
    $filters = [
        'search' => getQueryParam('search'),
        'type' => getQueryParam('type'),
        'min_price' => getQueryParam('min_price'),
        'max_price' => getQueryParam('max_price'),
        'max_distance' => getQueryParam('max_distance'),
        'min_rating' => getQueryParam('min_rating'),
        'has_wifi' => getQueryParam('has_wifi'),
        'has_mess' => getQueryParam('has_mess'),
        'has_ac' => getQueryParam('has_ac'),
        'sort_by' => getQueryParam('sort_by'),
        'sort_order' => getQueryParam('sort_order'),
        'page' => getQueryParam('page', 1),
        'limit' => getQueryParam('limit', 10)
    ];
    
    $result = $controller->getHostels($filters);
    sendJsonResponse(true, 'Hostels retrieved successfully', $result);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $controller = new HostelController();
    $data = getJsonInput();
    
    // Create hostel
    $errors = validateRequiredFields($data, ['hostel_name', 'hostel_type', 'address', 'phone']);
    
    if (!empty($errors)) {
        sendErrorResponse('Validation failed', $errors);
    }
    
    $hostelId = $controller->createHostel($data);
    
    if ($hostelId) {
        sendJsonResponse(true, 'Hostel created successfully', ['hostel_id' => $hostelId], 201);
    } else {
        sendErrorResponse('Failed to create hostel');
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $controller = new HostelController();
    $data = getJsonInput();
    
    if (!isset($_GET['id'])) {
        sendErrorResponse('Hostel ID is required');
    }
    
    $hostelId = intval($_GET['id']);
    $success = $controller->updateHostel($hostelId, $data);
    
    if ($success) {
        sendJsonResponse(true, 'Hostel updated successfully');
    } else {
        sendErrorResponse('Failed to update hostel');
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $controller = new HostelController();
    
    if (!isset($_GET['id'])) {
        sendErrorResponse('Hostel ID is required');
    }
    
    $hostelId = intval($_GET['id']);
    $success = $controller->deleteHostel($hostelId);
    
    if ($success) {
        sendJsonResponse(true, 'Hostel deleted successfully');
    } else {
        sendErrorResponse('Failed to delete hostel');
    }
}
?>