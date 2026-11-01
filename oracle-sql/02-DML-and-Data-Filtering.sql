-- FILE 02: DML AND DATA FILTERING (PRACTICAL 4)
-- DML (Data Manipulation Language): INSERT, UPDATE, DELETE
-- SELECT is technically DQL (Data Query Language).

-- 1. CREATE STUDENT TABLE
CREATE TABLE students (
    rollno   NUMBER(5) PRIMARY KEY,
    name     VARCHAR2(20) NOT NULL,
    batch    NUMBER(1),
    b_grp    VARCHAR2(5),
    address  VARCHAR2(30),
    gender   VARCHAR2(1) NOT NULL,
    age      NUMBER(2) NOT NULL,
    marks    NUMBER(3)
);

-- 2. INSERT COMMAND
-- Syntax: INSERT INTO table_name (col1, col2, ...) VALUES (val1, val2, ...);

-- Insert with column names
INSERT INTO students
    (rollno, name, batch, b_grp, address, gender, age, marks)
VALUES
    (6072, 'Bhakti', 2, 'B+', 'Dadar', 'F', 19, 86);

-- Insert without column names (values must follow table column order)
-- Syntax: INSERT INTO table_name VALUES (val1, val2, ...);
INSERT INTO students
VALUES (6073, 'Desai', 1, 'A+', 'Mumbai', 'M', 20, 95);
INSERT INTO students
VALUES (6074, 'Amit', 2, 'A-', 'Thane', 'M', 19, 90);
INSERT INTO students
VALUES (6075, 'Abhishek', 1, 'O+', 'Dombivli', 'M', 19, 75);
INSERT INTO students
VALUES (6076, 'Sameer', 2, 'O-', 'Dombivli', 'M', 20, 81);
INSERT INTO students
VALUES (6077, 'Saniya', 1, 'B+', 'Ghatkopar', 'F', 19, 92);
INSERT INTO students
VALUES (6078, 'Subhra', 2, 'B-', 'Kalyan', 'F', 19, 84);
INSERT INTO students
VALUES (6079, 'Ankur', 2, 'AB-', 'Matunga', 'M', 20, 89);
INSERT INTO students
VALUES (6080, 'Kartik', 1, 'A+', 'Ghatkopar', 'M', 19, 80);

COMMIT;

-- 3. SELECT COMMAND
-- Syntax: SELECT column_list FROM table_name [WHERE condition];

-- Display all columns
SELECT * FROM students;

-- Display selected columns
SELECT rollno, name, marks
FROM students;

-- 4. UPDATE COMMAND
-- Syntax: UPDATE table_name SET column = value [WHERE condition];
-- Without WHERE, every row in the table is updated.

-- Update one column
UPDATE students
SET name = 'Aryan'
WHERE rollno = 6076;

-- Update multiple columns
UPDATE students
SET name    = 'Sameer',
    marks   = 88,
    address = 'Mumbai'
WHERE rollno = 6076;

-- 5. DELETE COMMAND
-- Syntax: DELETE FROM table_name [WHERE condition];
DELETE FROM students
WHERE rollno = 6076;

-- Delete all rows (table structure remains)
 DELETE FROM students;

-- 6. WHERE CLAUSE AND LOGICAL OPERATORS
-- Syntax: SELECT columns FROM table_name WHERE condition1 AND/OR condition2;

-- AND: both conditions must be true
SELECT * FROM students
WHERE marks >= 80
  AND age = 19;

-- OR: at least one condition must be true
SELECT * FROM students
WHERE gender = 'F'
   OR marks > 90;

-- NOT: reverses the condition
SELECT * FROM students
WHERE NOT gender = 'M';

-- 7. IN AND NOT IN OPERATORS
-- Syntax: WHERE column [NOT] IN (value1, value2, ...);
SELECT * FROM students
WHERE age IN (19, 20);
SELECT * FROM students
WHERE age NOT IN (18, 22);

-- 8. BETWEEN AND NOT BETWEEN
-- Syntax: WHERE column [NOT] BETWEEN low_value AND high_value;  (ends included)
SELECT * FROM students
WHERE marks BETWEEN 80 AND 95;
SELECT * FROM students
WHERE marks NOT BETWEEN 80 AND 90;

-- 9. LIKE OPERATOR
-- Syntax: WHERE column LIKE 'pattern';
-- % = any number of characters, _ = exactly one character

-- Names starting with A
SELECT * FROM students
WHERE name LIKE 'A%';

-- Names ending with i
SELECT * FROM students
WHERE name LIKE '%i';

-- Names containing a
SELECT * FROM students
WHERE name LIKE '%a%';

-- Underscore represents one character (third letter is a)
SELECT * FROM students
WHERE name LIKE '__a%';

-- 10. DISTINCT
-- Removes duplicate values from the result.
-- Syntax: SELECT DISTINCT column_name FROM table_name;
SELECT DISTINCT b_grp
FROM students;
SELECT DISTINCT address
FROM students;

-- 11. COLUMN ALIAS USING AS
-- Alias = temporary name. Syntax: SELECT column_name AS alias_name FROM table_name;
SELECT rollno AS student_id,
       name   AS student_name,
       marks  AS total_marks
FROM students;

-- 12. ORDER BY
-- Syntax: SELECT columns FROM table_name ORDER BY column [ASC | DESC];

-- Ascending order (default)
SELECT * FROM students
ORDER BY marks ASC;

-- Descending order
SELECT * FROM students
ORDER BY marks DESC;

-- Multiple columns (batch first, then highest marks within each batch)
SELECT * FROM students
ORDER BY batch ASC,
         marks DESC;

-- 13. NULL VALUES AND NVL
-- NULL means unknown or missing; use IS NULL, never = NULL.
-- Syntax: WHERE column IS [NOT] NULL;
SELECT * FROM students
WHERE b_grp IS NULL;
SELECT * FROM students
WHERE b_grp IS NOT NULL;

-- NVL replaces NULL with another value
-- Syntax: NVL(column, replacement_value)
SELECT name,
       NVL(b_grp, 'Not Available') AS blood_group
FROM students;

-- 14. ANY AND ALL OPERATORS
-- Syntax: WHERE column operator ANY | ALL (subquery);

-- ANY: condition must be true for at least one value
SELECT * FROM students
WHERE marks > ANY (
    SELECT marks
    FROM students
    WHERE gender = 'F'
);

-- ALL: condition must be true for every value
SELECT * FROM students
WHERE marks > ALL (
    SELECT marks
    FROM students
    WHERE gender = 'F'
);

-- 15. MONTHS_BETWEEN FUNCTION
-- Returns the number of months between two dates.
-- Syntax: MONTHS_BETWEEN(later_date, earlier_date)
SELECT MONTHS_BETWEEN(SYSDATE, DATE '2024-01-01') AS total_months
FROM dual;

-- Calculate work experience
CREATE TABLE employee_filter (
    emp_id    NUMBER(5),
    emp_name  VARCHAR2(30),
    job       VARCHAR2(20),
    doj       DATE
);

INSERT INTO employee_filter
VALUES (101, 'Amit', 'Tester', DATE '2020-01-15');
INSERT INTO employee_filter
VALUES (102, 'Rahul', 'Developer', DATE '2022-06-10');

SELECT emp_name,
       ROUND(MONTHS_BETWEEN(SYSDATE, doj) / 12, 1) AS work_years
FROM employee_filter
WHERE job = 'Tester';

-- 16. SUBQUERY WITH IN
-- A subquery is a query nested inside another query.
-- Syntax: WHERE column IN (SELECT column FROM table WHERE condition);
SELECT * FROM students
WHERE rollno IN (
    SELECT rollno
    FROM students
    WHERE marks > 85
);

-- 17. FINAL RESULT
SELECT * FROM students
ORDER BY rollno;

COMMIT;

-- PRACTICE QUESTIONS
-- Use the students table. Write and run the queries yourself.
-- Q1. Insert a new student (rollno 6081, Neha, batch 2, blood group
--     NULL, Pune, F, 20, 78) and display only name and marks.
-- Q2. Update the address of all students living in Ghatkopar to
--     'Mumbai', then delete students who scored below 80.
-- Q3. Display female students aged 19+ with marks between 80 and 95.
-- Q4. Display names that start with S and have exactly 6 letters
--     (use LIKE with % and _), sorted by marks in descending order.
-- Q5. Show names with blood group, using NVL to show 'Unknown' for NULL.
-- Q6. Using ALL, display students scoring higher than every male student.

-- END OF FILE 02