# FIND MY HOSTEL - Academic Documentation

## Complete Software Engineering Documentation for College Project

---

## 1. USE CASE DESCRIPTIONS

### Actor-to-Action Mapping Table

| Actor | Action | Use Case ID | Description | Preconditions | Postconditions |
|-------|--------|-------------|-------------|----------------|----------------|
| **Student** | Search Hostels | UC-001 | Student searches for hostels using filters like location, budget, facilities | User is logged in as student | Display filtered hostel results |
| **Student** | View Hostel Details | UC-002 | Student views detailed information about a specific hostel | Hostel exists in system | Display complete hostel information |
| **Student** | Submit Enquiry | UC-003 | Student submits enquiry about hostel availability/booking | User is logged in | Enquiry recorded in system |
| **Student** | Submit Complaint | UC-004 | Student submits complaint about hostel facilities/services | User is logged in, has active allocation | Complaint created with pending status |
| **Student** | View Fee Status | UC-005 | Student views their fee payment status and dues | User is logged in as student | Display current fee information |
| **Student** | View Attendance | UC-006 | Student views their attendance records | User is logged in as student | Display attendance summary |
| **Student** | View Room Allocation | UC-007 | Student views their current room allocation details | User is logged in, has active allocation | Display allocation information |
| **Student** | Submit Feedback | UC-008 | Student submits feedback on resolved complaints | Complaint is resolved | Feedback recorded against complaint |
| **Staff** | Manage Students | UC-009 | Staff adds, updates, or deactivates student records | User is logged in as staff | Student information updated |
| **Staff** | Allocate Rooms | UC-010 | Staff allocates rooms to students | Room has available capacity | Room allocation created, occupancy updated |
| **Staff** | Mark Attendance | UC-011 | Staff marks daily attendance for students | User is logged in as staff | Attendance records updated |
| **Staff** | Manage Fees | UC-012 | Staff creates fee records and processes payments | User is logged in as staff | Fee records updated |
| **Staff** | Handle Complaints | UC-013 | Staff updates complaint status and resolution | User is logged in as staff | Complaint status updated |
| **Staff** | Manage Visitors | UC-014 | Staff records visitor entries and exits | User is logged in as staff | Visitor records updated |
| **Staff** | Manage Maintenance | UC-015 | Staff creates and tracks maintenance requests | User is logged in as staff | Maintenance records updated |
| **Staff** | Update Mess Menu | UC-016 | Staff updates mess menu and food schedules | User is logged in as staff | Menu information updated |
| **Admin** | Manage Hostels | UC-017 | Admin adds, updates, or removes hostel listings | User is logged in as admin | Hostel information updated |
| **Admin** | Verify Hostels | UC-018 | Admin verifies hostel information and authenticity | User is logged in as admin | Hostel verification status updated |
| **Admin** | Manage Users | UC-019 | Admin creates and manages user accounts | User is logged in as admin | User accounts updated |
| **Admin** | View Reports | UC-020 | Admin views system-wide reports and analytics | User is logged in as admin | Display comprehensive reports |
| **Admin** | Manage Staff | UC-021 | Admin assigns and manages hostel staff permissions | User is logged in as admin | Staff permissions updated |

### Use Case Descriptions

#### UC-001: Search Hostels
**Primary Actor:** Student  
**Description:** Students can search for hostels using multiple criteria including location, budget range, facilities (WiFi, AC, Mess), hostel type (boys/girls), and distance from college. The system provides filtered results with sorting options.  
**Preconditions:** User is logged in as a student  
**Main Flow:**
1. Student navigates to hostel search page
2. Student applies search filters (optional)
3. System queries database with applied filters
4. System displays matching hostels with key information
5. Student can sort results by price, rating, or distance
**Alternative Flows:**
- If no hostels match criteria, display "No results found" message
- If database error occurs, display error message and retry option  
**Postconditions:** Filtered hostel list displayed to student

#### UC-004: Submit Complaint
**Primary Actor:** Student  
**Description:** Students can submit complaints about hostel facilities, services, or other issues. Complaints are categorized by type (water, electricity, cleaning, etc.) and priority level.  
**Preconditions:** User is logged in as student with active room allocation  
**Main Flow:**
1. Student navigates to complaint submission page
2. Student selects complaint category
3. Student enters subject and detailed description
4. Student sets priority level (optional)
5. Student submits complaint
6. System validates input and creates complaint record
7. System sets initial status as "Pending"
8. System notifies relevant staff members
**Alternative Flows:**
- If required fields are missing, display validation errors
- If student has no active allocation, redirect to allocation page  
**Postconditions:** Complaint created in system with pending status

#### UC-013: Handle Complaints
**Primary Actor:** Staff  
**Description:** Staff members can view, assign, update status, and resolve complaints. The system supports the complaint lifecycle: Pending → In Progress → Resolved/Rejected.  
**Preconditions:** User is logged in as staff member  
**Main Flow:**
1. Staff views complaint list filtered by status/priority
2. Staff selects complaint to handle
3. Staff can assign complaint to themselves or others
4. Staff updates status to "In Progress"
5. Staff works on resolution
6. Staff updates status to "Resolved" with resolution notes
7. System notifies student of resolution
8. Student can provide feedback on resolution
**Alternative Flows:**
- If complaint is invalid, staff can reject with reason
- If complaint requires escalation, staff can escalate to admin  
**Postconditions:** Complaint status updated, student notified

---

## 2. DATA FLOW DIAGRAMS (DFD)

### Context Level DFD (Level 0)

```
                    +-------------------+
                    |     External     |
                    |     Entities     |
                    +-------------------+
                            |
        +-------------------+-------------------+
        |                   |                   |
+-------v-------+   +-----v------+   +--------v-------+
|     Student    |   |   Admin    |   |     Staff     |
+---------------+   +------------+   +---------------+
        |                   |                   |
        |                   |                   |
        +-------------------+-------------------+
                            |
                    +-------v-------+
                    | FIND MY HOSTEL |
                    |     SYSTEM     |
                    +---------------+
                            |
        +-------------------+-------------------+
        |                   |                   |
+-------v-------+   +-----v------+   +--------v-------+
|   Hostel DB   |   |   Reports  |   |  Notifications|
+---------------+   +------------+   +---------------+
```

**Context Level Description:**
- **External Entities:** Students, Admin, Staff
- **Central System:** Find My Hostel System
- **Data Stores:** Hostel Database, Reports, Notifications
- **Data Flows:** Search queries, hostel data, complaints, fee records, maintenance requests

### Level 1 DFD (Detailed)

```
+----------------+          +----------------+
|    Student     |          |     Admin      |
+----------------+          +----------------+
        |                          |
        | 1. Search Request       |
        |------------------------->|
        |                          |
        | 2. Hostel Data          |
        |<-------------------------|
        |                          |
        | 3. Submit Complaint     |
        |------------------------->|
        |                          |
        | 4. Complaint Status     |
        |<-------------------------|
        |                          |
+----------------+          +----------------+
|     Staff      |          |   Hostel DB    |
+----------------+          +----------------+
        |                          |
        | 5. Allocate Room        |
        |------------------------->|
        |                          |
        | 6. Room Allocation Data  |
        |<-------------------------|
        |                          |
        | 7. Mark Attendance       |
        |------------------------->|
        |                          |
        | 8. Attendance Records    |
        |<-------------------------|
        |                          |
        | 9. Update Complaint      |
        |------------------------->|
        |                          |
        | 10. Complaint Updates    |
        |<-------------------------|
        |                          |
+----------------+          +----------------+
|    System      |          |   Reports      |
+----------------+          +----------------+
        |                          |
        | 11. Generate Reports     |
        |------------------------->|
        |                          |
        | 12. Report Data          |
        |<-------------------------|
        |                          |
        | 13. Send Notifications   |
        |------------------------->|
        |                          |
+----------------+          +----------------+
| Notifications  |          |   External     |
+----------------+          |   Services     |
        |                          +----------------+
        |                          |
        | 14. SMS/Email            |
        |------------------------->|
```

**Level 1 Process Descriptions:**

1. **Process 1.0: Search Hostels**
   - Input: Search criteria from student
   - Process: Query database with filters, sort results
   - Output: Filtered hostel list

2. **Process 2.0: Complaint Management**
   - Input: Complaint submission from student
   - Process: Validate, categorize, assign priority, notify staff
   - Output: Complaint record, notifications

3. **Process 3.0: Room Allocation**
   - Input: Allocation request from staff
   - Process: Check availability, validate rules, update occupancy
   - Output: Allocation record, updated room status

4. **Process 4.0: Attendance Management**
   - Input: Attendance data from staff
   - Process: Validate student, record attendance, calculate percentage
   - Output: Attendance records, statistics

5. **Process 5.0: Fee Management**
   - Input: Fee records from staff
   - Process: Calculate dues, track payments, generate receipts
   - Output: Fee records, payment status

6. **Process 6.0: Report Generation**
   - Input: Report parameters from admin
   - Process: Aggregate data, calculate metrics, format reports
   - Output: Statistical reports, analytics

---

## 3. ENTITY RELATIONSHIP (ER) STRUCTURAL SUMMARY

### Cardinality and Relationship Mappings

```
HOSTEL (1) --------< (N) ROOMS
       |
       | (1)
       |
       v
    (N) ROOM_ALLOCATIONS
       |
       | (1)
       |
       v
    STUDENTS (1) --------< (N) ATTENDANCE
       |
       | (1)
       |
       v
    (N) FEES
       |
       | (1)
       |
       v
    (N) COMPLAINTS
       |
       | (1)
       |
       v
    (N) VISITORS
       |
       | (1)
       |
       v
    (N) MAINTENANCE

USERS (1) --------< (N) STUDENTS
  |
  | (1)
  v
(N) COMPLAINTS (assigned_to, resolved_by)
(N) MAINTENANCE (assigned_to)
(N) VISITORS (allowed_by, exit_approved_by)
(N) ATTENDANCE (recorded_by)
(N) FEES (recorded_by)
(N) CONTACTS (responded_by)

HOSTEL (1) --------< (N) MESS_MENU
HOSTEL (1) --------< (N) COMPLAINTS
HOSTEL (1) --------< (N) MAINTENANCE
HOSTEL (1) --------< (N) VISITORS
HOSTEL (1) --------< (N) CONTACTS
```

### Detailed Relationship Descriptions

| Entity A | Relationship | Entity B | Cardinality | Description |
|----------|-------------|----------|-------------|-------------|
| HOSTEL | has | ROOMS | 1:N | One hostel can have multiple rooms |
| ROOMS | can accommodate | ROOM_ALLOCATIONS | 1:N | One room can have multiple allocations over time |
| ROOM_ALLOCATIONS | belongs to | STUDENTS | N:1 | Multiple allocations can belong to one student (historical) |
| STUDENTS | can have | ATTENDANCE | 1:N | One student can have multiple attendance records |
| STUDENTS | can have | FEES | 1:N | One student can have multiple fee records |
| STUDENTS | can submit | COMPLAINTS | 1:N | One student can submit multiple complaints |
| STUDENTS | can receive | VISITORS | 1:N | One student can receive multiple visitors |
| USERS | can be | STUDENTS | 1:1 | One user can be associated with one student |
| USERS | can handle | COMPLAINTS | 1:N | One user can handle multiple complaints |
| HOSTEL | can have | MESS_MENU | 1:N | One hostel can have multiple menu items |
| HOSTEL | can receive | COMPLAINTS | 1:N | One hostel can receive multiple complaints |
| HOSTEL | can require | MAINTENANCE | 1:N | One hostel can have multiple maintenance requests |

### Key Constraints and Business Rules

1. **Room Capacity Constraint:** A room cannot have more active allocations than its capacity
2. **Unique Active Allocation:** A student can have only one active room allocation at a time
3. **Fee Calculation:** Yearly fee = Monthly fee × 12 (with possible discounts)
4. **Attendance Uniqueness:** Only one attendance record per student per day
5. **Complaint Status Flow:** Status must follow: Pending → In Progress → Resolved/Rejected
6. **Visitor Exit Time:** Exit time must be after entry time
7. **Hostel Verification:** Only verified hostels are displayed to students
8. **Room Status:** Room status automatically updates based on occupancy
9. **Fee Due Calculation:** Due amount = Fee amount - Paid amount
10. **Security Deposit:** Must be paid before room allocation

---

## 4. TEST CASES MATRIX

### Critical Test Cases for System Validation

| Test Case ID | Test Case Name | Description | Test Steps | Expected Result | Priority |
|--------------|----------------|-------------|------------|-----------------|----------|
| TC-001 | Search Filtering Validation | Verify hostel search filters work correctly | 1. Navigate to hostel search page<br>2. Apply multiple filters (type, budget, facilities)<br>3. Verify results match all criteria | Only hostels matching ALL filters are displayed | High |
| TC-002 | Room Overbooking Prevention | Prevent allocating more students than room capacity | 1. Find room with 1 available bed<br>2. Attempt to allocate 2 students<br>3. Verify system prevents overbooking | System rejects allocation with capacity error | Critical |
| TC-003 | Unauthorized Admin Access | Prevent non-admin users from accessing admin functions | 1. Login as student<br>2. Attempt to access admin dashboard URL directly<br>3. Verify access is denied | System redirects to login with authorization error | Critical |
| TC-004 | Fee Calculation Accuracy | Verify fee calculations are correct | 1. Create fee record with monthly fee ₹5,000<br>2. Set fee type as yearly<br>3. Verify yearly fee calculated as ₹60,000 | System correctly calculates yearly fee as ₹60,000 | High |
| TC-005 | Duplicate Student Validation | Prevent creating duplicate student records | 1. Create student with unique ID "SRGEC2024001"<br>2. Attempt to create another student with same ID<br>3. Verify system prevents duplicate | System rejects duplicate with validation error | High |
| TC-006 | Complaint State Machine | Verify complaint status transitions work correctly | 1. Create complaint with status "Pending"<br>2. Update to "In Progress"<br>3. Attempt direct transition to "Resolved"<br>4. Verify proper state flow | System allows only valid status transitions | High |
| TC-007 | Attendance Duplicate Prevention | Prevent duplicate attendance records for same day | 1. Mark attendance for student on specific date<br>2. Attempt to mark attendance again for same date<br>3. Verify system prevents duplicate | System updates existing record instead of creating duplicate | Medium |
| TC-008 | Payment Recording Accuracy | Verify fee payment recording updates balances correctly | 1. Create fee record with amount ₹54,000<br>2. Record payment of ₹27,000<br>3. Verify due amount is ₹27,000 | System correctly updates paid amount and calculates due | High |
| TC-009 | Visitor Entry/Exit Validation | Validate visitor entry and exit time logic | 1. Record visitor entry at 10:00 AM<br>2. Attempt to record exit at 9:00 AM<br>3. Verify system prevents invalid exit time | System rejects exit time before entry time | Medium |
| TC-010 | Room Status Auto-Update | Verify room status updates automatically based on occupancy | 1. Allocate student to available room<br>2. Verify room status changes to "occupied"<br>3. Check out student<br>4. Verify room status changes to "available" | Room status automatically updates with allocation changes | High |
| TC-011 | Mess Menu Update Validation | Verify mess menu updates reflect correctly | 1. Update Monday breakfast menu<br>2. View mess menu for Monday<br>3. Verify updated items are displayed | Updated menu items are correctly displayed | Medium |
| TC-012 | Hostel Verification Workflow | Verify hostel verification process works correctly | 1. Admin creates new hostel (status: pending)<br>2. Admin verifies hostel<br>3. Verify status changes to "verified"<br>4. Check if hostel appears in student search | Hostel verification status updates and becomes visible | High |

### Test Case Details

#### TC-001: Search Filtering Validation
**Objective:** Ensure hostel search filters work individually and in combination  
**Preconditions:** Database contains test hostels with various attributes  
**Test Data:**
- Hostel A: Boys, ₹4,500/month, WiFi, 0.5km from college
- Hostel B: Girls, ₹5,000/month, Mess, 1.2km from college
- Hostel C: Boys, ₹8,000/month, AC, 2.0km from college

**Test Steps:**
1. Navigate to hostel search page
2. Apply filter: Type = "Boys"
3. Verify: Only Hostel A and Hostel C displayed
4. Add filter: Budget = "Below ₹5,000"
5. Verify: Only Hostel A displayed
6. Add filter: Facility = "WiFi"
7. Verify: Hostel A still displayed
8. Clear all filters
9. Apply filter: Distance = "Within 1km"
10. Verify: Only Hostel A displayed

**Expected Result:** Filters work individually and in combination, showing only matching hostels

#### TC-002: Room Overbooking Prevention
**Objective:** Prevent allocating more students than room capacity  
**Preconditions:** Room exists with capacity 3, current occupancy 2  
**Test Steps:**
1. Navigate to room allocation page
2. Select room with 1 available bed
3. Attempt to allocate 2 students simultaneously
4. Verify system response

**Expected Result:** System prevents overbooking with error message: "Room has only 1 available bed"

#### TC-003: Unauthorized Admin Access
**Objective:** Ensure role-based access control prevents unauthorized access  
**Preconditions:** Student account exists with valid credentials  
**Test Steps:**
1. Login as student user
2. Attempt to access /admin/dashboard URL directly
3. Verify system response
4. Check user is redirected to login or access denied page

**Expected Result:** System denies access with 403 Forbidden or redirects to login

#### TC-006: Complaint State Machine
**Objective:** Verify complaint status follows proper lifecycle  
**Preconditions:** Staff account exists with complaint management permissions  
**Test Steps:**
1. Create complaint (status: Pending)
2. Attempt to change status directly to "Resolved"
3. Verify system prevents invalid transition
4. Change status to "In Progress"
5. Change status to "Resolved"
6. Verify successful transition
7. Attempt to change resolved complaint back to "Pending"
8. Verify this transition is allowed

**Expected Result:** System enforces valid status transitions per state machine rules

---

## 5. SYSTEM ARCHITECTURE SUMMARY

### Three-Layer Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  (HTML5, CSS3, JavaScript, Bootstrap 5)                  │
│  - Home Page                                           │
│  - Hostel Listing & Filtering                          │
│  - Hostel Details                                      │
│  - Admin Dashboard                                     │
└────────────────────┬────────────────────────────────────┘
                     │ HTTP/HTTPS
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    APPLICATION LAYER                     │
│  (PHP Controllers, Business Logic)                      │
│  - Authentication & Authorization                       │
│  - Hostel Search & Filtering                           │
│  - Room Allocation Management                          │
│  - Complaint Lifecycle Management                      │
│  - Fee Processing & Tracking                           │
│  - Attendance Recording                                │
└────────────────────┬────────────────────────────────────┘
                     │ PDO/MySQL
                     ▼
┌─────────────────────────────────────────────────────────┐
│                      DATA LAYER                         │
│  (MySQL Database with 12 Tables)                       │
│  - users, hostels, students, rooms                      │
│  - room_allocations, attendance, fees                   │
│  - mess_menu, complaints, visitors                      │
│  - maintenance, contacts                               │
└─────────────────────────────────────────────────────────┘
```

### Technology Stack Summary

**Frontend:**
- HTML5 (Semantic markup)
- CSS3 (Modern styling with Flexbox/Grid)
- JavaScript (ES6+, DOM manipulation)
- Bootstrap 5 (Responsive framework)
- Font Awesome 6 (Icons)
- Google Fonts (Typography)

**Backend:**
- PHP 8.0+ (Server-side logic)
- PDO (Database connectivity)
- RESTful API architecture
- JSON data exchange
- JWT authentication (planned)

**Database:**
- MySQL 8.0+ (Relational database)
- InnoDB engine (Transaction support)
- Foreign key constraints
- Stored procedures and triggers
- JSON data types for flexible storage

**Development Tools:**
- VS Code (IDE)
- XAMPP/WAMP (Local server environment)
- Git/GitHub (Version control)
- Chrome DevTools (Debugging)

---

## 6. SECURITY CONSIDERATIONS

### Authentication & Authorization
- Password hashing using bcrypt (cost factor: 10)
- Role-based access control (RBAC)
- Session management with secure cookies
- JWT token-based API authentication (planned)

### Input Validation & Sanitization
- All user inputs sanitized using htmlspecialchars()
- SQL injection prevention using PDO prepared statements
- Email validation using PHP filter functions
- File upload validation (type, size, content)

### Data Protection
- HTTPS encryption in production
- Sensitive data never logged
- Regular database backups
- Secure password recovery process

### API Security
- Rate limiting (100 requests/minute per IP)
- CORS configuration for specific domains
- API key authentication for external access
- Request/response validation

---

## 7. DEPLOYMENT CHECKLIST

### Pre-Deployment
- [ ] All database tables created with proper constraints
- [ ] Seed data inserted for testing
- [ ] API endpoints tested and documented
- [ ] Frontend pages responsive and accessible
- [ ] Security measures implemented
- [ ] Error handling and logging configured

### Production Deployment
- [ ] Database credentials secured
- [ ] HTTPS certificate installed
- [ ] Error reporting disabled in production
- [ ] File permissions set correctly
- [ ] Backup procedures established
- [ ] Monitoring and alerting configured

### Post-Deployment
- [ ] Performance testing completed
- [ ] User acceptance testing (UAT) passed
- [ ] Documentation updated
- [ ] Support team trained
- [ ] Maintenance schedule defined

---

## 8. FUTURE ENHANCEMENTS

### Planned Features
1. **Mobile Application:** Native Android/iOS app for students
2. **Payment Gateway Integration:** Online fee payment processing
3. **AI-Powered Recommendations:** Smart hostel suggestions
4. **Real-time Notifications:** Push notifications for complaints and alerts
5. **Advanced Analytics:** Predictive analytics for occupancy and trends
6. **Multi-language Support:** Telugu and Hindi language options
7. **Virtual Tours:** 360° hostel room virtual tours
8. **Parent Portal:** Dedicated portal for parents to monitor students

### Scalability Considerations
- Database sharding for multi-location deployment
- Load balancing for high traffic
- CDN integration for static assets
- Caching layer for frequently accessed data
- Microservices architecture for modular scaling

---

This academic documentation provides a comprehensive foundation for the "Find My Hostel" project, covering all essential aspects of software engineering including requirements analysis, system design, implementation details, and quality assurance measures.