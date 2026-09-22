-- =============================================
-- FIND MY HOSTEL - COMPLETE DATABASE SCHEMA
-- Production-grade MySQL DDL for Gudlavalleru Hostel Management System
-- =============================================

-- Drop existing tables if they exist (for clean recreation)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS maintenance;
DROP TABLE IF EXISTS visitors;
DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS mess_menu;
DROP TABLE IF EXISTS fees;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS room_allocations;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS hostels;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS contacts;
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- 1. USERS TABLE
-- Authentication and user management
-- =============================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'staff', 'admin') NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    profile_picture VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 2. HOSTELS TABLE
-- Central hostel information registry
-- =============================================
CREATE TABLE hostels (
    hostel_id INT AUTO_INCREMENT PRIMARY KEY,
    hostel_name VARCHAR(100) NOT NULL,
    hostel_type ENUM('boys', 'girls', 'co-ed') NOT NULL,
    address TEXT NOT NULL,
    landmark VARCHAR(100),
    city VARCHAR(50) DEFAULT 'Gudlavalleru',
    state VARCHAR(50) DEFAULT 'Andhra Pradesh',
    pincode VARCHAR(10),
    phone VARCHAR(15) NOT NULL,
    whatsapp_number VARCHAR(15),
    email VARCHAR(100),
    website VARCHAR(255),
    rating DECIMAL(3,2) DEFAULT 0.00 CHECK (rating >= 0 AND rating <= 5),
    total_capacity INT DEFAULT 0,
    current_occupancy INT DEFAULT 0,
    distance_from_college_km DECIMAL(5,2) DEFAULT 0.00,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    google_maps_link VARCHAR(500),
    description TEXT,
    facilities_available JSON,
    rules_regulations TEXT,
    images JSON,
    verification_status ENUM('pending', 'verified', 'rejected') DEFAULT 'pending',
    verified_date DATE,
    admin_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_hostel_name (hostel_name),
    INDEX idx_hostel_type (hostel_type),
    INDEX idx_city (city),
    INDEX idx_rating (rating),
    INDEX idx_verification_status (verification_status),
    INDEX idx_distance (distance_from_college_km),
    FULLTEXT idx_search (hostel_name, address, landmark)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 3. STUDENTS TABLE
-- Student information and profiles
-- =============================================
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    student_code VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    date_of_birth DATE,
    blood_group VARCHAR(5),
    college_name VARCHAR(100) NOT NULL,
    course VARCHAR(100) NOT NULL,
    year_of_study INT NOT NULL CHECK (year_of_study >= 1 AND year_of_study <= 5),
    semester INT CHECK (semester >= 1 AND semester <= 10),
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    parent_guardian_name VARCHAR(100),
    parent_guardian_phone VARCHAR(15),
    parent_guardian_relation VARCHAR(50),
    permanent_address TEXT NOT NULL,
    current_address TEXT,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(15),
    emergency_contact_relation VARCHAR(50),
    profile_picture VARCHAR(255),
    admission_date DATE,
    status ENUM('active', 'inactive', 'graduated', 'suspended') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_student_code (student_code),
    INDEX idx_college (college_name),
    INDEX idx_course (course),
    INDEX idx_status (status),
    INDEX idx_gender (gender)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 4. ROOMS TABLE
-- Room inventory and specifications
-- =============================================
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    hostel_id INT NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    room_type ENUM('single', 'double', 'triple', 'dormitory', 'suite') NOT NULL,
    floor_number INT DEFAULT 1,
    capacity INT NOT NULL CHECK (capacity > 0),
    current_occupancy INT DEFAULT 0 CHECK (current_occupancy >= 0),
    available_beds INT GENERATED ALWAYS AS (capacity - current_occupancy) STORED,
    has_ac BOOLEAN DEFAULT FALSE,
    has_fan BOOLEAN DEFAULT TRUE,
    has_attached_bathroom BOOLEAN DEFAULT FALSE,
    has_study_table BOOLEAN DEFAULT TRUE,
    has_wardrobe BOOLEAN DEFAULT TRUE,
    room_area_sqft INT,
    room_description TEXT,
    monthly_fee DECIMAL(10,2) NOT NULL,
    yearly_fee DECIMAL(10,2) GENERATED ALWAYS AS (monthly_fee * 12) STORED,
    security_deposit DECIMAL(10,2),
    is_maintenance BOOLEAN DEFAULT FALSE,
    room_status ENUM('available', 'occupied', 'maintenance', 'reserved') DEFAULT 'available',
    images JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_room (hostel_id, room_number),
    INDEX idx_hostel_id (hostel_id),
    INDEX idx_room_type (room_type),
    INDEX idx_room_status (room_status),
    INDEX idx_monthly_fee (monthly_fee),
    INDEX idx_has_ac (has_ac)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 5. ROOM_ALLOCATIONS TABLE
-- Student room assignment and allocation history
-- =============================================
CREATE TABLE room_allocations (
    allocation_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    room_id INT NOT NULL,
    hostel_id INT NOT NULL,
    bed_number INT,
    allocation_date DATE NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE,
    expected_check_out_date DATE,
    allocation_status ENUM('active', 'completed', 'terminated', 'pending') DEFAULT 'active',
    fee_type ENUM('monthly', 'yearly', 'semester') DEFAULT 'yearly',
    security_deposit_paid DECIMAL(10,2) DEFAULT 0.00,
    security_deposit_returned DECIMAL(10,2) DEFAULT 0.00,
    security_deposit_return_date DATE,
    notes TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_room_id (room_id),
    INDEX idx_hostel_id (hostel_id),
    INDEX idx_allocation_status (allocation_status),
    INDEX idx_check_in_date (check_in_date),
    INDEX idx_check_out_date (check_out_date),
    UNIQUE KEY unique_active_allocation (student_id, allocation_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 6. ATTENDANCE TABLE
-- Student attendance tracking
-- =============================================
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    hostel_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('present', 'absent', 'late', 'excused', 'holiday') NOT NULL,
    check_in_time TIME,
    check_out_time TIME,
    remarks TEXT,
    recorded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    UNIQUE KEY unique_daily_attendance (student_id, attendance_date),
    INDEX idx_student_id (student_id),
    INDEX idx_hostel_id (hostel_id),
    INDEX idx_attendance_date (attendance_date),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 7. FEES TABLE
-- Fee payment and tracking
-- =============================================
CREATE TABLE fees (
    fee_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    hostel_id INT NOT NULL,
    room_allocation_id INT,
    fee_type ENUM('admission', 'monthly', 'yearly', 'semester', 'security_deposit', 'mess', 'other') NOT NULL,
    fee_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0.00,
    due_amount DECIMAL(10,2) GENERATED ALWAYS AS (fee_amount - paid_amount) STORED,
    payment_date DATE,
    due_date DATE NOT NULL,
    payment_status ENUM('pending', 'partial', 'paid', 'overdue', 'waived') DEFAULT 'pending',
    payment_method ENUM('cash', 'upi', 'bank_transfer', 'cheque', 'card', 'online') DEFAULT NULL,
    transaction_id VARCHAR(100),
    receipt_number VARCHAR(50),
    academic_year VARCHAR(20),
    month VARCHAR(20),
    semester INT,
    late_fee DECIMAL(10,2) DEFAULT 0.00,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    notes TEXT,
    recorded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_allocation_id) REFERENCES room_allocations(allocation_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_hostel_id (hostel_id),
    INDEX idx_payment_status (payment_status),
    INDEX idx_due_date (due_date),
    INDEX idx_fee_type (fee_type),
    INDEX idx_academic_year (academic_year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 8. MESS_MENU TABLE
-- Mess/food management and menu planning
-- =============================================
CREATE TABLE mess_menu (
    menu_id INT AUTO_INCREMENT PRIMARY KEY,
    hostel_id INT NOT NULL,
    day_of_week ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday') NOT NULL,
    meal_type ENUM('breakfast', 'lunch', 'dinner', 'snacks') NOT NULL,
    menu_items TEXT NOT NULL,
    is_special BOOLEAN DEFAULT FALSE,
    special_occasion VARCHAR(100),
    calories_per_serving INT,
    protein_content VARCHAR(50),
    notes TEXT,
    effective_from DATE DEFAULT (CURRENT_DATE),
    effective_to DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_menu_item (hostel_id, day_of_week, meal_type, effective_from),
    INDEX idx_hostel_id (hostel_id),
    INDEX idx_day_of_week (day_of_week),
    INDEX idx_meal_type (meal_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 9. COMPLAINTS TABLE
-- Student complaint management and resolution
-- =============================================
CREATE TABLE complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    hostel_id INT NOT NULL,
    room_id INT,
    category ENUM('water', 'electricity', 'plumbing', 'furniture', 'cleaning', 'food', 'wifi', 'security', 'noise', 'other') NOT NULL,
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    status ENUM('pending', 'in_progress', 'resolved', 'rejected', 'escalated') DEFAULT 'pending',
    submitted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_date TIMESTAMP NULL,
    resolution_notes TEXT,
    assigned_to INT,
    resolved_by INT,
    images JSON,
    location VARCHAR(100),
    anonymous BOOLEAN DEFAULT FALSE,
    student_feedback TEXT,
    feedback_rating INT CHECK (feedback_rating >= 1 AND feedback_rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (resolved_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_hostel_id (hostel_id),
    INDEX idx_status (status),
    INDEX idx_category (category),
    INDEX idx_priority (priority),
    INDEX idx_submitted_date (submitted_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 10. VISITORS TABLE
-- Visitor management and tracking
-- =============================================
CREATE TABLE visitors (
    visitor_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    hostel_id INT NOT NULL,
    visitor_name VARCHAR(100) NOT NULL,
    visitor_phone VARCHAR(15),
    visitor_address TEXT,
    relationship_to_student VARCHAR(50) NOT NULL,
    visit_date DATE NOT NULL,
    entry_time TIME NOT NULL,
    exit_time TIME,
    purpose_of_visit VARCHAR(200),
    id_proof_type ENUM('aadhaar', 'voter_id', 'driving_license', 'passport', 'college_id', 'other'),
    id_proof_number VARCHAR(50),
    number_of_visitors INT DEFAULT 1,
    items_brought TEXT,
    allowed_by INT,
    exit_approved_by INT,
    visit_status ENUM('in_progress', 'completed', 'denied', 'expired') DEFAULT 'in_progress',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (allowed_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (exit_approved_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_hostel_id (hostel_id),
    INDEX idx_visit_date (visit_date),
    INDEX idx_visit_status (visit_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 11. MAINTENANCE TABLE
-- Maintenance request and tracking
-- =============================================
CREATE TABLE maintenance (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    hostel_id INT NOT NULL,
    room_id INT,
    reported_by INT NOT NULL,
    category ENUM('electrical', 'plumbing', 'furniture', 'painting', 'cleaning', 'ac', 'internet', 'security', 'structural', 'other') NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    status ENUM('pending', 'assigned', 'in_progress', 'completed', 'cancelled', 'escalated') DEFAULT 'pending',
    reported_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_date TIMESTAMP NULL,
    completed_date TIMESTAMP NULL,
    assigned_to INT,
    estimated_cost DECIMAL(10,2),
    actual_cost DECIMAL(10,2),
    work_description TEXT,
    parts_used TEXT,
    before_images JSON,
    after_images JSON,
    location VARCHAR(100),
    reported_by_type ENUM('student', 'staff', 'admin') DEFAULT 'student',
    completion_notes TEXT,
    complaint_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (reported_by) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_hostel_id (hostel_id),
    INDEX idx_room_id (room_id),
    INDEX idx_complaint_id (complaint_id),
    INDEX idx_status (status),
    INDEX idx_category (category),
    INDEX idx_priority (priority),
    INDEX idx_reported_date (reported_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 12. CONTACTS TABLE
-- Website contact form and enquiries
-- =============================================
CREATE TABLE contacts (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    hostel_id INT,
    enquiry_type ENUM('general', 'booking', 'complaint', 'feedback', 'partnership', 'other') DEFAULT 'general',
    status ENUM('new', 'read', 'responded', 'closed', 'spam') DEFAULT 'new',
    ip_address VARCHAR(45),
    user_agent VARCHAR(255),
    responded_by INT,
    response_date TIMESTAMP NULL,
    response_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (responded_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_status (status),
    INDEX idx_enquiry_type (enquiry_type),
    INDEX idx_created_at (created_at),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- VIEWS FOR COMMON QUERIES
-- =============================================

-- View: Hostel Occupancy Summary
CREATE VIEW hostel_occupancy_summary AS
SELECT 
    h.hostel_id,
    h.hostel_name,
    h.hostel_type,
    h.total_capacity,
    h.current_occupancy,
    COUNT(r.room_id) as total_rooms,
    SUM(CASE WHEN r.room_status = 'available' THEN 1 ELSE 0 END) as available_rooms,
    SUM(CASE WHEN r.room_status = 'occupied' THEN 1 ELSE 0 END) as occupied_rooms,
    SUM(r.available_beds) as total_available_beds,
    ROUND((h.current_occupancy / h.total_capacity) * 100, 2) as occupancy_percentage
FROM hostels h
LEFT JOIN rooms r ON h.hostel_id = r.hostel_id
GROUP BY h.hostel_id, h.hostel_name, h.hostel_type, h.total_capacity, h.current_occupancy;

-- View: Student Fee Status
CREATE VIEW student_fee_status AS
SELECT 
    s.student_id,
    s.student_code,
    CONCAT(s.first_name, ' ', s.last_name) as student_name,
    s.college_name,
    s.course,
    s.year_of_study,
    h.hostel_name,
    r.room_number,
    SUM(f.fee_amount) as total_fees,
    SUM(f.paid_amount) as total_paid,
    SUM(f.due_amount) as total_due,
    SUM(CASE WHEN f.payment_status = 'overdue' THEN f.due_amount ELSE 0 END) as overdue_amount,
    COUNT(CASE WHEN f.payment_status = 'overdue' THEN 1 END) as overdue_count
FROM students s
LEFT JOIN room_allocations ra ON s.student_id = ra.student_id AND ra.allocation_status = 'active'
LEFT JOIN rooms r ON ra.room_id = r.room_id
LEFT JOIN hostels h ON r.hostel_id = h.hostel_id
LEFT JOIN fees f ON s.student_id = f.student_id
GROUP BY s.student_id, s.student_code, s.first_name, s.last_name, s.college_name, s.course, s.year_of_study, h.hostel_name, r.room_number;

-- View: Complaint Statistics
CREATE VIEW complaint_statistics AS
SELECT 
    h.hostel_id,
    h.hostel_name,
    COUNT(c.complaint_id) as total_complaints,
    SUM(CASE WHEN c.status = 'pending' THEN 1 ELSE 0 END) as pending_complaints,
    SUM(CASE WHEN c.status = 'in_progress' THEN 1 ELSE 0 END) as in_progress_complaints,
    SUM(CASE WHEN c.status = 'resolved' THEN 1 ELSE 0 END) as resolved_complaints,
    SUM(CASE WHEN c.priority = 'urgent' THEN 1 ELSE 0 END) as urgent_complaints,
    ROUND(AVG(CASE WHEN c.feedback_rating IS NOT NULL THEN c.feedback_rating END), 2) as average_feedback_rating
FROM hostels h
LEFT JOIN complaints c ON h.hostel_id = c.hostel_id
GROUP BY h.hostel_id, h.hostel_name;

-- =============================================
-- STORED PROCEDURES
-- =============================================

DELIMITER //

-- Procedure: Update hostel occupancy
CREATE PROCEDURE update_hostel_occupancy(IN p_hostel_id INT)
BEGIN
    UPDATE hostels h
    SET current_occupancy = (
        SELECT COALESCE(SUM(r.current_occupancy), 0)
        FROM rooms r
        WHERE r.hostel_id = p_hostel_id
    ),
    total_capacity = (
        SELECT COALESCE(SUM(r.capacity), 0)
        FROM rooms r
        WHERE r.hostel_id = p_hostel_id
    )
    WHERE h.hostel_id = p_hostel_id;
END //

-- Procedure: Check room availability
CREATE PROCEDURE check_room_availability(
    IN p_hostel_id INT,
    IN p_required_beds INT,
    OUT p_is_available BOOLEAN,
    OUT p_available_rooms INT
)
BEGIN
    SELECT 
        COUNT(*) INTO p_available_rooms
    FROM rooms
    WHERE hostel_id = p_hostel_id
    AND available_beds >= p_required_beds
    AND room_status = 'available';
    
    SET p_is_available = (p_available_rooms > 0);
END //

-- Procedure: Update room occupancy
CREATE PROCEDURE update_room_occupancy(IN p_room_id INT)
BEGIN
    UPDATE rooms r
    SET current_occupancy = (
        SELECT COUNT(*)
        FROM room_allocations ra
        WHERE ra.room_id = p_room_id
        AND ra.allocation_status = 'active'
    )
    WHERE r.room_id = p_room_id;
    
    -- Update hostel occupancy as well
    CALL update_hostel_occupancy((SELECT hostel_id FROM rooms WHERE room_id = p_room_id));
END //

DELIMITER ;

-- =============================================
-- TRIGGERS
-- =============================================

DELIMITER //

-- Trigger: Update room occupancy after allocation
CREATE TRIGGER after_room_allocation_insert
AFTER INSERT ON room_allocations
FOR EACH ROW
BEGIN
    CALL update_room_occupancy(NEW.room_id);
END //

-- Trigger: Update room occupancy after allocation update
CREATE TRIGGER after_room_allocation_update
AFTER UPDATE ON room_allocations
FOR EACH ROW
BEGIN
    IF OLD.room_id != NEW.room_id OR OLD.allocation_status != NEW.allocation_status THEN
        CALL update_room_occupancy(OLD.room_id);
        CALL update_room_occupancy(NEW.room_id);
    END IF;
END //

-- Trigger: Update room occupancy after allocation delete
CREATE TRIGGER after_room_allocation_delete
AFTER DELETE ON room_allocations
FOR EACH ROW
BEGIN
    CALL update_room_occupancy(OLD.room_id);
END //

DELIMITER ;

-- =============================================
-- SCHEMA COMPLETION MESSAGE
-- =============================================
SELECT 'Database schema created successfully!' as status;
SELECT 'Total tables created: 12' as table_count;
SELECT 'Views created: 3' as view_count;
SELECT 'Stored procedures created: 3' as procedure_count;
SELECT 'Triggers created: 3' as trigger_count;