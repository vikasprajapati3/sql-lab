-- PRACTICAL 3: CREATING AND MANAGING TABLES
-- DATABASE: STUDENT MANAGEMENT SYSTEM

-- 1. CREATE TABLE
-- DDL command used to create a new table.
-- Syntax:
--   CREATE TABLE table_name (
--       column_name datatype [constraint],
--       ...
--   );

CREATE TABLE departments (
    dept_id     NUMBER(5),
    dept_name   VARCHAR2(40) NOT NULL,
    location    VARCHAR2(40),
    CONSTRAINT pk_departments PRIMARY KEY (dept_id)
);

CREATE TABLE students (
    student_id     NUMBER(5),
    first_name     VARCHAR2(30) NOT NULL,
    last_name      VARCHAR2(30) NOT NULL,
    email          VARCHAR2(80),
    gender         VARCHAR2(1),
    date_of_birth  DATE,
    dept_id        NUMBER(5),
    CONSTRAINT pk_students PRIMARY KEY (student_id)
);

CREATE TABLE courses (
    course_id    NUMBER(5),
    course_name  VARCHAR2(50) NOT NULL,
    credits      NUMBER(2),
    course_fee   NUMBER(8,2),
    CONSTRAINT pk_courses PRIMARY KEY (course_id)
);

-- DESC displays column names, datatypes and NULL rules.
DESC departments;
DESC students;
DESC courses;

-- 2. NOT NULL CONSTRAINT
-- A column must contain a value (useful for compulsory data).
-- Syntax: ALTER TABLE table_name MODIFY column_name NOT NULL;

ALTER TABLE students
MODIFY email NOT NULL;

-- 3. UNIQUE CONSTRAINT
-- Prevents duplicate values. Every student needs a different email.
-- Syntax: ALTER TABLE table_name
--         ADD CONSTRAINT constraint_name UNIQUE (column_name);

ALTER TABLE students
ADD CONSTRAINT uq_student_email
UNIQUE (email);

-- 4. PRIMARY KEY CONSTRAINT
-- Uniquely identifies every record; no duplicates or NULLs.
-- Defined in Section 1. To add one later:
--   ALTER TABLE table_name ADD CONSTRAINT pk_name PRIMARY KEY (column_name);

-- 5. CHECK CONSTRAINT
-- Restricts column values according to a condition.
-- Syntax: ALTER TABLE table_name
--         ADD CONSTRAINT constraint_name CHECK (condition);

ALTER TABLE students
ADD CONSTRAINT chk_gender
CHECK (gender IN ('M', 'F'));

ALTER TABLE courses
ADD CONSTRAINT chk_credits
CHECK (credits BETWEEN 1 AND 6);

ALTER TABLE courses
ADD CONSTRAINT chk_course_fee
CHECK (course_fee > 0);

-- 6. INSERT SAMPLE DATA
-- INSERT adds new records to an existing table.
-- Syntax with column list (safer than relying on column order):
--   INSERT INTO departments (dept_id, dept_name, location)
--   VALUES (101, 'Computer Science', 'Mumbai');

INSERT INTO departments
VALUES (101, 'Computer Science', 'Mumbai');
INSERT INTO departments
VALUES (102, 'Information Technology', 'Pune');
INSERT INTO departments
VALUES (103, 'Electronics', 'Nashik');

INSERT INTO students
VALUES (1001, 'Aarav', 'Sharma', 'aarav@example.com',
        'M', DATE '2005-04-12', 101);
INSERT INTO students
VALUES (1002, 'Sneha', 'Kulkarni', 'sneha@example.com',
        'F', DATE '2005-09-18', 102);
INSERT INTO students
VALUES (1003, 'Aditya', 'More', 'aditya@example.com',
        'M', DATE '2004-12-05', 101);

INSERT INTO courses
VALUES (201, 'DBMS', 4, 12000);
INSERT INTO courses
VALUES (202, 'Python Programming', 3, 10000);
INSERT INTO courses
VALUES (203, 'Data Structures', 4, 15000);

COMMIT;

-- 7. ALTER TABLE - ADD COLUMN
-- Adds a new column without recreating the table.
-- Syntax: ALTER TABLE table_name ADD column_name datatype;

ALTER TABLE students
ADD mobile_number VARCHAR2(15);
ALTER TABLE students
ADD admission_year NUMBER(4);

-- 8. ALTER TABLE - MODIFY COLUMN
-- Changes datatype or size; existing data must stay compatible.
-- Syntax: ALTER TABLE table_name MODIFY column_name new_datatype;

ALTER TABLE students
MODIFY first_name VARCHAR2(50);
ALTER TABLE students
MODIFY email VARCHAR2(120);

-- 9. RENAME COLUMN
-- Changes a column's name without losing its data.
-- Syntax: ALTER TABLE table_name RENAME COLUMN old_name TO new_name;

ALTER TABLE students
RENAME COLUMN mobile_number TO contact_number;

-- 10. DROP COLUMN
-- Permanently removes a column and its stored values.
-- Syntax: ALTER TABLE table_name DROP COLUMN column_name;

ALTER TABLE students
ADD temporary_notes VARCHAR2(50);
ALTER TABLE students
DROP COLUMN temporary_notes;

-- 11. ADD CONSTRAINT USING ALTER TABLE
-- Constraints can be added after table creation.
-- Admission year is restricted to a valid range.

ALTER TABLE students
ADD CONSTRAINT chk_admission_year
CHECK (admission_year BETWEEN 2000 AND 2035);

-- A foreign key ensures students belong to existing departments.
-- Syntax:
--   ALTER TABLE child_table
--   ADD CONSTRAINT fk_name
--   FOREIGN KEY (child_column)
--   REFERENCES parent_table (parent_column);

ALTER TABLE students
ADD CONSTRAINT fk_student_department
FOREIGN KEY (dept_id)
REFERENCES departments (dept_id);

-- 12. DROP CONSTRAINT
-- Removes a restriction without deleting the column itself.
-- Syntax: ALTER TABLE table_name DROP CONSTRAINT constraint_name;

ALTER TABLE students
DROP CONSTRAINT chk_admission_year;

-- 13. CREATE TABLE AS SELECT (CTAS)
-- Creates a new table from a SELECT; used for backups and reports.
-- Syntax: CREATE TABLE new_table AS
--         SELECT column_list FROM existing_table WHERE condition;

CREATE TABLE students_backup AS
SELECT *
FROM students;

-- Separate list of Computer Science students.
CREATE TABLE cs_students AS
SELECT student_id, first_name, last_name, email
FROM students
WHERE dept_id = 101;

-- Empty copy of courses: WHERE 1 = 2 returns no rows but keeps columns.
CREATE TABLE courses_empty AS
SELECT *
FROM courses
WHERE 1 = 2;

-- 14. TRUNCATE TABLE
-- Removes all records but keeps the structure.
-- It cannot be rolled back in Oracle.
-- Syntax: TRUNCATE TABLE table_name;

TRUNCATE TABLE courses_empty;

-- 15. RENAME TABLE
-- Changes the name of a table; no copy is created.
-- Syntax: RENAME old_table_name TO new_table_name;

RENAME students_backup TO student_backup_2025;

-- 16. DROP TABLE
-- Permanently removes a table and its structure. Use carefully.
-- Syntax: DROP TABLE table_name;

DROP TABLE courses_empty;

-- 17. VERIFY TABLES AND CONSTRAINTS
-- USER_CONSTRAINTS lists constraints owned by the current user.
-- constraint_type: P = Primary key, U = Unique,
--                  C = Check / Not null, R = Foreign key

SELECT table_name, constraint_name, constraint_type
FROM user_constraints
WHERE table_name IN ('STUDENTS', 'DEPARTMENTS', 'COURSES')
ORDER BY table_name;

-- Display the final table records.

SELECT * FROM departments;
SELECT * FROM students;
SELECT * FROM courses;

-- PRACTICE QUESTIONS
-- Write and run the queries yourself. Verify with DESC or USER_CONSTRAINTS.
--
-- Q1. Create table faculty: faculty_id (primary key), faculty_name
--     (not null), email (unique), salary and dept_id.
-- Q2. Add a CHECK constraint so salary > 0, then add a foreign key
--     from faculty.dept_id to departments.
-- Q3. Add column phone_number VARCHAR2(15) to faculty, rename it to
--     contact_number, then modify its size to VARCHAR2(20).
-- Q4. Insert three faculty records. Then try a duplicate email and a
--     negative salary, and explain each error.
-- Q5. Create faculty_backup from faculty using CTAS, then create an
--     empty copy named faculty_empty (hint: WHERE 1 = 2).
-- Q6. Rename faculty_backup to faculty_archive, truncate and drop
--     faculty_empty, then list all constraints on faculty.

-- END OF FILE 01