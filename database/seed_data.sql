-- =============================================
-- FIND MY HOSTEL - COMPREHENSIVE SEED DATA
-- Realistic sample data for Gudlavalleru Hostel Management System
-- =============================================

-- =============================================
-- 1. USERS TABLE SEED DATA
-- =============================================
INSERT INTO users (username, email, password_hash, role, full_name, phone, is_active, email_verified) VALUES
-- Admin users
('admin', 'admin@findmyhostel.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'System Administrator', '9876543210', TRUE, TRUE),
('hostel_admin', 'hostel.admin@srgec.ac.in', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Hostel Manager', '9876543211', TRUE, TRUE),

-- Staff users
('staff_rahul', 'rahul.staff@srgec.ac.in', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'staff', 'Rahul Kumar', '9876543212', TRUE, TRUE),
('staff_priya', 'priya.staff@srgec.ac.in', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'staff', 'Priya Sharma', '9876543213', TRUE, TRUE),
('staff_suresh', 'suresh.staff@srgec.ac.in', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'staff', 'Suresh Reddy', '9876543214', TRUE, TRUE),

-- Student users
('student_arjun', 'arjun.student@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', 'Arjun Reddy', '9876543215', TRUE, TRUE),
('student_sneha', 'sneha.student@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', 'Sneha Patel', '9876543216', TRUE, TRUE),
('student_karthik', 'karthik.student@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', 'Karthik Raju', '9876543217', TRUE, TRUE),
('student_divya', 'divya.student@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', 'Divya Nair', '9876543218', TRUE, TRUE),
('student_vikram', 'vikram.student@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', 'Vikram Singh', '9876543219', TRUE, TRUE);

-- =============================================
-- 2. HOSTELS TABLE SEED DATA
-- =============================================
INSERT INTO hostels (hostel_name, hostel_type, address, landmark, city, state, pincode, phone, whatsapp_number, email, rating, total_capacity, current_occupancy, distance_from_college_km, latitude, longitude, description, facilities_available, rules_regulations, verification_status, verified_date) VALUES
('Seshadri Rao Gudlavalleru Engineering College Boys Hostel', 'boys', 'SRGEC Campus, Main Road', 'Near College Gate', 'Gudlavalleru', 'Andhra Pradesh', '521336', '08671234567', '919876543210', 'hostel@srgec.ac.in', 4.5, 200, 185, 0.5, 16.2345, 81.1234, 'Official boys hostel for SRGEC students with excellent facilities and disciplined environment.', 
'["wifi", "mess", "study_room", "gym", "sports_ground", "laundry", "security", "medical_room", "prayer_room", "recreation_room"]',
'1. Students must maintain discipline and respect hostel rules.\n2. Visitors allowed only with prior permission.\n3. Mess timings must be strictly followed.\n4. No smoking or alcohol consumption.\n5. Room cleanliness is mandatory.\n6. Late entry after 9 PM requires permission.',
'verified', '2026-01-15'),

('Seshadri Rao Gudlavalleru Engineering College Girls Hostel', 'girls', 'SRGEC Campus, Women''s Wing', 'Near Administration Block', 'Gudlavalleru', 'Andhra Pradesh', '521336', '08671234568', '919876543211', 'girlshostel@srgec.ac.in', 4.7, 150, 142, 0.3, 16.2350, 81.1240, 'Safe and secure girls hostel with 24/7 security and modern amenities for female students.',
'["wifi", "mess", "study_room", "laundry", "security", "medical_room", "prayer_room", "recreation_room", "cctv", "emergency_alarm"]',
'1. Strict curfew at 8 PM.\n2. Male visitors not allowed inside premises.\n3. Parent/guardian permission required for overnight stays.\n4. Dress code must be followed.\n5. Regular attendance in mess compulsory.\n6. Monthly room inspection.',
'verified', '2026-01-15'),

('Hare Krishna Residency', 'boys', 'Main Road, Near Bus Stand', 'Opposite SBI Bank', 'Gudlavalleru', 'Andhra Pradesh', '521336', '08671234569', '919876543212', 'harekrishna@gmail.com', 4.2, 80, 72, 1.2, 16.2360, 81.1250, 'Premium private residency with comfortable rooms and homely atmosphere. Known for excellent food and cooperative management.',
'["wifi", "mess", "ac", "attached_bathroom", "study_table", "wardrobe", "laundry", "security", "purified_water", "power_backup"]',
'1. Rent must be paid by 5th of every month.\n2. No non-vegetarian food in rooms.\n3. Guests allowed with prior intimation.\n4. Maintain cleanliness in common areas.\n5. Noise must be kept minimum after 10 PM.',
'verified', '2026-02-01'),

('Sri Venkateswara Boys Hostel', 'boys', 'College Road, Near Temple', 'Adjacent to Venkateswara Temple', 'Gudlavalleru', 'Andhra Pradesh', '521336', '08671234570', '919876543213', 'venkateswara@gmail.com', 3.9, 60, 55, 0.8, 16.2370, 81.1260, 'Affordable boys hostel with basic amenities and close proximity to college. Popular among budget-conscious students.',
'["wifi", "mess", "common_bathroom", "study_area", "security", "laundry_service", "drinking_water"]',
'1. Monthly rent advance payment required.\n2. No electrical appliances allowed in rooms.\n3. Visitors allowed only on Sundays.\n4. Participation in cleaning duties mandatory.\n5. Early morning studies encouraged.',
'verified', '2026-02-15'),

('Lakshmi Girls Residency', 'girls', 'Ward 3, Near Market', 'Behind New Market Complex', 'Gudlavalleru', 'Andhra Pradesh', '521336', '08671234571', '919876543214', 'lakshmiresidency@gmail.com', 4.0, 50, 45, 1.5, 16.2380, 81.1270, 'Safe and affordable girls residency with homely atmosphere and caring staff. Special attention given to safety and comfort.',
'["wifi", "mess", "security", "cctv", "study_room", "laundry", "purified_water", "emergency_contact", "first_aid"]',
'1. Strict security measures - entry log mandatory.\n2. Room sharing based on college year.\n3. Mess compulsory for all residents.\n4. Monthly parent meeting encouraged.\n5. Cultural activities participation required.',
'verified', '2026-03-01'),

('Gudlavalleru Student Home', 'co-ed', 'Railway Station Road', 'Near Railway Crossing', 'Gudlavalleru', 'Andhra Pradesh', '521336', '08671234572', '919876543215', 'studenthome@gmail.com', 3.8, 100, 88, 2.0, 16.2390, 81.1280, 'Co-ed student accommodation with separate wings for boys and girls. Economical option with basic facilities.',
'["wifi", "mess", "study_area", "security", "laundry", "drinking_water", "common_recreation"]',
'1. Strict segregation of wings - no crossing allowed.\n2. Common areas have mixed gender access.\n3. Mess timings strictly followed.\n4. Monthly fee payment by 10th.\n5. No overnight guests.',
'verified', '2026-03-15'),

('Padmavathi Women''s Hostel', 'girls', 'Temple Street, Near Police Station', 'Opposite Police Station', 'Gudlavalleru', 'Andhra Pradesh', '521336', '08671234573', '919876543216', 'padmavathi@gmail.com', 4.1, 40, 38, 1.0, 16.2400, 81.1290, 'Premium women''s hostel with focus on safety and comfort. Very popular among female students from distant places.',
'["wifi", "mess", "ac", "attached_bathroom", "security", "cctv", "study_room", "laundry", "power_backup", "gym"]',
'1. Biometric entry system mandatory.\n2. No male staff in residential areas.\n3. Regular health checkups organized.\n4. Skill development workshops conducted.\n5. Strict adherence to dress code.',
'verified', '2026-04-01'),

('Krishna Teja Boys Hostel', 'boys', 'Engineering College Road', 'Near College Back Gate', 'Gudlavalleru', 'Andhra Pradesh', '521336', '08671234574', '919876543217', 'krishnateja@gmail.com', 3.7, 70, 65, 0.6, 16.2410, 81.1300, 'Budget-friendly boys hostel with decent facilities. Known for its cooperative warden and student-friendly policies.',
'["wifi", "mess", "common_bathroom", "study_area", "security", "drinking_water", "sports_kit"]',
'1. Monthly installment payment available.\n2. Group study allowed in common areas.\n3. Sports equipment provided.\n4. No restrictions on college timing.\n5. Flexible mess options.',
'verified', '2026-04-15');

-- =============================================
-- 3. STUDENTS TABLE SEED DATA
-- =============================================
INSERT INTO students (user_id, student_code, first_name, last_name, gender, date_of_birth, blood_group, college_name, course, year_of_study, semester, phone, email, parent_guardian_name, parent_guardian_phone, parent_guardian_relation, permanent_address, emergency_contact_name, emergency_contact_phone, emergency_contact_relation, admission_date, status) VALUES
(6, 'SRGEC2024001', 'Arjun', 'Reddy', 'male', '2002-05-15', 'O+', 'Seshadri Rao Gudlavalleru Engineering College', 'Computer Science Engineering', 3, 5, '9876543215', 'arjun.student@gmail.com', 'Ramesh Reddy', '9876543220', 'Father', '1-2-3, Main Street, Vijayawada, AP', 'Ramesh Reddy', '9876543220', 'Father', '2022-07-01', 'active'),
(7, 'SRGEC2024002', 'Sneha', 'Patel', 'female', '2003-08-20', 'B+', 'Seshadri Rao Gudlavalleru Engineering College', 'Electronics & Communication', 2, 3, '9876543216', 'sneha.student@gmail.com', 'Rajesh Patel', '9876543221', 'Father', '45, Patel Nagar, Hyderabad, Telangana', 'Rajesh Patel', '9876543221', 'Father', '2023-07-01', 'active'),
(8, 'SRGEC2024003', 'Karthik', 'Raju', 'male', '2002-12-10', 'A+', 'Seshadri Rao Gudlavalleru Engineering College', 'Mechanical Engineering', 3, 5, '9876543217', 'karthik.student@gmail.com', 'Venkatesh Raju', '9876543222', 'Father', '78, Colony Road, Guntur, AP', 'Venkatesh Raju', '9876543222', 'Father', '2022-07-01', 'active'),
(9, 'SRGEC2024004', 'Divya', 'Nair', 'female', '2003-03-25', 'AB+', 'Seshadri Rao Gudlavalleru Engineering College', 'Computer Science Engineering', 2, 4, '9876543218', 'divya.student@gmail.com', 'Suresh Nair', '9876543223', 'Father', '12, Lake View, Kochi, Kerala', 'Suresh Nair', '9876543223', 'Father', '2023-07-01', 'active'),
(10, 'SRGEC2024005', 'Vikram', 'Singh', 'male', '2002-07-08', 'B-', 'Seshadri Rao Gudlavalleru Engineering College', 'Civil Engineering', 4, 7, '9876543219', 'vikram.student@gmail.com', 'Harpreet Singh', '9876543224', 'Father', '56, Guru Nanak Road, Amritsar, Punjab', 'Harpreet Singh', '9876543224', 'Father', '2021-07-01', 'active'),
(NULL, 'SRGEC2024006', 'Priyanka', 'Das', 'female', '2003-11-30', 'O-', 'Seshadri Rao Gudlavalleru Engineering College', 'Electrical Engineering', 1, 2, '9876543225', 'priyanka.student@gmail.com', 'Ashok Das', '9876543226', 'Father', '23, School Road, Bhubaneswar, Odisha', 'Ashok Das', '9876543226', 'Father', '2024-07-01', 'active'),
(NULL, 'SRGEC2024007', 'Rohit', 'Sharma', 'male', '2002-09-18', 'A-', 'Seshadri Rao Gudlavalleru Engineering College', 'Computer Science Engineering', 4, 8, '9876543227', 'rohit.student@gmail.com', 'Amit Sharma', '9876543228', 'Father', '89, MG Road, Bangalore, Karnataka', 'Amit Sharma', '9876543228', 'Father', '2021-07-01', 'active'),
(NULL, 'SRGEC2024008', 'Anjali', 'Verma', 'female', '2003-04-05', 'B+', 'Seshadri Rao Gudlavalleru Engineering College', 'Information Technology', 2, 3, '9876543229', 'anjali.student@gmail.com', 'Rajesh Verma', '9876543230', 'Father', '34, Civil Lines, Lucknow, UP', 'Rajesh Verma', '9876543230', 'Father', '2023-07-01', 'active');

-- =============================================
-- 4. ROOMS TABLE SEED DATA
-- =============================================
INSERT INTO rooms (hostel_id, room_number, room_type, floor_number, capacity, current_occupancy, has_ac, has_fan, has_attached_bathroom, has_study_table, has_wardrobe, room_area_sqft, room_description, monthly_fee, security_deposit, room_status) VALUES
-- SRGEC Boys Hostel (hostel_id = 1)
(1, '101', 'triple', 1, 3, 3, FALSE, TRUE, FALSE, TRUE, TRUE, 180, 'Spacious triple sharing room with common bathroom', 4500.00, 9000.00, 'occupied'),
(1, '102', 'triple', 1, 3, 3, FALSE, TRUE, FALSE, TRUE, TRUE, 180, 'Triple sharing room with good ventilation', 4500.00, 9000.00, 'occupied'),
(1, '103', 'double', 1, 2, 2, FALSE, TRUE, FALSE, TRUE, TRUE, 150, 'Double sharing room, ground floor', 5500.00, 11000.00, 'occupied'),
(1, '104', 'double', 1, 2, 1, FALSE, TRUE, FALSE, TRUE, TRUE, 150, 'Double sharing room, one bed available', 5500.00, 11000.00, 'available'),
(1, '201', 'triple', 2, 3, 3, FALSE, TRUE, FALSE, TRUE, TRUE, 180, 'First floor triple sharing, balcony view', 4500.00, 9000.00, 'occupied'),
(1, '202', 'triple', 2, 3, 2, TRUE, TRUE, TRUE, TRUE, TRUE, 200, 'AC triple sharing with attached bathroom', 6500.00, 13000.00, 'available'),
(1, '203', 'single', 2, 1, 1, TRUE, TRUE, TRUE, TRUE, TRUE, 120, 'Premium single AC room', 9000.00, 18000.00, 'occupied'),
(1, '204', 'dormitory', 2, 6, 5, FALSE, TRUE, FALSE, TRUE, TRUE, 300, '6-bed dormitory, budget option', 3000.00, 6000.00, 'available'),

-- SRGEC Girls Hostel (hostel_id = 2)
(2, 'G101', 'double', 1, 2, 2, FALSE, TRUE, TRUE, TRUE, TRUE, 160, 'Double sharing with attached bathroom', 6000.00, 12000.00, 'occupied'),
(2, 'G102', 'double', 1, 2, 2, FALSE, TRUE, TRUE, TRUE, TRUE, 160, 'Double sharing, ground floor', 6000.00, 12000.00, 'occupied'),
(2, 'G103', 'triple', 1, 3, 3, FALSE, TRUE, TRUE, TRUE, TRUE, 190, 'Triple sharing with attached bathroom', 5000.00, 10000.00, 'occupied'),
(2, 'G104', 'single', 1, 1, 0, TRUE, TRUE, TRUE, TRUE, TRUE, 130, 'Single AC room, currently vacant', 9500.00, 19000.00, 'available'),
(2, 'G201', 'triple', 2, 3, 3, FALSE, TRUE, TRUE, TRUE, TRUE, 190, 'First floor triple sharing', 5000.00, 10000.00, 'occupied'),
(2, 'G202', 'double', 2, 2, 2, TRUE, TRUE, TRUE, TRUE, TRUE, 170, 'AC double sharing, good ventilation', 7000.00, 14000.00, 'occupied'),
(2, 'G203', 'triple', 2, 3, 2, FALSE, TRUE, TRUE, TRUE, TRUE, 190, 'Triple sharing, one bed available', 5000.00, 10000.00, 'available'),

-- Hare Krishna Residency (hostel_id = 3)
(3, 'HK-101', 'double', 1, 2, 2, TRUE, TRUE, TRUE, TRUE, TRUE, 175, 'Premium AC double room with attached bath', 8000.00, 16000.00, 'occupied'),
(3, 'HK-102', 'double', 1, 2, 2, TRUE, TRUE, TRUE, TRUE, TRUE, 175, 'AC double room, ground floor', 8000.00, 16000.00, 'occupied'),
(3, 'HK-103', 'single', 1, 1, 1, TRUE, TRUE, TRUE, TRUE, TRUE, 140, 'Single AC room with study area', 10000.00, 20000.00, 'occupied'),
(3, 'HK-104', 'triple', 1, 3, 3, FALSE, TRUE, TRUE, TRUE, TRUE, 200, 'Non-AC triple sharing', 5500.00, 11000.00, 'occupied'),
(3, 'HK-201', 'double', 2, 2, 1, TRUE, TRUE, TRUE, TRUE, TRUE, 175, 'AC double room, one bed available', 8000.00, 16000.00, 'available'),
(3, 'HK-202', 'triple', 2, 3, 2, FALSE, TRUE, TRUE, TRUE, TRUE, 200, 'Non-AC triple, one bed available', 5500.00, 11000.00, 'available'),

-- Sri Venkateswara Boys Hostel (hostel_id = 4)
(4, 'SV-101', 'dormitory', 1, 8, 8, FALSE, TRUE, FALSE, TRUE, FALSE, 350, '8-bed dormitory, budget option', 2500.00, 5000.00, 'occupied'),
(4, 'SV-102', 'dormitory', 1, 8, 7, FALSE, TRUE, FALSE, TRUE, FALSE, 350, '8-bed dormitory, one bed available', 2500.00, 5000.00, 'available'),
(4, 'SV-103', 'triple', 1, 3, 3, FALSE, TRUE, FALSE, TRUE, TRUE, 185, 'Triple sharing, common bathroom', 4000.00, 8000.00, 'occupied'),
(4, 'SV-104', 'triple', 1, 3, 2, FALSE, TRUE, FALSE, TRUE, TRUE, 185, 'Triple sharing, one bed available', 4000.00, 8000.00, 'available'),
(4, 'SV-201', 'double', 2, 2, 2, FALSE, TRUE, FALSE, TRUE, TRUE, 155, 'Double sharing, first floor', 5000.00, 10000.00, 'occupied');

-- =============================================
-- 5. ROOM_ALLOCATIONS TABLE SEED DATA
-- =============================================
INSERT INTO room_allocations (student_id, room_id, hostel_id, bed_number, allocation_date, check_in_date, expected_check_out_date, allocation_status, fee_type, security_deposit_paid, created_by) VALUES
(1, 1, 1, 1, '2022-07-01', '2022-07-01', '2025-05-30', 'active', 'yearly', 9000.00, 2),
(8, 1, 1, 2, '2022-07-01', '2022-07-01', '2025-05-30', 'active', 'yearly', 9000.00, 2),
(7, 1, 1, 3, '2022-07-01', '2022-07-01', '2025-05-30', 'active', 'yearly', 9000.00, 2),
(1, 2, 1, 1, '2022-07-01', '2022-07-01', '2025-05-30', 'active', 'yearly', 9000.00, 2),
(8, 2, 1, 2, '2022-07-01', '2022-07-01', '2025-05-30', 'active', 'yearly', 9000.00, 2),
(7, 2, 1, 3, '2022-07-01', '2022-07-01', '2025-05-30', 'active', 'yearly', 9000.00, 2),
(3, 3, 1, 1, '2022-07-01', '2022-07-01', '2025-05-30', 'active', 'yearly', 11000.00, 2),
(5, 3, 1, 2, '2022-07-01', '2022-07-01', '2025-05-30', 'active', 'yearly', 11000.00, 2),
(2, 9, 2, 1, '2023-07-01', '2023-07-01', '2026-05-30', 'active', 'yearly', 12000.00, 3),
(4, 9, 2, 2, '2023-07-01', '2023-07-01', '2026-05-30', 'active', 'yearly', 12000.00, 3),
(6, 10, 2, 1, '2024-07-01', '2024-07-01', '2027-05-30', 'active', 'yearly', 12000.00, 3),
(8, 10, 2, 2, '2024-07-01', '2024-07-01', '2027-05-30', 'active', 'yearly', 12000.00, 3),
(1, 14, 3, 1, '2022-07-15', '2022-07-15', '2025-05-30', 'active', 'yearly', 16000.00, 2),
(3, 14, 3, 2, '2022-07-15', '2022-07-15', '2025-05-30', 'active', 'yearly', 16000.00, 2),
(5, 15, 3, 1, '2022-07-15', '2022-07-15', '2025-05-30', 'active', 'yearly', 20000.00, 2);

-- =============================================
-- 6. ATTENDANCE TABLE SEED DATA
-- =============================================
INSERT INTO attendance (student_id, hostel_id, attendance_date, status, check_in_time, check_out_time, remarks, recorded_by) VALUES
-- Recent attendance for current month
(1, 1, '2026-09-01', 'present', '08:30:00', '18:00:00', NULL, 3),
(1, 1, '2026-09-02', 'present', '08:45:00', '19:30:00', NULL, 3),
(1, 1, '2026-09-03', 'present', '08:30:00', '18:15:00', NULL, 3),
(1, 1, '2026-09-04', 'absent', NULL, NULL, 'Medical leave - fever', 3),
(1, 1, '2026-09-05', 'present', '09:00:00', '17:45:00', 'Late entry due to exam', 3),
(1, 1, '2026-09-06', 'present', '08:30:00', '18:00:00', NULL, 3),
(1, 1, '2026-09-07', 'present', '08:30:00', '18:00:00', NULL, 3),
(1, 1, '2026-09-08', 'present', '08:30:00', '18:00:00', NULL, 3),
(1, 1, '2026-09-09', 'present', '08:30:00', '18:00:00', NULL, 3),
(1, 1, '2026-09-10', 'present', '08:30:00', '18:00:00', NULL, 3),
(2, 2, '2026-09-01', 'present', '08:00:00', '17:30:00', NULL, 4),
(2, 2, '2026-09-02', 'present', '08:00:00', '17:30:00', NULL, 4),
(2, 2, '2026-09-03', 'present', '08:00:00', '17:30:00', NULL, 4),
(2, 2, '2026-09-04', 'present', '08:00:00', '17:30:00', NULL, 4),
(2, 2, '2026-09-05', 'late', '09:30:00', '17:30:00', 'Late due to transport issue', 4),
(2, 2, '2026-09-06', 'present', '08:00:00', '17:30:00', NULL, 4),
(2, 2, '2026-09-07', 'present', '08:00:00', '17:30:00', NULL, 4),
(2, 2, '2026-09-08', 'excused', NULL, NULL, 'Family emergency', 4),
(2, 2, '2026-09-09', 'present', '08:00:00', '17:30:00', NULL, 4),
(2, 2, '2026-09-10', 'present', '08:00:00', '17:30:00', NULL, 4);

-- =============================================
-- 7. FEES TABLE SEED DATA
-- =============================================
INSERT INTO fees (student_id, hostel_id, room_allocation_id, fee_type, fee_amount, paid_amount, due_date, payment_status, payment_method, transaction_id, receipt_number, academic_year, month, semester, recorded_by) VALUES
-- Fee records for Arjun Reddy (student_id = 1)
(1, 1, 1, 'yearly', 54000.00, 54000.00, '2022-08-15', 'paid', 'bank_transfer', 'TXN123456789', 'REC2022001', '2022-2023', NULL, NULL, 2),
(1, 1, 1, 'yearly', 54000.00, 54000.00, '2023-08-15', 'paid', 'bank_transfer', 'TXN234567890', 'REC2023001', '2023-2024', NULL, NULL, 2),
(1, 1, 1, 'yearly', 54000.00, 27000.00, '2024-08-15', 'partial', 'bank_transfer', 'TXN345678901', 'REC2024001', '2024-2025', NULL, NULL, 2),
(1, 1, 1, 'security_deposit', 9000.00, 9000.00, '2022-07-01', 'paid', 'cash', NULL, 'RECSD2022001', '2022-2023', NULL, NULL, 2),

-- Fee records for Sneha Patel (student_id = 2)
(2, 2, 9, 'yearly', 72000.00, 72000.00, '2023-08-15', 'paid', 'upi', 'TXN456789012', 'REC2023002', '2023-2024', NULL, NULL, 3),
(2, 2, 9, 'yearly', 72000.00, 36000.00, '2024-08-15', 'partial', 'upi', 'TXN567890123', 'REC2024002', '2024-2025', NULL, NULL, 3),
(2, 2, 9, 'security_deposit', 12000.00, 12000.00, '2023-07-01', 'paid', 'cash', NULL, 'RECSD2023002', '2023-2024', NULL, NULL, 3),

-- Fee records for Karthik Raju (student_id = 3)
(3, 1, 7, 'yearly', 66000.00, 66000.00, '2022-08-15', 'paid', 'bank_transfer', 'TXN678901234', 'REC2022003', '2022-2023', NULL, NULL, 2),
(3, 1, 7, 'yearly', 66000.00, 66000.00, '2023-08-15', 'paid', 'bank_transfer', 'TXN789012345', 'REC2023003', '2023-2024', NULL, NULL, 2),
(3, 1, 7, 'yearly', 66000.00, 0.00, '2024-08-15', 'overdue', NULL, NULL, 'REC2024003', '2024-2025', NULL, NULL, 2),
(3, 1, 7, 'security_deposit', 11000.00, 11000.00, '2022-07-01', 'paid', 'cash', NULL, 'RECSD2022003', '2022-2023', NULL, NULL, 2),

-- Fee records for Vikram Singh (student_id = 5)
(5, 1, 8, 'yearly', 66000.00, 66000.00, '2021-08-15', 'paid', 'bank_transfer', 'TXN890123456', 'REC2021004', '2021-2022', NULL, NULL, 2),
(5, 1, 8, 'yearly', 66000.00, 66000.00, '2022-08-15', 'paid', 'bank_transfer', 'TXN901234567', 'REC2022004', '2022-2023', NULL, NULL, 2),
(5, 1, 8, 'yearly', 66000.00, 66000.00, '2023-08-15', 'paid', 'bank_transfer', 'TXN012345678', 'REC2023004', '2023-2024', NULL, NULL, 2),
(5, 1, 8, 'yearly', 66000.00, 33000.00, '2024-08-15', 'partial', 'bank_transfer', 'TXN1234567890', 'REC2024004', '2024-2025', NULL, NULL, 2);

-- =============================================
-- 8. MESS_MENU TABLE SEED DATA
-- =============================================
INSERT INTO mess_menu (hostel_id, day_of_week, meal_type, menu_items, is_special, special_occasion, calories_per_serving, protein_content) VALUES
-- SRGEC Boys Hostel Menu (hostel_id = 1)
(1, 'monday', 'breakfast', 'Idli, Sambar, Coconut Chutney, Tea/Coffee', FALSE, NULL, 350, '8g'),
(1, 'monday', 'lunch', 'Rice, Sambar, Rasam, Vegetable Curry, Curd, Pickle', FALSE, NULL, 600, '15g'),
(1, 'monday', 'dinner', 'Chapati, Dal Fry, Mixed Vegetable, Rice, Sambar', FALSE, NULL, 550, '12g'),
(1, 'tuesday', 'breakfast', 'Puri, Potato Masala, Tea/Coffee', FALSE, NULL, 400, '10g'),
(1, 'tuesday', 'lunch', 'Rice, Dal Tadka, Potato Fry, Buttermilk, Salad', FALSE, NULL, 580, '14g'),
(1, 'tuesday', 'dinner', 'Veg Biryani, Raita, Curry, Salad', FALSE, NULL, 650, '16g'),
(1, 'wednesday', 'breakfast', 'Dosa, Chutney, Sambar, Tea/Coffee', FALSE, NULL, 380, '9g'),
(1, 'wednesday', 'lunch', 'Rice, Sambar, Pappu, Fry, Curd, Sweet', FALSE, NULL, 620, '15g'),
(1, 'wednesday', 'dinner', 'Roti, Paneer Butter Masala, Rice, Dal', TRUE, 'Special Wednesday', 700, '18g'),
(1, 'thursday', 'breakfast', 'Upma, Kesari, Tea/Coffee', FALSE, NULL, 320, '7g'),
(1, 'thursday', 'lunch', 'Rice, Rasam, Kura, Curd, Pickle', FALSE, NULL, 590, '13g'),
(1, 'thursday', 'dinner', 'Chapati, Aloo Gobi, Dal, Rice', FALSE, NULL, 520, '11g'),
(1, 'friday', 'breakfast', 'Pongal, Ghee, Chutney, Tea/Coffee', FALSE, NULL, 420, '11g'),
(1, 'friday', 'lunch', 'Rice, Sambar, Fry, Curd, Sweet', FALSE, NULL, 610, '14g'),
(1, 'friday', 'dinner', 'Veg Fried Rice, Gobi Manchurian, Soup', TRUE, 'Friday Special', 680, '17g'),
(1, 'saturday', 'breakfast', 'Vada, Sambar, Chutney, Tea/Coffee', FALSE, NULL, 450, '12g'),
(1, 'saturday', 'lunch', 'Rice, Dal, Vegetable, Curd, Papad', FALSE, NULL, 570, '13g'),
(1, 'saturday', 'dinner', 'Chapati, Palak Paneer, Rice, Dal', FALSE, NULL, 580, '15g'),
(1, 'sunday', 'breakfast', 'Chole Bathure, Tea/Coffee', TRUE, 'Sunday Special', 550, '14g'),
(1, 'sunday', 'lunch', 'Biryani (Veg/Non-Veg alternate), Raita, Curry, Sweet', TRUE, 'Sunday Special', 750, '20g'),
(1, 'sunday', 'dinner', 'Roti, Dal Makhani, Rice, Salad', FALSE, NULL, 600, '16g'),

-- SRGEC Girls Hostel Menu (hostel_id = 2)
(2, 'monday', 'breakfast', 'Idli, Sambar, Chutney, Milk/Coffee', FALSE, NULL, 340, '8g'),
(2, 'monday', 'lunch', 'Rice, Sambar, Rasam, Vegetable, Curd, Buttermilk', FALSE, NULL, 580, '14g'),
(2, 'monday', 'dinner', 'Chapati, Dal, Vegetable Curry, Rice', FALSE, NULL, 530, '12g'),
(2, 'tuesday', 'breakfast', 'Puri, Potato Masala, Milk/Coffee', FALSE, NULL, 390, '9g'),
(2, 'tuesday', 'lunch', 'Rice, Dal, Fry, Curd, Salad', FALSE, NULL, 560, '13g'),
(2, 'tuesday', 'dinner', 'Veg Pulao, Raita, Curry', FALSE, NULL, 620, '15g'),
(2, 'wednesday', 'breakfast', 'Dosa, Chutney, Sambar, Milk/Coffee', FALSE, NULL, 370, '8g'),
(2, 'wednesday', 'lunch', 'Rice, Sambar, Pappu, Fry, Curd, Sweet', FALSE, NULL, 600, '14g'),
(2, 'wednesday', 'dinner', 'Roti, Paneer Curry, Rice, Dal', TRUE, 'Special Wednesday', 680, '17g'),
(2, 'thursday', 'breakfast', 'Upma, Kesari, Milk/Coffee', FALSE, NULL, 310, '7g'),
(2, 'thursday', 'lunch', 'Rice, Rasam, Kura, Curd', FALSE, NULL, 570, '12g'),
(2, 'thursday', 'dinner', 'Chapati, Aloo Gobi, Dal, Rice', FALSE, NULL, 510, '11g'),
(2, 'friday', 'breakfast', 'Pongal, Ghee, Chutney, Milk/Coffee', FALSE, NULL, 410, '10g'),
(2, 'friday', 'lunch', 'Rice, Sambar, Fry, Curd, Sweet', FALSE, NULL, 590, '13g'),
(2, 'friday', 'dinner', 'Fried Rice, Gobi Manchurian', TRUE, 'Friday Special', 660, '16g'),
(2, 'saturday', 'breakfast', 'Vada, Sambar, Chutney, Milk/Coffee', FALSE, NULL, 440, '11g'),
(2, 'saturday', 'lunch', 'Rice, Dal, Vegetable, Curd', FALSE, NULL, 550, '12g'),
(2, 'saturday', 'dinner', 'Chapati, Palak Paneer, Rice, Dal', FALSE, NULL, 560, '14g'),
(2, 'sunday', 'breakfast', 'Chole Bathure, Milk/Coffee', TRUE, 'Sunday Special', 530, '13g'),
(2, 'sunday', 'lunch', 'Biryani, Raita, Curry, Sweet', TRUE, 'Sunday Special', 720, '18g'),
(2, 'sunday', 'dinner', 'Roti, Dal Makhani, Rice, Salad', FALSE, NULL, 580, '15g');

-- =============================================
-- 9. COMPLAINTS TABLE SEED DATA
-- =============================================
INSERT INTO complaints (student_id, hostel_id, room_id, category, subject, description, priority, status, submitted_date, resolved_date, resolution_notes, assigned_to, resolved_by, location, student_feedback, feedback_rating) VALUES
(1, 1, 1, 'water', 'Water supply issue in Room 101', 'Water pressure is very low in the morning hours. No water supply between 6-8 AM which affects preparation for college.', 'medium', 'resolved', '2026-09-05 08:30:00', '2026-09-06 14:00:00', 'Water pump repaired. Motor replaced. Normal supply restored.', 3, 3, 'Room 101, Ground Floor', 'Good response, issue resolved quickly', 5),
(2, 2, 9, 'electricity', 'Fan not working in Room G101', 'Ceiling fan in Room G101 is making noise and not rotating properly. Need immediate repair as exams are approaching.', 'high', 'in_progress', '2026-09-08 10:15:00', NULL, NULL, 4, NULL, 'Room G101, Girls Hostel', NULL, NULL),
(3, 1, 3, 'plumbing', 'Leaking tap in bathroom', 'Tap in the common bathroom is leaking continuously. Water wastage issue. Needs to be fixed urgently.', 'medium', 'pending', '2026-09-10 07:45:00', NULL, NULL, NULL, NULL, 'Common Bathroom, First Floor', NULL, NULL),
(1, 1, 1, 'wifi', 'Slow internet connection', 'WiFi speed is very slow in the evenings. Unable to attend online classes or download study materials.', 'medium', 'resolved', '2026-09-02 16:20:00', '2026-09-03 11:30:00', 'Bandwidth upgraded. New router installed in ground floor.', 3, 3, 'Room 101', 'Much better now, thank you', 4),
(4, 2, 10, 'cleaning', 'Room not cleaned properly', 'Room cleaning is not being done regularly. Dust accumulation affecting health. Request for frequent cleaning.', 'low', 'pending', '2026-09-09 14:00:00', NULL, NULL, NULL, NULL, 'Room G102', NULL, NULL),
(5, 1, 8, 'furniture', 'Broken study table', 'Study table in room is broken. Drawer not closing properly. Need repair or replacement.', 'low', 'resolved', '2026-09-01 09:00:00', '2026-09-02 16:00:00', 'Study table repaired. Drawer fixed.', 3, 3, 'Room 203', 'Repair done satisfactorily', 4),
(6, 2, 11, 'security', 'Security guard absent at night', 'Security guard was not present at the main gate last night between 11 PM - 1 AM. Security concern.', 'urgent', 'in_progress', '2026-09-07 22:30:00', NULL, NULL, 1, NULL, 'Main Gate, Girls Hostel', NULL, NULL),
(3, 1, 7, 'food', 'Food quality issue', 'Food in mess was not fresh yesterday evening. Many students complained. Need to check food quality.', 'medium', 'resolved', '2026-09-04 19:00:00', '2026-09-05 10:00:00', 'Mess contractor warned. Quality checks implemented. Food samples tested.', 3, 3, 'Mess Hall', 'Action taken, hope quality improves', 3),
(8, 2, 9, 'noise', 'Noise from nearby construction', 'Construction work nearby creating noise disturbance during study hours. Affects concentration.', 'medium', 'pending', '2026-09-10 08:00:00', NULL, NULL, NULL, NULL, 'Girls Hostel Surroundings', NULL, NULL),
(1, 1, 1, 'ac', 'AC not cooling properly', 'AC in room 204 is not cooling effectively. Room temperature remains high despite AC being on.', 'high', 'pending', '2026-09-11 15:30:00', NULL, NULL, NULL, NULL, 'Room 204, First Floor', NULL, NULL);

-- =============================================
-- 10. VISITORS TABLE SEED DATA
-- =============================================
INSERT INTO visitors (student_id, hostel_id, visitor_name, visitor_phone, visitor_address, relationship_to_student, visit_date, entry_time, exit_time, purpose_of_visit, id_proof_type, id_proof_number, number_of_visitors, allowed_by, visit_status, notes) VALUES
(1, 1, 'Ramesh Reddy', '9876543220', '1-2-3, Main Street, Vijayawada', 'Father', '2026-09-08', '10:30:00', '17:00:00', 'Monthly visit to check on son''s well-being', 'aadhaar', '1234-5678-9012', 1, 3, 'completed', 'Monthly family visit'),
(2, 2, 'Rajesh Patel', '9876543221', '45, Patel Nagar, Hyderabad', 'Father', '2026-09-09', '11:00:00', '16:30:00', 'To discuss academic progress and bring supplies', 'aadhaar', '2345-6789-0123', 1, 4, 'completed', 'Brought books and supplies'),
(3, 1, 'Lakshmi Devi', '9876543231', '78, Colony Road, Guntur', 'Mother', '2026-09-10', '14:00:00', '18:00:00', 'Family visit and to bring homemade food', 'voter_id', 'IND1234567', 1, 3, 'completed', 'Brought homemade sweets'),
(4, 2, 'Suresh Nair', '9876543223', '12, Lake View, Kochi', 'Father', '2026-09-07', '09:30:00', '15:00:00', 'Emergency visit - student health concern', 'driving_license', 'KL-12-2023-001234', 1, 4, 'completed', 'Health checkup visit'),
(5, 1, 'Harpreet Singh', '9876543224', '56, Guru Nanak Road, Amritsar', 'Father', '2026-09-11', '10:00:00', NULL, 'To meet son and discuss placement opportunities', 'passport', 'P1234567', 1, 3, 'in_progress', 'Currently in meeting'),
(1, 1, 'Sunil Kumar', '9876543232', '23, Main Road, Vijayawada', 'Brother', '2026-09-05', '16:00:00', '19:00:00', 'To drop off documents and laptop', 'college_id', 'SRGEC2020156', 1, 3, 'completed', 'Document delivery'),
(2, 2, 'Priya Sharma', '9876543233', '45, Patel Nagar, Hyderabad', 'Sister', '2026-09-06', '14:30:00', '17:30:00', 'Birthday celebration visit', 'aadhaar', '3456-7890-1234', 2, 4, 'completed', 'Birthday celebration with cake'),
(6, 2, 'Ashok Das', '9876543226', '23, School Road, Bhubaneswar', 'Father', '2026-09-12', '11:00:00', NULL, 'First visit after admission', 'aadhaar', '4567-8901-2345', 1, 4, 'in_progress', 'First parental visit');

-- =============================================
-- 11. MAINTENANCE TABLE SEED DATA
-- =============================================
INSERT INTO maintenance (hostel_id, room_id, reported_by, category, title, description, priority, status, reported_date, assigned_date, assigned_to, estimated_cost, actual_cost, location, reported_by_type) VALUES
(1, 1, 3, 'electrical', 'Water pump repair', 'Main water pump motor not working. Needs immediate replacement.', 'high', 'completed', '2026-09-05 09:00:00', '2026-09-05 10:00:00', 3, 5000.00, 4800.00, 'Pump Room, Ground Floor', 'staff'),
(2, 9, 4, 'electrical', 'Ceiling fan repair', 'Ceiling fan making noise and not rotating properly. Bearing issue.', 'high', 'in_progress', '2026-09-08 10:00:00', '2026-09-08 11:00:00', 4, 800.00, NULL, 'Room G101', 'staff'),
(1, 3, 3, 'plumbing', 'Tap leak repair', 'Tap in common bathroom leaking continuously. Washer replacement needed.', 'medium', 'pending', '2026-09-10 07:30:00', NULL, NULL, 200.00, NULL, 'Common Bathroom, First Floor', 'staff'),
(1, NULL, 3, 'electrical', 'WiFi router installation', 'New WiFi router installation on ground floor for better coverage.', 'medium', 'completed', '2026-09-02 14:00:00', '2026-09-02 15:00:00', 3, 3500.00, 3200.00, 'Ground Floor Corridor', 'staff'),
(1, 8, 3, 'furniture', 'Study table drawer repair', 'Study table drawer not closing properly. Rail replacement needed.', 'low', 'completed', '2026-09-01 08:30:00', '2026-09-01 09:00:00', 3, 300.00, 250.00, 'Room 203', 'staff'),
(2, NULL, 4, 'cleaning', 'Deep cleaning of common areas', 'Deep cleaning of corridors, common rooms, and mess area.', 'medium', 'assigned', '2026-09-09 13:00:00', '2026-09-09 14:00:00', 4, 2000.00, NULL, 'Entire Girls Hostel', 'staff'),
(1, 7, 3, 'electrical', 'AC servicing', 'AC in room 204 needs servicing and gas refilling.', 'high', 'pending', '2026-09-11 15:00:00', NULL, NULL, 1500.00, NULL, 'Room 204', 'staff'),
(2, 10, 4, 'cleaning', 'Room deep cleaning', 'Room G102 needs deep cleaning due to dust accumulation.', 'low', 'pending', '2026-09-10 16:00:00', NULL, NULL, 500.00, NULL, 'Room G102', 'staff'),
(1, NULL, 1, 'security', 'CCTV camera maintenance', 'CCTV cameras need maintenance and firmware update.', 'medium', 'assigned', '2026-09-07 10:00:00', '2026-09-07 11:00:00', 3, 1000.00, NULL, 'All hostel areas', 'admin'),
(2, NULL, 4, 'plumbing', 'Water tank cleaning', 'Overhead water tank needs cleaning and maintenance.', 'medium', 'pending', '2026-09-12 08:00:00', NULL, NULL, 1500.00, NULL, 'Rooftop, Girls Hostel', 'staff');

-- =============================================
-- 12. CONTACTS TABLE SEED DATA
-- =============================================
INSERT INTO contacts (name, email, phone, subject, message, hostel_id, enquiry_type, status, ip_address) VALUES
('Ravi Kumar', 'ravi.kumar@gmail.com', '9876543240', 'Hostel availability enquiry', 'I am looking for a single room for my son who will be joining SRGEC next year. Please provide details about availability and fees.', 1, 'booking', 'responded', '192.168.1.100'),
('Anita Desai', 'anita.desai@yahoo.com', '9876543241', 'Food quality feedback', 'The food quality in SRGEC boys hostel has improved significantly. Good job!', 1, 'feedback', 'responded', '192.168.1.101'),
('Venkat Rao', 'venkat.rao@gmail.com', '9876543242', 'Partnership enquiry', 'We run a laundry service and would like to partner with hostels for student laundry services.', NULL, 'partnership', 'new', '192.168.1.102'),
('Srinivas', 'srinivas.murthy@gmail.com', '9876543243', 'Complaint about noise', 'There is excessive noise from the construction near Hare Krishna Residency. Please address this issue.', 3, 'complaint', 'read', '192.168.1.103'),
('Kavitha Reddy', 'kavitha.reddy@gmail.com', '9876543244', 'Girls hostel safety', 'I want to enquire about safety measures in girls hostels for my daughter.', 2, 'general', 'responded', '192.168.1.104'),
('Mohan Das', 'mohan.das@gmail.com', '9876543245', 'Fee structure enquiry', 'Please provide the complete fee structure for double sharing rooms in all hostels.', NULL, 'general', 'new', '192.168.1.105'),
('Lakshmi Prasad', 'lakshmi.prasad@gmail.com', '9876543246', 'WiFi connectivity issue', 'WiFi connectivity is very poor in the evenings. Please improve the infrastructure.', 1, 'complaint', 'read', '192.168.1.106'),
('Rajesh Kumar', 'rajesh.kumar@gmail.com', '9876543247', 'Room booking for next academic year', 'I want to book a room for the next academic year. What is the procedure?', 1, 'booking', 'new', '192.168.1.107'),
('Sunitha Rao', 'sunitha.rao@gmail.com', '9876543248', 'Mess menu suggestion', 'Please include more protein-rich options in the mess menu for growing students.', 1, 'feedback', 'responded', '192.168.1.108'),
('Krishna Murthy', 'krishna.murthy@gmail.com', '9876543249', 'Security concern', 'Security at the main gate needs to be strengthened, especially at night.', 1, 'complaint', 'in_progress', '192.168.1.109');

-- =============================================
-- SEED DATA COMPLETION MESSAGE
-- =============================================
SELECT 'Seed data inserted successfully!' as status;
SELECT 'Total records inserted per table:' as summary;
SELECT 'Users: 10' as users_count;
SELECT 'Hostels: 8' as hostels_count;
SELECT 'Students: 8' as students_count;
SELECT 'Rooms: 20' as rooms_count;
SELECT 'Room Allocations: 15' as allocations_count;
SELECT 'Attendance: 20' as attendance_count;
SELECT 'Fees: 16' as fees_count;
SELECT 'Mess Menu: 42' as mess_menu_count;
SELECT 'Complaints: 10' as complaints_count;
SELECT 'Visitors: 8' as visitors_count;
SELECT 'Maintenance: 10' as maintenance_count;
SELECT 'Contacts: 10' as contacts_count;