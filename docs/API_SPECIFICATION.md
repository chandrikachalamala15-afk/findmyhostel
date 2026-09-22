# FIND MY HOSTEL - RESTful API Specification

## Complete API Documentation for Hostel Management System

### Base URL
```
http://localhost:8000/api/v1
```

### Authentication
- **Method**: JWT (JSON Web Token) based authentication
- **Header**: `Authorization: Bearer <token>`
- **Token Expiry**: 24 hours

---

## 1. AUTHENTICATION ENDPOINTS

### 1.1 User Registration
**POST** `/auth/register`

Register a new user (Student, Staff, or Admin)

**Request Body:**
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "SecurePass123!",
  "role": "student",
  "full_name": "John Doe",
  "phone": "9876543210"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user_id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "role": "student",
    "full_name": "John Doe",
    "is_active": true,
    "email_verified": false,
    "created_at": "2026-09-22T10:30:00Z"
  }
}
```

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Validation error",
  "errors": {
    "email": "Email already exists",
    "password": "Password must be at least 8 characters"
  }
}
```

---

### 1.2 User Login
**POST** `/auth/login`

Authenticate user and receive JWT token

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "SecurePass123!"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 86400,
    "user": {
      "user_id": 1,
      "username": "john_doe",
      "email": "john@example.com",
      "role": "student",
      "full_name": "John Doe",
      "profile_picture": null
    }
  }
}
```

**Error Response (401 Unauthorized):**
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

---

### 1.3 Logout
**POST** `/auth/logout`

Invalidate current session token

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

### 1.4 Refresh Token
**POST** `/auth/refresh`

Refresh expired JWT token

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 86400
  }
}
```

---

## 2. HOSTEL MANAGEMENT ENDPOINTS

### 2.1 Get All Hostels
**GET** `/hostels`

Retrieve all hostels with optional filtering

**Query Parameters:**
- `page` (int, default: 1) - Page number
- `limit` (int, default: 10) - Items per page
- `type` (enum: boys, girls, co-ed) - Filter by hostel type
- `min_price` (decimal) - Minimum monthly fee
- `max_price` (decimal) - Maximum monthly fee
- `has_ac` (boolean) - Filter by AC availability
- `has_wifi` (boolean) - Filter by WiFi availability
- `has_mess` (boolean) - Filter by mess availability
- `max_distance` (decimal) - Maximum distance from college (km)
- `min_rating` (decimal) - Minimum rating
- `search` (string) - Search by name, address, or landmark
- `sort_by` (enum: price, rating, distance, name) - Sort parameter
- `sort_order` (enum: asc, desc) - Sort order

**Example Request:**
```
GET /api/v1/hostels?type=boys&min_price=4000&max_price=8000&has_ac=true&sort_by=price&sort_order=asc
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "hostels": [
      {
        "hostel_id": 1,
        "hostel_name": "Seshadri Rao Gudlavalleru Engineering College Boys Hostel",
        "hostel_type": "boys",
        "address": "SRGEC Campus, Main Road",
        "landmark": "Near College Gate",
        "city": "Gudlavalleru",
        "state": "Andhra Pradesh",
        "pincode": "521336",
        "phone": "08671234567",
        "email": "hostel@srgec.ac.in",
        "rating": 4.5,
        "total_capacity": 200,
        "current_occupancy": 185,
        "distance_from_college_km": 0.5,
        "latitude": 16.2345,
        "longitude": 81.1234,
        "description": "Official boys hostel for SRGEC students...",
        "facilities_available": ["wifi", "mess", "study_room", "gym"],
        "verification_status": "verified",
        "verified_date": "2026-01-15",
        "available_rooms": 15,
        "min_monthly_fee": 4500.00,
        "max_monthly_fee": 9000.00
      }
    ],
    "pagination": {
      "current_page": 1,
      "per_page": 10,
      "total_items": 25,
      "total_pages": 3
    }
  }
}
```

---

### 2.2 Get Hostel Details
**GET** `/hostels/{hostel_id}`

Get detailed information about a specific hostel

**Path Parameters:**
- `hostel_id` (int, required) - Hostel ID

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "hostel_id": 1,
    "hostel_name": "Seshadri Rao Gudlavalleru Engineering College Boys Hostel",
    "hostel_type": "boys",
    "address": "SRGEC Campus, Main Road",
    "landmark": "Near College Gate",
    "city": "Gudlavalleru",
    "state": "Andhra Pradesh",
    "pincode": "521336",
    "phone": "08671234567",
    "whatsapp_number": "919876543210",
    "email": "hostel@srgec.ac.in",
    "website": "www.srgec.ac.in",
    "rating": 4.5,
    "total_capacity": 200,
    "current_occupancy": 185,
    "distance_from_college_km": 0.5,
    "latitude": 16.2345,
    "longitude": 81.1234,
    "google_maps_link": "https://maps.google.com/?q=16.2345,81.1234",
    "description": "Official boys hostel for SRGEC students with excellent facilities...",
    "facilities_available": [
      "wifi", "mess", "study_room", "gym", "sports_ground",
      "laundry", "security", "medical_room", "prayer_room", "recreation_room"
    ],
    "rules_regulations": "1. Students must maintain discipline...",
    "images": [
      "https://example.com/hostel1/image1.jpg",
      "https://example.com/hostel1/image2.jpg"
    ],
    "verification_status": "verified",
    "verified_date": "2026-01-15",
    "created_at": "2026-01-01T10:00:00Z",
    "rooms": [
      {
        "room_id": 1,
        "room_number": "101",
        "room_type": "triple",
        "capacity": 3,
        "current_occupancy": 3,
        "available_beds": 0,
        "has_ac": false,
        "has_attached_bathroom": false,
        "monthly_fee": 4500.00,
        "yearly_fee": 54000.00,
        "room_status": "occupied"
      }
    ],
    "occupancy_summary": {
      "total_rooms": 50,
      "available_rooms": 15,
      "occupied_rooms": 35,
      "total_available_beds": 20,
      "occupancy_percentage": 92.5
    }
  }
}
```

**Error Response (404 Not Found):**
```json
{
  "success": false,
  "message": "Hostel not found"
}
```

---

### 2.3 Create Hostel (Admin Only)
**POST** `/hostels`

Create a new hostel listing

**Headers:** `Authorization: Bearer <admin_token>`

**Request Body:**
```json
{
  "hostel_name": "New Boys Hostel",
  "hostel_type": "boys",
  "address": "123 Main Street",
  "landmark": "Near Bus Stand",
  "city": "Gudlavalleru",
  "state": "Andhra Pradesh",
  "pincode": "521336",
  "phone": "08671234567",
  "email": "newhostel@example.com",
  "rating": 4.0,
  "total_capacity": 100,
  "distance_from_college_km": 1.5,
  "latitude": 16.2345,
  "longitude": 81.1234,
  "description": "New hostel with modern facilities",
  "facilities_available": ["wifi", "mess", "security"],
  "rules_regulations": "Hostel rules and regulations"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Hostel created successfully",
  "data": {
    "hostel_id": 9,
    "hostel_name": "New Boys Hostel",
    "verification_status": "pending",
    "created_at": "2026-09-22T11:00:00Z"
  }
}
```

---

### 2.4 Update Hostel (Admin Only)
**PUT** `/hostels/{hostel_id}`

Update hostel information

**Headers:** `Authorization: Bearer <admin_token>`

**Request Body:** (Same as create hostel, all fields optional)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Hostel updated successfully",
  "data": {
    "hostel_id": 1,
    "updated_at": "2026-09-22T11:30:00Z"
  }
}
```

---

### 2.5 Delete Hostel (Admin Only)
**DELETE** `/hostels/{hostel_id}`

Delete a hostel listing

**Headers:** `Authorization: Bearer <admin_token>`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Hostel deleted successfully"
}
```

---

### 2.6 Verify Hostel (Admin Only)
**PUT** `/hostels/{hostel_id}/verify`

Verify hostel information

**Headers:** `Authorization: Bearer <admin_token>`

**Request Body:**
```json
{
  "verification_status": "verified",
  "admin_notes": "Hostel verified on site visit"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Hostel verification status updated",
  "data": {
    "hostel_id": 1,
    "verification_status": "verified",
    "verified_date": "2026-09-22"
  }
}
```

---

## 3. ROOM MANAGEMENT ENDPOINTS

### 3.1 Get Rooms by Hostel
**GET** `/hostels/{hostel_id}/rooms`

Get all rooms for a specific hostel

**Query Parameters:**
- `type` (enum: single, double, triple, dormitory, suite) - Filter by room type
- `status` (enum: available, occupied, maintenance, reserved) - Filter by status
- `has_ac` (boolean) - Filter by AC availability
- `min_price` (decimal) - Minimum monthly fee
- `max_price` (decimal) - Maximum monthly fee

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "hostel_id": 1,
    "hostel_name": "SRGEC Boys Hostel",
    "rooms": [
      {
        "room_id": 1,
        "room_number": "101",
        "room_type": "triple",
        "floor_number": 1,
        "capacity": 3,
        "current_occupancy": 3,
        "available_beds": 0,
        "has_ac": false,
        "has_fan": true,
        "has_attached_bathroom": false,
        "has_study_table": true,
        "has_wardrobe": true,
        "room_area_sqft": 180,
        "room_description": "Spacious triple sharing room",
        "monthly_fee": 4500.00,
        "yearly_fee": 54000.00,
        "security_deposit": 9000.00,
        "room_status": "occupied"
      }
    ]
  }
}
```

---

### 3.2 Get Room Details
**GET** `/rooms/{room_id}`

Get detailed information about a specific room

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "room_id": 1,
    "room_number": "101",
    "room_type": "triple",
    "hostel": {
      "hostel_id": 1,
      "hostel_name": "SRGEC Boys Hostel",
      "address": "SRGEC Campus, Main Road"
    },
    "capacity": 3,
    "current_occupancy": 3,
    "available_beds": 0,
    "has_ac": false,
    "monthly_fee": 4500.00,
    "yearly_fee": 54000.00,
    "security_deposit": 9000.00,
    "room_status": "occupied",
    "current_occupants": [
      {
        "student_id": 1,
        "name": "Arjun Reddy",
        "bed_number": 1
      }
    ]
  }
}
```

---

### 3.3 Create Room (Staff/Admin Only)
**POST** `/hostels/{hostel_id}/rooms`

Create a new room in a hostel

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "room_number": "105",
  "room_type": "double",
  "floor_number": 1,
  "capacity": 2,
  "has_ac": true,
  "has_attached_bathroom": true,
  "room_area_sqft": 160,
  "room_description": "AC double room with attached bathroom",
  "monthly_fee": 6500.00,
  "security_deposit": 13000.00
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Room created successfully",
  "data": {
    "room_id": 21,
    "room_number": "105",
    "hostel_id": 1
  }
}
```

---

### 3.4 Update Room (Staff/Admin Only)
**PUT** `/rooms/{room_id}`

Update room information

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:** (Same as create room, all fields optional)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Room updated successfully"
}
```

---

### 3.5 Update Room Status (Staff/Admin Only)
**PATCH** `/rooms/{room_id}/status`

Update room maintenance status

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "room_status": "maintenance",
  "is_maintenance": true
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Room status updated successfully"
}
```

---

## 4. ROOM ALLOCATION ENDPOINTS

### 4.1 Allocate Room to Student (Staff Only)
**POST** `/allocations`

Allocate a room to a student

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "student_id": 1,
  "room_id": 4,
  "hostel_id": 1,
  "bed_number": 1,
  "check_in_date": "2026-09-22",
  "expected_check_out_date": "2027-05-30",
  "fee_type": "yearly",
  "security_deposit_paid": 11000.00
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Room allocated successfully",
  "data": {
    "allocation_id": 16,
    "student_id": 1,
    "room_id": 4,
    "allocation_status": "active",
    "allocation_date": "2026-09-22",
    "check_in_date": "2026-09-22"
  }
}
```

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Room is fully occupied",
  "errors": {
    "available_beds": 0
  }
}
```

---

### 4.2 Get Student Allocation
**GET** `/allocations/student/{student_id}`

Get current room allocation for a student

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "allocation_id": 1,
    "student": {
      "student_id": 1,
      "student_code": "SRGEC2024001",
      "name": "Arjun Reddy"
    },
    "room": {
      "room_id": 1,
      "room_number": "101",
      "room_type": "triple",
      "monthly_fee": 4500.00
    },
    "hostel": {
      "hostel_id": 1,
      "hostel_name": "SRGEC Boys Hostel"
    },
    "bed_number": 1,
    "check_in_date": "2022-07-01",
    "expected_check_out_date": "2025-05-30",
    "allocation_status": "active",
    "fee_type": "yearly"
  }
}
```

---

### 4.3 Update Allocation (Staff Only)
**PUT** `/allocations/{allocation_id}`

Update room allocation details

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "expected_check_out_date": "2027-06-30",
  "notes": "Extended for project work"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Allocation updated successfully"
}
```

---

### 4.4 Check Out Student (Staff Only)
**POST** `/allocations/{allocation_id}/checkout`

Process student check-out

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "check_out_date": "2026-09-22",
  "security_deposit_returned": 9000.00,
  "security_deposit_return_date": "2026-09-22",
  "notes": "Normal check-out process"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Student checked out successfully",
  "data": {
    "allocation_id": 1,
    "allocation_status": "completed",
    "check_out_date": "2026-09-22"
  }
}
```

---

## 5. STUDENT MANAGEMENT ENDPOINTS

### 5.1 Get All Students
**GET** `/students`

Get all students with filtering and pagination

**Query Parameters:**
- `page` (int, default: 1)
- `limit` (int, default: 10)
- `college` (string) - Filter by college name
- `course` (string) - Filter by course
- `year` (int) - Filter by year of study
- `gender` (enum: male, female, other) - Filter by gender
- `status` (enum: active, inactive, graduated, suspended) - Filter by status
- `search` (string) - Search by name or student code

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "students": [
      {
        "student_id": 1,
        "student_code": "SRGEC2024001",
        "first_name": "Arjun",
        "last_name": "Reddy",
        "full_name": "Arjun Reddy",
        "gender": "male",
        "college_name": "Seshadri Rao Gudlavalleru Engineering College",
        "course": "Computer Science Engineering",
        "year_of_study": 3,
        "semester": 5,
        "phone": "9876543215",
        "email": "arjun.student@gmail.com",
        "status": "active",
        "current_allocation": {
          "hostel_name": "SRGEC Boys Hostel",
          "room_number": "101",
          "bed_number": 1
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "per_page": 10,
      "total_items": 50,
      "total_pages": 5
    }
  }
}
```

---

### 5.2 Get Student Details
**GET** `/students/{student_id}`

Get detailed information about a student

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "student_id": 1,
    "student_code": "SRGEC2024001",
    "first_name": "Arjun",
    "last_name": "Reddy",
    "gender": "male",
    "date_of_birth": "2002-05-15",
    "blood_group": "O+",
    "college_name": "Seshadri Rao Gudlavalleru Engineering College",
    "course": "Computer Science Engineering",
    "year_of_study": 3,
    "semester": 5,
    "phone": "9876543215",
    "email": "arjun.student@gmail.com",
    "parent_guardian_name": "Ramesh Reddy",
    "parent_guardian_phone": "9876543220",
    "parent_guardian_relation": "Father",
    "permanent_address": "1-2-3, Main Street, Vijayawada, AP",
    "emergency_contact_name": "Ramesh Reddy",
    "emergency_contact_phone": "9876543220",
    "emergency_contact_relation": "Father",
    "admission_date": "2022-07-01",
    "status": "active",
    "fee_summary": {
      "total_fees": 162000.00,
      "total_paid": 135000.00,
      "total_due": 27000.00,
      "overdue_amount": 0.00
    },
    "attendance_summary": {
      "total_days": 20,
      "present_days": 18,
      "absent_days": 1,
      "late_days": 1,
      "attendance_percentage": 90.0
    }
  }
}
```

---

### 5.3 Create Student (Staff Only)
**POST** `/students`

Create a new student record

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "student_code": "SRGEC2024009",
  "first_name": "Rahul",
  "last_name": "Sharma",
  "gender": "male",
  "date_of_birth": "2003-01-15",
  "blood_group": "B+",
  "college_name": "Seshadri Rao Gudlavalleru Engineering College",
  "course": "Mechanical Engineering",
  "year_of_study": 1,
  "semester": 1,
  "phone": "9876543250",
  "email": "rahul.student@gmail.com",
  "parent_guardian_name": "Sunil Sharma",
  "parent_guardian_phone": "9876543251",
  "parent_guardian_relation": "Father",
  "permanent_address": "45, Colony Road, Hyderabad",
  "emergency_contact_name": "Sunil Sharma",
  "emergency_contact_phone": "9876543251",
  "emergency_contact_relation": "Father",
  "admission_date": "2026-07-01"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Student created successfully",
  "data": {
    "student_id": 9,
    "student_code": "SRGEC2024009"
  }
}
```

---

### 5.4 Update Student (Staff Only)
**PUT** `/students/{student_id}`

Update student information

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:** (Same as create student, all fields optional)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Student updated successfully"
}
```

---

### 5.5 Update Student Status (Staff Only)
**PATCH** `/students/{student_id}/status`

Update student status

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "status": "graduated"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Student status updated successfully"
}
```

---

## 6. ATTENDANCE MANAGEMENT ENDPOINTS

### 6.1 Mark Attendance (Staff Only)
**POST** `/attendance`

Mark attendance for students

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "attendance_date": "2026-09-22",
  "attendance_records": [
    {
      "student_id": 1,
      "hostel_id": 1,
      "status": "present",
      "check_in_time": "08:30:00",
      "check_out_time": "18:00:00",
      "remarks": null
    },
    {
      "student_id": 2,
      "hostel_id": 2,
      "status": "absent",
      "remarks": "Medical leave"
    }
  ]
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Attendance marked successfully",
  "data": {
    "total_records": 2,
    "successful": 2,
    "failed": 0
  }
}
```

---

### 6.2 Get Attendance Records
**GET** `/attendance`

Get attendance records with filtering

**Query Parameters:**
- `student_id` (int) - Filter by student
- `hostel_id` (int) - Filter by hostel
- `from_date` (date) - Start date
- `to_date` (date) - End date
- `status` (enum: present, absent, late, excused) - Filter by status

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "attendance_records": [
      {
        "attendance_id": 1,
        "student": {
          "student_id": 1,
          "name": "Arjun Reddy"
        },
        "hostel": {
          "hostel_id": 1,
          "hostel_name": "SRGEC Boys Hostel"
        },
        "attendance_date": "2026-09-22",
        "status": "present",
        "check_in_time": "08:30:00",
        "check_out_time": "18:00:00",
        "remarks": null
      }
    ],
    "summary": {
      "total_records": 20,
      "present": 18,
      "absent": 1,
      "late": 1,
      "attendance_percentage": 90.0
    }
  }
}
```

---

### 6.3 Get Student Attendance Summary
**GET** `/attendance/student/{student_id}/summary`

Get attendance summary for a student

**Query Parameters:**
- `month` (int) - Month (1-12)
- `year` (int) - Year

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "student_id": 1,
    "student_name": "Arjun Reddy",
    "period": {
      "month": 9,
      "year": 2026
    },
    "summary": {
      "total_days": 22,
      "present": 20,
      "absent": 1,
      "late": 1,
      "excused": 0,
      "attendance_percentage": 90.91
    },
    "daily_records": [
      {
        "date": "2026-09-01",
        "status": "present",
        "check_in_time": "08:30:00",
        "check_out_time": "18:00:00"
      }
    ]
  }
}
```

---

## 7. FEE MANAGEMENT ENDPOINTS

### 7.1 Create Fee Record (Staff Only)
**POST** `/fees`

Create a new fee record

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "student_id": 1,
  "hostel_id": 1,
  "room_allocation_id": 1,
  "fee_type": "yearly",
  "fee_amount": 54000.00,
  "due_date": "2026-08-15",
  "academic_year": "2026-2027",
  "notes": "Annual hostel fee"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Fee record created successfully",
  "data": {
    "fee_id": 17,
    "student_id": 1,
    "fee_amount": 54000.00,
    "due_amount": 54000.00,
    "payment_status": "pending"
  }
}
```

---

### 7.2 Record Fee Payment (Staff Only)
**POST** `/fees/{fee_id}/payment`

Record fee payment

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "paid_amount": 54000.00,
  "payment_date": "2026-09-22",
  "payment_method": "bank_transfer",
  "transaction_id": "TXN123456789",
  "receipt_number": "REC2026001"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Payment recorded successfully",
  "data": {
    "fee_id": 17,
    "paid_amount": 54000.00,
    "due_amount": 0.00,
    "payment_status": "paid",
    "receipt_number": "REC2026001"
  }
}
```

---

### 7.3 Get Fee Records
**GET** `/fees`

Get fee records with filtering

**Query Parameters:**
- `student_id` (int) - Filter by student
- `hostel_id` (int) - Filter by hostel
- `status` (enum: pending, partial, paid, overdue) - Filter by status
- `fee_type` (enum: admission, monthly, yearly, security_deposit) - Filter by type
- `academic_year` (string) - Filter by academic year
- `from_date` (date) - Start date
- `to_date` (date) - End date

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "fee_records": [
      {
        "fee_id": 1,
        "student": {
          "student_id": 1,
          "name": "Arjun Reddy"
        },
        "hostel": {
          "hostel_id": 1,
          "hostel_name": "SRGEC Boys Hostel"
        },
        "fee_type": "yearly",
        "fee_amount": 54000.00,
        "paid_amount": 54000.00,
        "due_amount": 0.00,
        "due_date": "2024-08-15",
        "payment_status": "paid",
        "payment_date": "2024-08-10",
        "payment_method": "bank_transfer",
        "receipt_number": "REC2024001",
        "academic_year": "2024-2025"
      }
    ],
    "summary": {
      "total_fees": 270000.00,
      "total_paid": 243000.00,
      "total_due": 27000.00,
      "overdue_amount": 0.00
    }
  }
}
```

---

### 7.4 Get Student Fee Status
**GET** `/fees/student/{student_id}/status`

Get complete fee status for a student

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "student_id": 1,
    "student_name": "Arjun Reddy",
    "total_fees": 162000.00,
    "total_paid": 135000.00,
    "total_due": 27000.00,
    "overdue_amount": 0.00,
    "payment_history": [
      {
        "fee_id": 1,
        "fee_type": "yearly",
        "fee_amount": 54000.00,
        "paid_amount": 54000.00,
        "payment_status": "paid",
        "payment_date": "2022-08-15"
      }
    ],
    "pending_payments": [
      {
        "fee_id": 3,
        "fee_type": "yearly",
        "fee_amount": 54000.00,
        "paid_amount": 27000.00,
        "due_amount": 27000.00,
        "due_date": "2024-08-15",
        "payment_status": "partial"
      }
    ]
  }
}
```

---

### 7.5 Get Fee Defaulters Report (Staff/Admin Only)
**GET** `/fees/defaulters`

Get list of students with overdue payments

**Headers:** `Authorization: Bearer <staff_token>`

**Query Parameters:**
- `hostel_id` (int) - Filter by hostel
- `days_overdue` (int) - Minimum days overdue

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "defaulters": [
      {
        "student_id": 3,
        "student_name": "Karthik Raju",
        "hostel_name": "SRGEC Boys Hostel",
        "room_number": "103",
        "phone": "9876543217",
        "total_due": 66000.00,
        "overdue_amount": 66000.00,
        "days_overdue": 37,
        "last_payment_date": "2023-08-15"
      }
    ],
    "summary": {
      "total_defaulters": 1,
      "total_overdue_amount": 66000.00
    }
  }
}
```

---

## 8. MESS MENU MANAGEMENT ENDPOINTS

### 8.1 Get Mess Menu
**GET** `/mess-menu/{hostel_id}`

Get mess menu for a hostel

**Query Parameters:**
- `day_of_week` (enum: monday, tuesday, wednesday, thursday, friday, saturday, sunday)
- `meal_type` (enum: breakfast, lunch, dinner, snacks)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "hostel_id": 1,
    "hostel_name": "SRGEC Boys Hostel",
    "weekly_menu": {
      "monday": {
        "breakfast": {
          "menu_items": "Idli, Sambar, Coconut Chutney, Tea/Coffee",
          "is_special": false,
          "calories_per_serving": 350,
          "protein_content": "8g"
        },
        "lunch": {
          "menu_items": "Rice, Sambar, Rasam, Vegetable Curry, Curd, Pickle",
          "is_special": false,
          "calories_per_serving": 600,
          "protein_content": "15g"
        },
        "dinner": {
          "menu_items": "Chapati, Dal Fry, Mixed Vegetable, Rice, Sambar",
          "is_special": false,
          "calories_per_serving": 550,
          "protein_content": "12g"
        }
      }
    }
  }
}
```

---

### 8.2 Update Mess Menu (Staff Only)
**PUT** `/mess-menu/{menu_id}`

Update mess menu item

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "menu_items": "Idli, Sambar, Coconut Chutney, Vada, Tea/Coffee",
  "is_special": true,
  "special_occasion": "Festival Day",
  "calories_per_serving": 400,
  "protein_content": "10g"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Mess menu updated successfully"
}
```

---

### 8.3 Create Mess Menu Item (Staff Only)
**POST** `/mess-menu`

Create new mess menu item

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "hostel_id": 1,
  "day_of_week": "monday",
  "meal_type": "breakfast",
  "menu_items": "Poha, Tea/Coffee",
  "is_special": false,
  "calories_per_serving": 300,
  "protein_content": "6g"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Mess menu item created successfully",
  "data": {
    "menu_id": 43
  }
}
```

---

## 9. COMPLAINT MANAGEMENT ENDPOINTS

### 9.1 Submit Complaint (Student/Staff)
**POST** `/complaints`

Submit a new complaint

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "student_id": 1,
  "hostel_id": 1,
  "room_id": 1,
  "category": "water",
  "subject": "Water supply issue in Room 101",
  "description": "Water pressure is very low in the morning hours...",
  "priority": "medium",
  "anonymous": false,
  "location": "Room 101, Ground Floor"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Complaint submitted successfully",
  "data": {
    "complaint_id": 11,
    "student_id": 1,
    "category": "water",
    "priority": "medium",
    "status": "pending",
    "submitted_date": "2026-09-22T12:00:00Z"
  }
}
```

---

### 9.2 Get Complaints
**GET** `/complaints`

Get complaints with filtering

**Query Parameters:**
- `student_id` (int) - Filter by student
- `hostel_id` (int) - Filter by hostel
- `category` (enum: water, electricity, plumbing, furniture, cleaning, food, wifi, security, noise, other)
- `status` (enum: pending, in_progress, resolved, rejected, escalated)
- `priority` (enum: low, medium, high, urgent)
- `from_date` (date) - Start date
- `to_date` (date) - End date

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "complaints": [
      {
        "complaint_id": 1,
        "student": {
          "student_id": 1,
          "name": "Arjun Reddy"
        },
        "hostel": {
          "hostel_id": 1,
          "hostel_name": "SRGEC Boys Hostel"
        },
        "room": {
          "room_id": 1,
          "room_number": "101"
        },
        "category": "water",
        "subject": "Water supply issue in Room 101",
        "description": "Water pressure is very low in the morning hours...",
        "priority": "medium",
        "status": "resolved",
        "submitted_date": "2026-09-05T08:30:00Z",
        "resolved_date": "2026-09-06T14:00:00Z",
        "resolution_notes": "Water pump repaired. Motor replaced.",
        "assigned_to": {
          "user_id": 3,
          "name": "Rahul Kumar"
        },
        "resolved_by": {
          "user_id": 3,
          "name": "Rahul Kumar"
        },
        "student_feedback": "Good response, issue resolved quickly",
        "feedback_rating": 5
      }
    ],
    "summary": {
      "total_complaints": 10,
      "pending": 3,
      "in_progress": 2,
      "resolved": 5,
      "urgent": 1
    }
  }
}
```

---

### 9.3 Update Complaint Status (Staff Only)
**PATCH** `/complaints/{complaint_id}/status`

Update complaint status and resolution

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "status": "in_progress",
  "assigned_to": 4,
  "resolution_notes": "Electrician assigned to check the fan"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Complaint status updated successfully",
  "data": {
    "complaint_id": 2,
    "status": "in_progress",
    "assigned_to": 4,
    "assigned_date": "2026-09-22T12:30:00Z"
  }
}
```

---

### 9.4 Resolve Complaint (Staff Only)
**POST** `/complaints/{complaint_id}/resolve`

Mark complaint as resolved

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "resolution_notes": "Fan repaired successfully. Bearing replaced.",
  "actual_cost": 750.00
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Complaint resolved successfully",
  "data": {
    "complaint_id": 2,
    "status": "resolved",
    "resolved_date": "2026-09-22T14:00:00Z",
    "resolved_by": 4
  }
}
```

---

### 9.5 Submit Complaint Feedback (Student Only)
**POST** `/complaints/{complaint_id}/feedback`

Submit feedback on resolved complaint

**Headers:** `Authorization: Bearer <student_token>`

**Request Body:**
```json
{
  "student_feedback": "Issue resolved quickly, very satisfied",
  "feedback_rating": 5
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Feedback submitted successfully",
  "data": {
    "complaint_id": 2,
    "student_feedback": "Issue resolved quickly, very satisfied",
    "feedback_rating": 5
  }
}
```

---

## 10. VISITOR MANAGEMENT ENDPOINTS

### 10.1 Record Visitor Entry (Staff Only)
**POST** `/visitors`

Record visitor entry

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "student_id": 1,
  "hostel_id": 1,
  "visitor_name": "Ramesh Reddy",
  "visitor_phone": "9876543220",
  "visitor_address": "1-2-3, Main Street, Vijayawada",
  "relationship_to_student": "Father",
  "visit_date": "2026-09-22",
  "entry_time": "10:30:00",
  "purpose_of_visit": "Monthly visit to check on son's well-being",
  "id_proof_type": "aadhaar",
  "id_proof_number": "1234-5678-9012",
  "number_of_visitors": 1
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Visitor entry recorded successfully",
  "data": {
    "visitor_id": 9,
    "visit_status": "in_progress",
    "entry_time": "10:30:00"
  }
}
```

---

### 10.2 Record Visitor Exit (Staff Only)
**POST** `/visitors/{visitor_id}/exit`

Record visitor exit

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "exit_time": "17:00:00",
  "exit_approved_by": 3,
  "notes": "Normal visit, no issues"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Visitor exit recorded successfully",
  "data": {
    "visitor_id": 9,
    "visit_status": "completed",
    "exit_time": "17:00:00"
  }
}
```

---

### 10.3 Get Visitor Records
**GET** `/visitors`

Get visitor records with filtering

**Query Parameters:**
- `student_id` (int) - Filter by student
- `hostel_id` (int) - Filter by hostel
- `visit_date` (date) - Filter by visit date
- `status` (enum: in_progress, completed, denied, expired) - Filter by status
- `from_date` (date) - Start date
- `to_date` (date) - End date

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "visitors": [
      {
        "visitor_id": 1,
        "student": {
          "student_id": 1,
          "name": "Arjun Reddy"
        },
        "hostel": {
          "hostel_id": 1,
          "hostel_name": "SRGEC Boys Hostel"
        },
        "visitor_name": "Ramesh Reddy",
        "visitor_phone": "9876543220",
        "relationship_to_student": "Father",
        "visit_date": "2026-09-08",
        "entry_time": "10:30:00",
        "exit_time": "17:00:00",
        "purpose_of_visit": "Monthly visit to check on son's well-being",
        "id_proof_type": "aadhaar",
        "id_proof_number": "1234-5678-9012",
        "visit_status": "completed",
        "allowed_by": {
          "user_id": 3,
          "name": "Rahul Kumar"
        }
      }
    ],
    "summary": {
      "total_visitors": 8,
      "in_progress": 2,
      "completed": 6
    }
  }
}
```

---

## 11. MAINTENANCE MANAGEMENT ENDPOINTS

### 11.1 Submit Maintenance Request (Student/Staff)
**POST** `/maintenance`

Submit maintenance request

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "hostel_id": 1,
  "room_id": 1,
  "reported_by": 3,
  "category": "electrical",
  "title": "AC not cooling properly",
  "description": "AC in room 204 is not cooling effectively...",
  "priority": "high",
  "location": "Room 204, First Floor",
  "reported_by_type": "staff"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Maintenance request submitted successfully",
  "data": {
    "maintenance_id": 11,
    "category": "electrical",
    "priority": "high",
    "status": "pending",
    "reported_date": "2026-09-22T13:00:00Z"
  }
}
```

---

### 11.2 Get Maintenance Requests
**GET** `/maintenance`

Get maintenance requests with filtering

**Query Parameters:**
- `hostel_id` (int) - Filter by hostel
- `room_id` (int) - Filter by room
- `category` (enum: electrical, plumbing, furniture, painting, cleaning, ac, internet, security, structural, other)
- `status` (enum: pending, assigned, in_progress, completed, cancelled, escalated)
- `priority` (enum: low, medium, high, urgent)
- `from_date` (date) - Start date
- `to_date` (date) - End date

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "maintenance_requests": [
      {
        "maintenance_id": 1,
        "hostel": {
          "hostel_id": 1,
          "hostel_name": "SRGEC Boys Hostel"
        },
        "room": {
          "room_id": 1,
          "room_number": "101"
        },
        "reported_by": {
          "user_id": 3,
          "name": "Rahul Kumar"
        },
        "category": "electrical",
        "title": "Water pump repair",
        "description": "Main water pump motor not working...",
        "priority": "high",
        "status": "completed",
        "reported_date": "2026-09-05T09:00:00Z",
        "assigned_date": "2026-09-05T10:00:00Z",
        "completed_date": "2026-09-05T16:00:00Z",
        "assigned_to": {
          "user_id": 3,
          "name": "Rahul Kumar"
        },
        "estimated_cost": 5000.00,
        "actual_cost": 4800.00,
        "location": "Pump Room, Ground Floor"
      }
    ],
    "summary": {
      "total_requests": 10,
      "pending": 3,
      "in_progress": 2,
      "completed": 5,
      "urgent": 1
    }
  }
}
```

---

### 11.3 Assign Maintenance Request (Staff Only)
**PATCH** `/maintenance/{maintenance_id}/assign`

Assign maintenance request to staff

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "assigned_to": 4,
  "estimated_cost": 1500.00
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Maintenance request assigned successfully",
  "data": {
    "maintenance_id": 7,
    "status": "assigned",
    "assigned_to": 4,
    "assigned_date": "2026-09-22T13:30:00Z"
  }
}
```

---

### 11.4 Complete Maintenance Request (Staff Only)
**POST** `/maintenance/{maintenance_id}/complete`

Mark maintenance request as completed

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "actual_cost": 1400.00,
  "work_description": "AC serviced, gas refilled, filters cleaned",
  "parts_used": "Gas cylinder, filters",
  "completion_notes": "AC working properly now"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Maintenance request completed successfully",
  "data": {
    "maintenance_id": 7,
    "status": "completed",
    "completed_date": "2026-09-22T15:00:00Z",
    "actual_cost": 1400.00
  }
}
```

---

## 12. CONTACT/ENQUIRY ENDPOINTS

### 12.1 Submit Contact Form
**POST** `/contacts`

Submit contact form enquiry

**Request Body:**
```json
{
  "name": "Ravi Kumar",
  "email": "ravi.kumar@gmail.com",
  "phone": "9876543240",
  "subject": "Hostel availability enquiry",
  "message": "I am looking for a single room for my son...",
  "hostel_id": 1,
  "enquiry_type": "booking"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Enquiry submitted successfully",
  "data": {
    "contact_id": 11,
    "status": "new",
    "created_at": "2026-09-22T14:00:00Z"
  }
}
```

---

### 12.2 Get Contact Enquiries (Staff/Admin Only)
**GET** `/contacts`

Get contact enquiries with filtering

**Headers:** `Authorization: Bearer <staff_token>`

**Query Parameters:**
- `status` (enum: new, read, responded, closed, spam)
- `enquiry_type` (enum: general, booking, complaint, feedback, partnership, other)
- `hostel_id` (int) - Filter by hostel
- `from_date` (date) - Start date
- `to_date` (date) - End date

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "contacts": [
      {
        "contact_id": 1,
        "name": "Ravi Kumar",
        "email": "ravi.kumar@gmail.com",
        "phone": "9876543240",
        "subject": "Hostel availability enquiry",
        "message": "I am looking for a single room for my son...",
        "hostel": {
          "hostel_id": 1,
          "hostel_name": "SRGEC Boys Hostel"
        },
        "enquiry_type": "booking",
        "status": "responded",
        "created_at": "2026-09-01T10:00:00Z",
        "responded_by": {
          "user_id": 2,
          "name": "Hostel Manager"
        },
        "response_date": "2026-09-01T14:00:00Z",
        "response_text": "We have single rooms available. Please contact us for details."
      }
    ],
    "summary": {
      "total_enquiries": 10,
      "new": 2,
      "read": 1,
      "responded": 5,
      "closed": 2
    }
  }
}
```

---

### 12.3 Respond to Enquiry (Staff/Admin Only)
**POST** `/contacts/{contact_id}/respond`

Respond to contact enquiry

**Headers:** `Authorization: Bearer <staff_token>`

**Request Body:**
```json
{
  "response_text": "Thank you for your enquiry. We have single rooms available at ₹9,000/month. Please visit us for more details."
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Response sent successfully",
  "data": {
    "contact_id": 1,
    "status": "responded",
    "response_date": "2026-09-22T14:30:00Z",
    "responded_by": 2
  }
}
```

---

## 13. DASHBOARD & ANALYTICS ENDPOINTS

### 13.1 Get Admin Dashboard Summary (Admin Only)
**GET** `/dashboard/admin`

Get comprehensive dashboard summary for admin

**Headers:** `Authorization: Bearer <admin_token>`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "overview": {
      "total_hostels": 8,
      "total_students": 8,
      "total_rooms": 20,
      "total_capacity": 730,
      "current_occupancy": 688,
      "occupancy_percentage": 94.2
    },
    "hostel_stats": [
      {
        "hostel_id": 1,
        "hostel_name": "SRGEC Boys Hostel",
        "total_capacity": 200,
        "current_occupancy": 185,
        "occupancy_percentage": 92.5,
        "total_rooms": 8,
        "available_rooms": 1
      }
    ],
    "fee_summary": {
      "total_fees": 432000.00,
      "total_paid": 405000.00,
      "total_due": 27000.00,
      "overdue_amount": 66000.00,
      "defaulters_count": 1
    },
    "complaint_summary": {
      "total_complaints": 10,
      "pending": 3,
      "in_progress": 2,
      "resolved": 5,
      "urgent": 1,
      "average_resolution_time": "24 hours"
    },
    "maintenance_summary": {
      "total_requests": 10,
      "pending": 3,
      "in_progress": 2,
      "completed": 5,
      "total_cost": 12950.00
    },
    "recent_activities": [
      {
        "activity_type": "complaint_resolved",
        "description": "Water supply issue resolved in Room 101",
        "timestamp": "2026-09-06T14:00:00Z"
      }
    ]
  }
}
```

---

### 13.2 Get Staff Dashboard Summary (Staff Only)
**GET** `/dashboard/staff`

Get dashboard summary for staff

**Headers:** `Authorization: Bearer <staff_token>`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "my_hostel": {
      "hostel_id": 1,
      "hostel_name": "SRGEC Boys Hostel",
      "total_capacity": 200,
      "current_occupancy": 185,
      "occupancy_percentage": 92.5
    },
    "today_stats": {
      "present_students": 45,
      "absent_students": 3,
      "late_students": 2,
      "visitor_count": 2
    },
    "pending_tasks": {
      "pending_complaints": 3,
      "pending_maintenance": 3,
      "fee_defaulters": 1,
      "unread_enquiries": 2
    },
    "recent_complaints": [
      {
        "complaint_id": 2,
        "category": "electricity",
        "subject": "Fan not working in Room G101",
        "priority": "high",
        "status": "in_progress",
        "submitted_date": "2026-09-08T10:15:00Z"
      }
    ]
  }
}
```

---

### 13.3 Get Student Dashboard Summary (Student Only)
**GET** `/dashboard/student`

Get dashboard summary for student

**Headers:** `Authorization: Bearer <student_token>**

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "student_info": {
      "student_id": 1,
      "name": "Arjun Reddy",
      "student_code": "SRGEC2024001",
      "course": "Computer Science Engineering",
      "year_of_study": 3
    },
    "current_allocation": {
      "hostel_name": "SRGEC Boys Hostel",
      "room_number": "101",
      "bed_number": 1,
      "check_in_date": "2022-07-01"
    },
    "fee_status": {
      "total_fees": 162000.00,
      "total_paid": 135000.00,
      "total_due": 27000.00,
      "next_due_date": "2024-08-15"
    },
    "attendance_summary": {
      "this_month": {
        "present": 18,
        "absent": 1,
        "late": 1,
        "percentage": 90.0
      }
    },
    "my_complaints": {
      "total": 3,
      "pending": 1,
      "resolved": 2
    },
    "recent_visitors": [
      {
        "visitor_name": "Ramesh Reddy",
        "relationship": "Father",
        "visit_date": "2026-09-08"
      }
    ]
  }
}
```

---

## ERROR RESPONSE FORMAT

All error responses follow this format:

```json
{
  "success": false,
  "message": "Error message describing the issue",
  "errors": {
    "field_name": "Specific error message for this field"
  }
}
```

### Common HTTP Status Codes:
- `200 OK` - Request successful
- `201 Created` - Resource created successfully
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required or invalid
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `409 Conflict` - Resource conflict (e.g., duplicate entry)
- `422 Unprocessable Entity` - Validation error
- `500 Internal Server Error` - Server error

---

## RATE LIMITING

- **Rate Limit**: 100 requests per minute per IP
- **Rate Limit Headers**:
  - `X-RateLimit-Limit`: 100
  - `X-RateLimit-Remaining`: 95
  - `X-RateLimit-Reset`: Unix timestamp

---

## PAGINATION

All list endpoints support pagination:

**Query Parameters:**
- `page` (int, default: 1) - Page number
- `limit` (int, default: 10, max: 100) - Items per page

**Response Format:**
```json
{
  "data": { ... },
  "pagination": {
    "current_page": 1,
    "per_page": 10,
    "total_items": 25,
    "total_pages": 3
  }
}
```

---

## SEARCH AND FILTERING

### Search Syntax:
- Full-text search: `?search=water problem`
- Exact match: `?hostel_name=SRGEC`
- Range queries: `?min_price=4000&max_price=8000`
- Boolean filters: `?has_ac=true&has_wifi=true`
- Enum filters: `?status=active&gender=male`

### Sort Syntax:
- `?sort_by=price&sort_order=asc`
- `?sort_by=rating&sort_order=desc`

---

## WEBSOCKET EVENTS (Real-time Updates)

### Connection:
```
ws://localhost:8000/ws
```

### Authentication:
Send token in first message:
```json
{
  "type": "auth",
  "token": "jwt_token_here"
}
```

### Events:
- `complaint_new` - New complaint submitted
- `complaint_updated` - Complaint status changed
- `maintenance_new` - New maintenance request
- `maintenance_updated` - Maintenance status changed
- `visitor_entry` - New visitor entry
- `visitor_exit` - Visitor exit recorded
- `attendance_marked` - Attendance marked
- `fee_payment` - Fee payment recorded

### Event Format:
```json
{
  "type": "complaint_updated",
  "data": {
    "complaint_id": 1,
    "status": "resolved",
    "timestamp": "2026-09-22T15:00:00Z"
  }
}
```

---

## API VERSIONING

- Current Version: `v1`
- Version in URL: `/api/v1/...`
- Backward compatibility maintained for 6 months after deprecation notice

---

## SECURITY CONSIDERATIONS

1. **Authentication**: JWT tokens with 24-hour expiry
2. **Authorization**: Role-based access control (RBAC)
3. **Input Validation**: All inputs validated and sanitized
4. **SQL Injection**: Parameterized queries used throughout
5. **XSS Protection**: Output encoding and CSP headers
6. **CORS**: Configured for specific domains
7. **Rate Limiting**: 100 requests per minute per IP
8. **HTTPS**: Required in production
9. **Password Hashing**: Bcrypt with minimum 10 rounds
10. **Sensitive Data**: Never log passwords, tokens, or personal data

---

This API specification provides a complete foundation for the Find My Hostel system with all necessary endpoints for hostel management, student administration, and complaint resolution workflows.