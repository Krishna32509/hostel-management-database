-- ============================================================
--  HOSTEL ROOM ALLOCATION & COMPLAINT MANAGEMENT SYSTEM
--  MySQL 8.x | Normalized up to 5NF
-- ============================================================

-- ============================================================
--  SECTION 1: DDL - CREATE TABLES
-- ============================================================

CREATE TABLE Department (
    dept_code  CHAR(5)     NOT NULL,
    dept_name  VARCHAR(80) NOT NULL,
    PRIMARY KEY (dept_code),
    UNIQUE (dept_name)
);

CREATE TABLE Hostel (
    hostel_id   INT         NOT NULL AUTO_INCREMENT,
    hostel_name VARCHAR(60) NOT NULL,
    hostel_type CHAR(1)     NOT NULL,
    PRIMARY KEY (hostel_id),
    UNIQUE (hostel_name),
    CHECK (hostel_type IN ('M','F'))
);

CREATE TABLE Room (
    room_id     INT         NOT NULL AUTO_INCREMENT,
    hostel_id   INT         NOT NULL,
    room_number VARCHAR(10) NOT NULL,
    floor_no    SMALLINT    NOT NULL,
    capacity    SMALLINT    NOT NULL,
    PRIMARY KEY (room_id),
    UNIQUE (hostel_id, room_number),
    FOREIGN KEY (hostel_id) REFERENCES Hostel(hostel_id),
    CHECK (floor_no >= 0),
    CHECK (capacity BETWEEN 1 AND 4)
);

CREATE TABLE Student (
    student_id  VARCHAR(13)  NOT NULL,
    full_name   VARCHAR(80)  NOT NULL,
    gender      CHAR(1)      NOT NULL,
    dept_code   CHAR(5)      NOT NULL,
    study_year  SMALLINT     NOT NULL,
    cgpa        DECIMAL(4,2) NOT NULL,
    email       VARCHAR(100) NOT NULL,
    contact_no  VARCHAR(15)  NOT NULL,
    PRIMARY KEY (student_id),
    UNIQUE (email),
    FOREIGN KEY (dept_code) REFERENCES Department(dept_code),
    CHECK (gender IN ('M','F')),
    CHECK (study_year BETWEEN 1 AND 5),
    CHECK (cgpa BETWEEN 0.00 AND 10.00)
);

CREATE TABLE Allocation (
    allocation_id INT         NOT NULL AUTO_INCREMENT,
    student_id    VARCHAR(13) NOT NULL,
    room_id       INT         NOT NULL,
    from_date     DATE        NOT NULL,
    to_date       DATE,
    status        VARCHAR(10) NOT NULL DEFAULT 'Active',
    PRIMARY KEY (allocation_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (room_id)    REFERENCES Room(room_id),
    CHECK (status IN ('Active','Vacated','Transferred')),
    CHECK (to_date IS NULL OR to_date >= from_date)
);

CREATE TABLE Complaint (
    complaint_id   INT          NOT NULL AUTO_INCREMENT,
    student_id     VARCHAR(13)  NOT NULL,
    room_id        INT          NOT NULL,
    complaint_type VARCHAR(20)  NOT NULL,
    description    VARCHAR(500) NOT NULL,
    reported_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status         VARCHAR(15)  NOT NULL DEFAULT 'Pending',
    PRIMARY KEY (complaint_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (room_id)    REFERENCES Room(room_id),
    CHECK (complaint_type IN ('Electrical','Plumbing','Carpentry','Cleanliness','Network','Other')),
    CHECK (status IN ('Pending','In Progress','Resolved'))
);


-- ============================================================
--  SECTION 2: DML - INSERT SAMPLE DATA
-- ============================================================

INSERT INTO Department VALUES
    ('CSE', 'Computer Science & Engineering'),
    ('ECE', 'Electronics & Communication Engineering'),
    ('ME',  'Mechanical Engineering'),
    ('CE',  'Civil Engineering'),
    ('EE',  'Electrical Engineering');

INSERT INTO Hostel (hostel_name, hostel_type) VALUES
    ('A Block',               'M'),
    ('B Block',               'M'),
    ('Kalpana Chawla Bhawan', 'F'),
    ('Kasturba Bhawan',       'F');

INSERT INTO Room (hostel_id, room_number, floor_no, capacity) VALUES
    (1,'A-101',1,2),(1,'A-102',1,2),(1,'A-103',1,2),
    (1,'A-201',2,2),(1,'A-202',2,2),
    (2,'B-101',1,2),(2,'B-102',1,2),(2,'B-103',1,2),
    (2,'B-201',2,2),(2,'B-202',2,2),
    (3,'KC-101',1,2),(3,'KC-102',1,2),(3,'KC-103',1,2),
    (3,'KC-201',2,2),(3,'KC-202',2,2),
    (4,'KB-101',1,2),(4,'KB-102',1,2),(4,'KB-103',1,2);

INSERT INTO Student VALUES
    ('1024031101','Arjun Sharma', 'M','CSE',2,8.50,'arjun@tiet.ac.in', '9876500001'),
    ('1024031102','Rohan Mehta',  'M','ECE',3,7.80,'rohan@tiet.ac.in', '9876500002'),
    ('1024031103','Karan Singh',  'M','ME', 1,8.10,'karan@tiet.ac.in', '9876500003'),
    ('1024031104','Aman Gupta',   'M','EE', 4,7.50,'aman@tiet.ac.in',  '9876500004'),
    ('1024031105','Nikhil Batra', 'M','CE', 2,8.90,'nikhil@tiet.ac.in','9876500005'),
    ('1024031201','Priya Kaur',   'F','CSE',2,9.10,'priya@tiet.ac.in', '9876500006'),
    ('1024031202','Sneha Verma',  'F','ME', 1,8.20,'sneha@tiet.ac.in', '9876500007'),
    ('1024031203','Riya Sharma',  'F','ECE',3,7.90,'riya@tiet.ac.in',  '9876500008'),
    ('1024031204','Pooja Nair',   'F','EE', 2,8.60,'pooja@tiet.ac.in', '9876500009'),
    ('1024031205','Anjali Singh', 'F','CSE',4,9.30,'anjali@tiet.ac.in','9876500010');

INSERT INTO Allocation (student_id, room_id, from_date, status) VALUES
    ('1024031101', 1,  '2024-08-01', 'Active'),
    ('1024031102', 2,  '2024-08-01', 'Active'),
    ('1024031103', 3,  '2024-08-01', 'Active'),
    ('1024031104', 6,  '2024-08-01', 'Active'),
    ('1024031105', 7,  '2024-08-01', 'Active'),
    ('1024031201', 11, '2024-08-01', 'Active'),
    ('1024031202', 12, '2024-08-01', 'Active'),
    ('1024031203', 13, '2024-08-01', 'Active'),
    ('1024031204', 16, '2024-08-01', 'Active'),
    ('1024031205', 17, '2024-08-01', 'Active');

INSERT INTO Complaint (student_id, room_id, complaint_type, description, status) VALUES
    ('1024031101', 1,  'Electrical', 'Tube light not working since 2 days.',        'Pending'),
    ('1024031102', 2,  'Plumbing',   'Tap in washroom is leaking constantly.',      'In Progress'),
    ('1024031103', 3,  'Network',    'WiFi is extremely slow on floor 1.',           'Pending'),
    ('1024031201', 11, 'Cleanliness','Common area not cleaned for 3 days.',          'Resolved'),
    ('1024031202', 12, 'Carpentry',  'Cupboard door hinge is broken.',               'Pending'),
    ('1024031101', 1,  'Network',    'No internet connectivity after 10 PM.',        'Pending');


-- ============================================================
--  SECTION 3: PL/SQL - TRIGGERS
-- ============================================================

DELIMITER $$

-- T1: Block over-capacity allocation
CREATE TRIGGER trg_check_capacity
BEFORE INSERT ON Allocation
FOR EACH ROW
BEGIN
    DECLARE v_capacity  INT;
    DECLARE v_occupancy INT;

    SELECT capacity INTO v_capacity
    FROM Room WHERE room_id = NEW.room_id;

    SELECT COUNT(*) INTO v_occupancy
    FROM Allocation
    WHERE room_id = NEW.room_id AND status = 'Active';

    IF v_occupancy >= v_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Room is already at full capacity.';
    END IF;
END$$

-- T2: Block gender-hostel mismatch
CREATE TRIGGER trg_check_gender
BEFORE INSERT ON Allocation
FOR EACH ROW
BEGIN
    DECLARE v_gender      CHAR(1);
    DECLARE v_hostel_type CHAR(1);

    SELECT gender INTO v_gender
    FROM Student WHERE student_id = NEW.student_id;

    SELECT h.hostel_type INTO v_hostel_type
    FROM Room r JOIN Hostel h ON h.hostel_id = r.hostel_id
    WHERE r.room_id = NEW.room_id;

    IF v_gender <> v_hostel_type THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Student gender does not match hostel type.';
    END IF;
END$$


-- ============================================================
--  SECTION 4: PL/SQL - STORED PROCEDURES
-- ============================================================

-- P1: Register a complaint
CREATE PROCEDURE sp_register_complaint(
    IN p_student_id  VARCHAR(13),
    IN p_type        VARCHAR(20),
    IN p_description VARCHAR(500)
)
BEGIN
    DECLARE v_room_id INT DEFAULT NULL;

    SELECT room_id INTO v_room_id
    FROM Allocation
    WHERE student_id = p_student_id AND status = 'Active'
    LIMIT 1;

    IF v_room_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Student does not have an active room allocation.';
    ELSE
        INSERT INTO Complaint (student_id, room_id, complaint_type, description)
        VALUES (p_student_id, v_room_id, p_type, p_description);
        SELECT 'Complaint registered successfully.' AS Result;
    END IF;
END$$

-- P2: Vacate a student
CREATE PROCEDURE sp_vacate_student(
    IN p_student_id VARCHAR(13)
)
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM Allocation
    WHERE student_id = p_student_id AND status = 'Active';

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No active allocation found for this student.';
    ELSE
        UPDATE Allocation
        SET status  = 'Vacated',
            to_date = CURRENT_DATE
        WHERE student_id = p_student_id AND status = 'Active';
        SELECT 'Student vacated successfully.' AS Result;
    END IF;
END$$

-- P3: Resolve a complaint
CREATE PROCEDURE sp_resolve_complaint(
    IN p_complaint_id INT
)
BEGIN
    DECLARE v_exists INT;

    SELECT COUNT(*) INTO v_exists
    FROM Complaint
    WHERE complaint_id = p_complaint_id AND status != 'Resolved';

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Complaint not found or already resolved.';
    ELSE
        UPDATE Complaint
        SET status = 'Resolved'
        WHERE complaint_id = p_complaint_id;
        SELECT 'Complaint resolved successfully.' AS Result;
    END IF;
END$$

DELIMITER ;


-- ============================================================
--  SECTION 5: SELECT QUERIES
-- ============================================================

-- Q1: All active allocations (JOIN)
SELECT
    s.student_id,
    s.full_name,
    s.gender,
    d.dept_name,
    h.hostel_name,
    r.room_number,
    r.floor_no,
    a.from_date
FROM Allocation a
JOIN Student    s ON s.student_id = a.student_id
JOIN Department d ON d.dept_code  = s.dept_code
JOIN Room       r ON r.room_id    = a.room_id
JOIN Hostel     h ON h.hostel_id  = r.hostel_id
WHERE a.status = 'Active'
ORDER BY h.hostel_name, r.room_number;

-- Q2: Available rooms with free bed count (GROUP BY + HAVING)
SELECT
    h.hostel_name,
    h.hostel_type,
    r.room_number,
    r.floor_no,
    r.capacity,
    r.capacity - COUNT(a.allocation_id) AS free_beds
FROM Room r
JOIN Hostel h ON h.hostel_id = r.hostel_id
LEFT JOIN Allocation a ON a.room_id = r.room_id AND a.status = 'Active'
GROUP BY h.hostel_name, h.hostel_type, r.room_id, r.room_number, r.floor_no, r.capacity
HAVING free_beds > 0
ORDER BY h.hostel_name, r.room_number;

-- Q3: Pending complaints (JOIN)
SELECT
    c.complaint_id,
    s.full_name       AS student,
    h.hostel_name,
    r.room_number,
    c.complaint_type,
    c.description,
    c.reported_at
FROM Complaint c
JOIN Student s ON s.student_id = c.student_id
JOIN Room    r ON r.room_id    = c.room_id
JOIN Hostel  h ON h.hostel_id  = r.hostel_id
WHERE c.status = 'Pending'
ORDER BY c.reported_at;

-- Q4: Complaint count per student (AGGREGATE + GROUP BY)
SELECT
    s.student_id,
    s.full_name,
    COUNT(c.complaint_id) AS total_complaints
FROM Student s
LEFT JOIN Complaint c ON c.student_id = s.student_id
GROUP BY s.student_id, s.full_name
ORDER BY total_complaints DESC;

-- Q5: Occupancy summary per hostel (AGGREGATE)
SELECT
    h.hostel_name,
    h.hostel_type,
    COUNT(r.room_id)                        AS total_rooms,
    SUM(r.capacity)                         AS total_beds,
    COUNT(a.allocation_id)                  AS occupied_beds,
    SUM(r.capacity) - COUNT(a.allocation_id) AS free_beds
FROM Hostel h
LEFT JOIN Room       r ON r.hostel_id  = h.hostel_id
LEFT JOIN Allocation a ON a.room_id    = r.room_id AND a.status = 'Active'
GROUP BY h.hostel_id, h.hostel_name, h.hostel_type
ORDER BY h.hostel_name;

-- Q6: Students with more than 1 complaint (SUBQUERY)
SELECT s.full_name, s.student_id,
       (SELECT COUNT(*) FROM Complaint c WHERE c.student_id = s.student_id) AS complaints
FROM Student s
WHERE (SELECT COUNT(*) FROM Complaint c WHERE c.student_id = s.student_id) > 1;

-- Q7: Rooms that have never had a complaint (SUBQUERY)
SELECT r.room_id, h.hostel_name, r.room_number
FROM Room r
JOIN Hostel h ON h.hostel_id = r.hostel_id
WHERE r.room_id NOT IN (SELECT DISTINCT room_id FROM Complaint)
ORDER BY h.hostel_name, r.room_number;


-- ============================================================
--  SECTION 6: TEST PROCEDURES
-- ============================================================

CALL sp_register_complaint('1024031104', 'Electrical', 'Fan in room stopped working.');
CALL sp_resolve_complaint(4);
CALL sp_vacate_student('1024031105');

-- ============================================================
--  END
-- ============================================================