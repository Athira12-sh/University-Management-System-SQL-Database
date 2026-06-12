-- UNIVERSITY MANAGEMENT SYSTEM DATABASE
-- Create Database
CREATE DATABASE UniversityManagementSystem;
USE UniversityManagementSystem;
-- DEPARTMENTS TABLE
CREATE TABLE Departments (
DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
DepartmentName VARCHAR(100) NOT NULL UNIQUE,
OfficeLocation VARCHAR(100)
);
-- STUDENTS TABLE
CREATE TABLE Students (
StudentID INT PRIMARY KEY AUTO_INCREMENT,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR(100) UNIQUE NOT NULL,
Gender VARCHAR(10),
DateOfBirth DATE,
EnrollmentDate DATE NOT NULL,
DepartmentID INT,
FOREIGN KEY (DepartmentID)
REFERENCES Departments(DepartmentID)
);
-- INSTRUCTORS TABLE
CREATE TABLE Instructors (
InstructorID INT PRIMARY KEY AUTO_INCREMENT,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR(100) UNIQUE NOT NULL,
HireDate DATE NOT NULL,
DepartmentID INT,
FOREIGN KEY (DepartmentID)
REFERENCES Departments(DepartmentID)
);
-- COURSES TABLE
CREATE TABLE Courses (
CourseID INT PRIMARY KEY AUTO_INCREMENT,
CourseCode VARCHAR(20) UNIQUE NOT NULL,
CourseName VARCHAR(100) NOT NULL,
Credits INT CHECK (Credits BETWEEN 1 AND 6),
DepartmentID INT,
InstructorID INT,
FOREIGN KEY (DepartmentID)
REFERENCES Departments(DepartmentID),
FOREIGN KEY (InstructorID)
REFERENCES Instructors(InstructorID)
);
-- ENROLLMENTS TABLE
CREATE TABLE Enrollments (
EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
StudentID INT NOT NULL,
CourseID INT NOT NULL,
EnrollmentDate DATE NOT NULL,
Grade VARCHAR(5),
FOREIGN KEY (StudentID)
REFERENCES Students(StudentID),
FOREIGN KEY (CourseID)
REFERENCES Courses(CourseID),
UNIQUE(StudentID, CourseID)
);
-- DATA INSERTION
INSERT INTO Departments
(DepartmentName, OfficeLocation)
VALUES
('Computer Science','Building A'),
('Business Management','Building B'),
('Data Science','Building C');
INSERT INTO Students
(FirstName, LastName, Email, Gender,
DateOfBirth, EnrollmentDate, DepartmentID)
VALUES
('John','Smith','john@university.edu',
'Male','2003-05-10','2024-09-01',1),
('Emma','Wilson','emma@university.edu',
'Female','2002-08-15','2024-09-01',1),
('David','Brown','david@university.edu',
'Male','2001-12-20','2024-09-01',2);
INSERT INTO Instructors
(FirstName, LastName, Email,
HireDate, DepartmentID)
VALUES
('Michael','Johnson',
'michael@university.edu',
'2020-01-15',1),
('Sarah','Davis',
'sarah@university.edu',
'2021-03-10',2);
INSERT INTO Courses
(CourseCode, CourseName,
Credits, DepartmentID, InstructorID)
VALUES
('CS101','Database Systems',4,1,1),
('CS102','Big Data Analytics',4,1,1),
('BM201','Marketing Principles',3,2,2);
INSERT INTO Enrollments
(StudentID, CourseID,
EnrollmentDate, Grade)
VALUES
(1,1,'2024-09-05','A'),
(1,2,'2024-09-05','B+'),
(2,1,'2024-09-05','A-'),
(3,3,'2024-09-05','B');
-- CRUD OPERATIONS
-- INSERT
INSERT INTO Students
(FirstName, LastName, Email,
Gender, DateOfBirth,
EnrollmentDate, DepartmentID)
VALUES
('Sophia','Taylor',
'sophia@university.edu',
'Female','2004-04-15',
'2024-09-01',3);
-- UPDATE
UPDATE Students
SET Email='johnsmith@university.edu'
WHERE StudentID=1;

-- DELETE
DELETE FROM Enrollments
WHERE EnrollmentID=4;
-- BASIC QUERIES
-- View all students
SELECT * FROM Students;

-- View all courses
SELECT * FROM Courses;

-- Students in Computer Science
SELECT FirstName, LastName
FROM Students
WHERE DepartmentID = 1;
-- JOIN QUERIES
-- Student course enrollment report
SELECT
s.StudentID,
s.FirstName,
s.LastName,
c.CourseName,
e.Grade
FROM Students s
JOIN Enrollments e
ON s.StudentID = e.StudentID
JOIN Courses c
ON c.CourseID = e.CourseID;

-- Instructor teaching courses
SELECT
i.FirstName,
i.LastName,
c.CourseName
FROM Instructors i
JOIN Courses c
ON i.InstructorID = c.InstructorID;
-- AGGREGATE QUERIES
-- Total students
SELECT COUNT(*) AS TotalStudents
FROM Students;

-- Students per department
SELECT
d.DepartmentName,
COUNT(s.StudentID) AS StudentCount
FROM Departments d
LEFT JOIN Students s
ON d.DepartmentID = s.DepartmentID
GROUP BY d.DepartmentName;

-- Courses per instructor
SELECT
i.FirstName,
i.LastName,
COUNT(c.CourseID) AS TotalCourses
FROM Instructors i
LEFT JOIN Courses c
ON i.InstructorID = c.InstructorID
GROUP BY i.InstructorID;
-- ADVANCED BUSINESS QUERIES
-- Most enrolled course
SELECT
c.CourseName,
COUNT(e.StudentID) AS Enrollments
FROM Courses c
JOIN Enrollments e
ON c.CourseID = e.CourseID
GROUP BY c.CourseName
ORDER BY Enrollments DESC;

-- Student grades report
SELECT
s.FirstName,
s.LastName,
c.CourseName,
e.Grade
FROM Students s
JOIN Enrollments e
ON s.StudentID = e.StudentID
JOIN Courses c
ON e.CourseID = c.CourseID
ORDER BY s.LastName;

-- Department-wise enrollment statistics
SELECT
d.DepartmentName,
COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Departments d
JOIN Students s
ON d.DepartmentID = s.DepartmentID
JOIN Enrollments e
ON s.StudentID = e.StudentID
GROUP BY d.DepartmentName;
-- INDEXES FOR OPTIMIZATION
CREATE INDEX idx_student_email
ON Students(Email);

CREATE INDEX idx_course_name
ON Courses(CourseName);

CREATE INDEX idx_enrollment_student
ON Enrollments(StudentID);

CREATE INDEX idx_enrollment_course
ON Enrollments(CourseID);
