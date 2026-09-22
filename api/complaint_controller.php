<?php
/**
 * Complaint Controller
 * Find My Hostel - Complaint Management API
 * 
 * Handles complaint submission, status management, and resolution workflow
 * Status lifecycle: Pending → In Progress → Resolved/Rejected
 */

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once '../config/database.php';

class ComplaintController {
    
    /**
     * Get complaints with filtering
     * 
     * @param array $filters Filter parameters
     * @return array Filtered complaints
     */
    public function getComplaints($filters = []) {
        $query = "
            SELECT 
                c.complaint_id,
                c.student_id,
                c.hostel_id,
                c.room_id,
                c.category,
                c.subject,
                c.description,
                c.priority,
                c.status,
                c.submitted_date,
                c.resolved_date,
                c.resolution_notes,
                c.assigned_to,
                c.resolved_by,
                c.location,
                c.student_feedback,
                c.feedback_rating,
                s.first_name,
                s.last_name,
                h.hostel_name,
                r.room_number,
                u1.full_name as assigned_to_name,
                u2.full_name as resolved_by_name
            FROM complaints c
            LEFT JOIN students s ON c.student_id = s.student_id
            LEFT JOIN hostels h ON c.hostel_id = h.hostel_id
            LEFT JOIN rooms r ON c.room_id = r.room_id
            LEFT JOIN users u1 ON c.assigned_to = u1.user_id
            LEFT JOIN users u2 ON c.resolved_by = u2.user_id
            WHERE 1=1
        ";
        
        $params = [];
        
        // Student filter
        if (!empty($filters['student_id'])) {
            $query .= " AND c.student_id = :student_id";
            $params[':student_id'] = $filters['student_id'];
        }
        
        // Hostel filter
        if (!empty($filters['hostel_id'])) {
            $query .= " AND c.hostel_id = :hostel_id";
            $params[':hostel_id'] = $filters['hostel_id'];
        }
        
        // Category filter
        if (!empty($filters['category'])) {
            $query .= " AND c.category = :category";
            $params[':category'] = $filters['category'];
        }
        
        // Status filter
        if (!empty($filters['status'])) {
            $query .= " AND c.status = :status";
            $params[':status'] = $filters['status'];
        }
        
        // Priority filter
        if (!empty($filters['priority'])) {
            $query .= " AND c.priority = :priority";
            $params[':priority'] = $filters['priority'];
        }
        
        // Date range filter
        if (!empty($filters['from_date'])) {
            $query .= " AND DATE(c.submitted_date) >= :from_date";
            $params[':from_date'] = $filters['from_date'];
        }
        
        if (!empty($filters['to_date'])) {
            $query .= " AND DATE(c.submitted_date) <= :to_date";
            $params[':to_date'] = $filters['to_date'];
        }
        
        // Order by submitted date (newest first)
        $query .= " ORDER BY c.submitted_date DESC";
        
        // Pagination: cast strictly to int to avoid PDO prepared statement string-binding issues
        $page = max(1, intval($filters['page'] ?? 1));
        $limit = max(1, min(100, intval($filters['limit'] ?? 20)));
        $offset = ($page - 1) * $limit;
        
        $query .= " LIMIT {$limit} OFFSET {$offset}";
        
        try {
            $complaints = Database::select($query, $params);
            
            // Get total count matching all active filters
            $countQuery = "SELECT COUNT(*) as total FROM complaints c WHERE 1=1";
            $countParams = [];
            
            if (!empty($filters['student_id'])) {
                $countQuery .= " AND c.student_id = :student_id";
                $countParams[':student_id'] = $filters['student_id'];
            }
            
            if (!empty($filters['hostel_id'])) {
                $countQuery .= " AND c.hostel_id = :hostel_id";
                $countParams[':hostel_id'] = $filters['hostel_id'];
            }
            
            if (!empty($filters['category'])) {
                $countQuery .= " AND c.category = :category";
                $countParams[':category'] = $filters['category'];
            }
            
            if (!empty($filters['status'])) {
                $countQuery .= " AND c.status = :status";
                $countParams[':status'] = $filters['status'];
            }
            
            if (!empty($filters['priority'])) {
                $countQuery .= " AND c.priority = :priority";
                $countParams[':priority'] = $filters['priority'];
            }
            
            if (!empty($filters['from_date'])) {
                $countQuery .= " AND DATE(c.submitted_date) >= :from_date";
                $countParams[':from_date'] = $filters['from_date'];
            }
            
            if (!empty($filters['to_date'])) {
                $countQuery .= " AND DATE(c.submitted_date) <= :to_date";
                $countParams[':to_date'] = $filters['to_date'];
            }
            
            $countResult = Database::select($countQuery, $countParams);
            $totalItems = intval($countResult[0]['total'] ?? 0);
            $totalPages = $limit > 0 ? (int)ceil($totalItems / $limit) : 1;
            
            // Calculate summary statistics
            $summaryQuery = "
                SELECT 
                    COUNT(*) as total_complaints,
                    SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending,
                    SUM(CASE WHEN status = 'in_progress' THEN 1 ELSE 0 END) as in_progress,
                    SUM(CASE WHEN status = 'resolved' THEN 1 ELSE 0 END) as resolved,
                    SUM(CASE WHEN priority = 'urgent' THEN 1 ELSE 0 END) as urgent,
                    ROUND(AVG(CASE WHEN feedback_rating IS NOT NULL THEN feedback_rating END), 2) as average_feedback_rating
                FROM complaints
            ";
            
            $summaryResult = Database::select($summaryQuery, []);
            $summary = $summaryResult[0] ?? [];
            
            return [
                'complaints' => $complaints,
                'summary' => $summary,
                'pagination' => [
                    'current_page' => $page,
                    'per_page' => $limit,
                    'total_items' => $totalItems,
                    'total_pages' => $totalPages
                ]
            ];
            
        } catch (Exception $e) {
            error_log("Get Complaints Error: " . $e->getMessage());
            return ['complaints' => [], 'summary' => [], 'pagination' => []];
        }
    }
    
    /**
     * Submit a new complaint
     * 
     * @param array $data Complaint data
     * @return int|bool New complaint ID or false on failure
     */
    public function createComplaint($data) {
        $query = "
            INSERT INTO complaints (
                student_id, hostel_id, room_id, category, subject, description,
                priority, location, anonymous
            ) VALUES (
                :student_id, :hostel_id, :room_id, :category, :subject, :description,
                :priority, :location, :anonymous
            )
        ";
        
        $params = [
            ':student_id' => intval($data['student_id']),
            ':hostel_id' => intval($data['hostel_id']),
            ':room_id' => !empty($data['room_id']) ? intval($data['room_id']) : null,
            ':category' => Database::sanitize($data['category']),
            ':subject' => Database::sanitize($data['subject']),
            ':description' => Database::sanitize($data['description']),
            ':priority' => $data['priority'] ?? 'medium',
            ':location' => Database::sanitize($data['location'] ?? ''),
            ':anonymous' => $data['anonymous'] ?? false
        ];
        
        try {
            return Database::insert($query, $params);
        } catch (Exception $e) {
            error_log("Create Complaint Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Update complaint status (Core lifecycle management)
     * 
     * Status Flow: pending → in_progress → resolved/rejected
     * 
     * @param int $complaintId Complaint ID
     * @param string $status New status
     * @param int $assignedTo User ID to assign
     * @param string $notes Resolution/assignment notes
     * @return bool Success status
     */
    public function updateComplaintStatus($complaintId, $status, $assignedTo = null, $notes = '') {
        // Validate status transition
        $validTransitions = [
            'pending' => ['in_progress', 'rejected'],
            'in_progress' => ['resolved', 'rejected', 'pending'],
            'resolved' => ['in_progress', 'pending'],
            'rejected' => ['pending', 'in_progress']
        ];
        
        // Get current status
        $currentStatus = $this->getComplaintStatus($complaintId);
        
        if ($currentStatus && !in_array($status, $validTransitions[$currentStatus] ?? [])) {
            error_log("Invalid status transition from {$currentStatus} to {$status}");
            return false;
        }
        
        $query = "
            UPDATE complaints SET
                status = :status,
                assigned_to = :assigned_to,
                resolution_notes = :resolution_notes,
                updated_at = CURRENT_TIMESTAMP
        ";
        
        $params = [
            ':complaint_id' => $complaintId,
            ':status' => $status,
            ':assigned_to' => $assignedTo,
            ':resolution_notes' => Database::sanitize($notes)
        ];
        
        // Set resolved date if status is resolved
        if ($status === 'resolved') {
            $query .= ", resolved_date = CURRENT_TIMESTAMP";
        }
        
        // Set assigned date if being assigned
        if ($status === 'in_progress' && $assignedTo) {
            $query .= ", assigned_date = CURRENT_TIMESTAMP";
        }
        
        $query .= " WHERE complaint_id = :complaint_id";
        
        try {
            return Database::update($query, $params) > 0;
        } catch (Exception $e) {
            error_log("Update Complaint Status Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Resolve a complaint (complete the lifecycle)
     * 
     * @param int $complaintId Complaint ID
     * @param int $resolvedBy User ID who resolved it
     * @param string $resolutionNotes Resolution details
     * @param float $actualCost Actual cost if applicable
     * @return bool Success status
     */
    public function resolveComplaint($complaintId, $resolvedBy, $resolutionNotes, $actualCost = null) {
        $query = "
            UPDATE complaints SET
                status = 'resolved',
                resolved_by = :resolved_by,
                resolved_date = CURRENT_TIMESTAMP,
                resolution_notes = :resolution_notes,
                updated_at = CURRENT_TIMESTAMP
            WHERE complaint_id = :complaint_id
        ";
        
        $params = [
            ':complaint_id' => $complaintId,
            ':resolved_by' => $resolvedBy,
            ':resolution_notes' => Database::sanitize($resolutionNotes)
        ];
        
        try {
            Database::beginTransaction();
            
            $success = Database::update($query, $params) > 0;
            
            if ($success) {
                // Update maintenance record if linked
                $maintenanceQuery = "
                    UPDATE maintenance SET
                        status = 'completed',
                        completed_date = CURRENT_TIMESTAMP,
                        actual_cost = :actual_cost,
                        completion_notes = :completion_notes
                    WHERE complaint_id = :complaint_id AND status IN ('pending', 'in_progress', 'assigned')
                ";
                
                Database::update($maintenanceQuery, [
                    ':complaint_id' => $complaintId,
                    ':actual_cost' => $actualCost,
                    ':completion_notes' => Database::sanitize($resolutionNotes)
                ]);
            }
            
            Database::commit();
            return $success;
            
        } catch (Exception $e) {
            Database::rollback();
            error_log("Resolve Complaint Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Submit student feedback on resolved complaint
     * 
     * @param int $complaintId Complaint ID
     * @param string $feedback Student feedback
     * @param int $rating Rating (1-5)
     * @return bool Success status
     */
    public function submitFeedback($complaintId, $feedback, $rating) {
        // Validate rating
        if ($rating < 1 || $rating > 5) {
            return false;
        }
        
        $query = "
            UPDATE complaints SET
                student_feedback = :student_feedback,
                feedback_rating = :feedback_rating,
                updated_at = CURRENT_TIMESTAMP
            WHERE complaint_id = :complaint_id AND status = 'resolved'
        ";
        
        $params = [
            ':complaint_id' => $complaintId,
            ':student_feedback' => Database::sanitize($feedback),
            ':feedback_rating' => intval($rating)
        ];
        
        try {
            return Database::update($query, $params) > 0;
        } catch (Exception $e) {
            error_log("Submit Feedback Error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Get current status of a complaint
     * 
     * @param int $complaintId Complaint ID
     * @return string|null Current status
     */
    private function getComplaintStatus($complaintId) {
        $query = "SELECT status FROM complaints WHERE complaint_id = :complaint_id";
        $result = Database::select($query, [':complaint_id' => $complaintId]);
        return $result[0]['status'] ?? null;
    }
    
    /**
     * Get complaint statistics for dashboard
     * 
     * @param int $hostelId Optional hostel filter
     * @return array Statistics
     */
    public function getComplaintStatistics($hostelId = null) {
        $query = "
            SELECT 
                h.hostel_id,
                h.hostel_name,
                COUNT(c.complaint_id) as total_complaints,
                SUM(CASE WHEN c.status = 'pending' THEN 1 ELSE 0 END) as pending_complaints,
                SUM(CASE WHEN c.status = 'in_progress' THEN 1 ELSE 0 END) as in_progress_complaints,
                SUM(CASE WHEN c.status = 'resolved' THEN 1 ELSE 0 END) as resolved_complaints,
                SUM(CASE WHEN c.priority = 'urgent' THEN 1 ELSE 0 END) as urgent_complaints,
                ROUND(AVG(CASE WHEN c.feedback_rating IS NOT NULL THEN c.feedback_rating END), 2) as average_feedback_rating,
                ROUND(AVG(TIMESTAMPDIFF(HOUR, c.submitted_date, COALESCE(c.resolved_date, NOW()))), 2) as avg_resolution_hours
            FROM hostels h
            LEFT JOIN complaints c ON h.hostel_id = c.hostel_id
        ";
        
        $params = [];
        
        if ($hostelId) {
            $query .= " WHERE h.hostel_id = :hostel_id";
            $params[':hostel_id'] = $hostelId;
        }
        
        $query .= " GROUP BY h.hostel_id, h.hostel_name";
        
        try {
            return Database::select($query, $params);
        } catch (Exception $e) {
            error_log("Get Complaint Statistics Error: " . $e->getMessage());
            return [];
        }
    }
}

// API Endpoint Handlers
$controller = new ComplaintController();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Get complaints with filters
    $filters = [
        'student_id' => getQueryParam('student_id'),
        'hostel_id' => getQueryParam('hostel_id'),
        'category' => getQueryParam('category'),
        'status' => getQueryParam('status'),
        'priority' => getQueryParam('priority'),
        'from_date' => getQueryParam('from_date'),
        'to_date' => getQueryParam('to_date'),
        'page' => getQueryParam('page', 1),
        'limit' => getQueryParam('limit', 20)
    ];
    
    $result = $controller->getComplaints($filters);
    sendJsonResponse(true, 'Complaints retrieved successfully', $result);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = getJsonInput();
    
    // Submit complaint
    $errors = validateRequiredFields($data, ['student_id', 'hostel_id', 'category', 'subject', 'description']);
    
    if (!empty($errors)) {
        sendErrorResponse('Validation failed', $errors);
    }
    
    $complaintId = $controller->createComplaint($data);
    
    if ($complaintId) {
        sendJsonResponse(true, 'Complaint submitted successfully', ['complaint_id' => $complaintId], 201);
    } else {
        sendErrorResponse('Failed to submit complaint');
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'PUT' || $_SERVER['REQUEST_METHOD'] === 'PATCH') {
    if (!isset($_GET['id'])) {
        sendErrorResponse('Complaint ID is required');
    }
    
    $complaintId = intval($_GET['id']);
    $data = getJsonInput();
    
    // Status update (from Admin modal or status transition)
    if (isset($data['status'])) {
        $assignedTo = !empty($data['assigned_to']) ? intval($data['assigned_to']) : null;
        $notes = $data['resolution_notes'] ?? $data['notes'] ?? '';
        
        // If status is being marked as resolved and resolved_by is provided
        if ($data['status'] === 'resolved' && !empty($data['resolved_by'])) {
            $resolvedBy = intval($data['resolved_by']);
            $actualCost = isset($data['actual_cost']) ? floatval($data['actual_cost']) : null;
            $success = $controller->resolveComplaint($complaintId, $resolvedBy, $notes, $actualCost);
            if ($success) {
                sendJsonResponse(true, 'Complaint resolved successfully');
            } else {
                sendErrorResponse('Failed to resolve complaint');
            }
        }
        
        $success = $controller->updateComplaintStatus($complaintId, $data['status'], $assignedTo, $notes);
        if ($success) {
            sendJsonResponse(true, 'Complaint status updated successfully');
        } else {
            sendErrorResponse('Failed to update complaint status');
        }
    }
    
    // Explicit resolve complaint call
    if (isset($data['resolution_notes']) || isset($data['notes'])) {
        $resolvedBy = $data['resolved_by'] ?? ($data['assigned_to'] ?? 1);
        $notes = $data['resolution_notes'] ?? $data['notes'];
        $actualCost = isset($data['actual_cost']) ? floatval($data['actual_cost']) : null;
        
        $success = $controller->resolveComplaint($complaintId, $resolvedBy, $notes, $actualCost);
        if ($success) {
            sendJsonResponse(true, 'Complaint resolved successfully');
        } else {
            sendErrorResponse('Failed to resolve complaint');
        }
    }
    
    sendErrorResponse('No valid update parameters provided');
}
?>