CREATE DATABASE exercises5_3;
USE exercises5_3;

CREATE TABLE class (
    classId INT PRIMARY KEY,
    className VARCHAR(100),
    startDate DATE,
    status BIT
);

CREATE TABLE student (
    studentId INT PRIMARY KEY,
    studentName VARCHAR(100),
    address VARCHAR(255),
    phone VARCHAR(11),
    class_id INT,
    status BIT,
    FOREIGN KEY (class_id) REFERENCES class(classId)
);

CREATE TABLE subject (
    subjectId INT PRIMARY KEY,
    subjectName VARCHAR(100),
    credit INT,
    status BIT
);

CREATE TABLE mark (
    markId INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    mark DOUBLE,
    examTime DATETIME,
    FOREIGN KEY (student_id) REFERENCES student(studentId),
    FOREIGN KEY (subject_id) REFERENCES subject(subjectId)
);

-- Insert data into class table
INSERT INTO class (classId, className, startDate, status) VALUES
(1, 'HN-JV231103', '2023-11-03', 1),
(2, 'HN-JV231229', '2023-12-29', 1),
(3, 'HN-JV230615', '2023-06-15', 1);

-- Insert data into student table
INSERT INTO student (studentId, studentName, address, phone, class_id, status) VALUES
(1, 'Hồ Da Hùng', 'Hà nội', '0987654321', 1, 1),
(2, 'Phan Văn Giang', 'Đà nẵng', '0967811255', 1, 1),
(3, 'Dương Mỹ Huyền', 'Hà nội', '0835546612', 2, 1),
(4, 'Hoàng Minh Hiếu', 'Nghệ An', '0964425633', 2, 1),
(5, 'Nguyễn Vịnh', 'Hà nội', '0975123552', 2, 1),
(6, 'Nam Cao', 'Hà tĩnh', '0919191919', 3, 1),
(7, 'Nguyễn Du', 'Nghệ An', '0353535353', 3, 1);

-- Insert data into subject table
INSERT INTO subject (subjectId, subjectName, credit, status) VALUES
(1, 'Toán', 3, 1),
(2, 'Văn', 3, 1),
(3, 'Anh', 2, 1);

-- Insert data into mark table
INSERT INTO mark (markId, student_id, subject_id, mark, examTime) VALUES
(1, 1, 1, 7, '2024-05-12'),
(2, 1, 2, 7, '2024-03-15'),
(3, 2, 3, 8, '2024-05-15'),
(4, 3, 1, 9, '2024-03-08'),
(5, 3, 3, 10, '2024-02-11');

DELIMITER //
CREATE PROCEDURE GetClassesWithMoreThanFiveStudents()
BEGIN
    SELECT c.classId, c.className, COUNT(s.studentId) AS studentCount
    FROM class c
    JOIN student s ON c.classId = s.class_id
    GROUP BY c.classId, c.className
    HAVING COUNT(s.studentId) > 5;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetSubjectsWithPerfectScore()
BEGIN
    SELECT DISTINCT sub.subjectId, sub.subjectName
    FROM subject sub
    JOIN mark m ON sub.subjectId = m.subject_id
    WHERE m.mark = 10;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetClassesWithStudentsWhoScored10()
BEGIN
    SELECT DISTINCT c.classId, c.className
    FROM class c
    JOIN student s ON c.classId = s.class_id
    JOIN mark m ON s.studentId = m.student_id
    WHERE m.mark = 10;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AddNewStudent(IN studentName VARCHAR(100), IN address VARCHAR(255), IN phone VARCHAR(11), IN class_id INT, IN status BIT)
BEGIN
    INSERT INTO student (studentName, address, phone, class_id, status)
    VALUES (studentName, address, phone, class_id, status);
    
    SELECT LAST_INSERT_ID() AS NewStudentID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetSubjectsNotTaken()
BEGIN
    SELECT sub.subjectId, sub.subjectName
    FROM subject sub
    LEFT JOIN mark m ON sub.subjectId = m.subject_id
    WHERE m.subject_id IS NULL;
END //
DELIMITER ;




