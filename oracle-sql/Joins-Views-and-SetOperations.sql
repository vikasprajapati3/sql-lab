-- FILE 04A: JOINS, SET OPERATIONS AND VIEWS
-- DATABASE: ORACLE SQL
-- Uses tables created in file 01: department and employee.
-- Only the tester table (practical 9) is created here.


-- PRACTICAL 4: INNER JOIN
-- Returns only rows that have a match in both tables.
-- Syntax:
--   SELECT columns
--   FROM table1
--   INNER JOIN table2
--       ON table1.column = table2.column;

-- Employees with their department information
SELECT e.e_code,
       e.e_fname,
       e.job,
       e.salary,
       d.d_name,
       d.d_loc
FROM employee e
INNER JOIN department d
    ON e.d_no = d.d_no;


-- PRACTICAL 5: LEFT OUTER JOIN
-- Returns all rows from the left table, and matching rows from the right
-- table (NULL where there is no match).

-- Every department, including departments that have no employees
SELECT d.d_no,
       d.d_name,
       e.e_fname,
       e.job
FROM department d
LEFT OUTER JOIN employee e
    ON d.d_no = e.d_no;


-- PRACTICAL 6: RIGHT OUTER JOIN
-- Returns all rows from the right table, and matching rows from the left
-- table (NULL where there is no match).

SELECT e.e_fname,
       e.job,
       d.d_name,
       d.d_loc
FROM employee e
RIGHT OUTER JOIN department d
    ON e.d_no = d.d_no;


-- PRACTICAL 7: FULL OUTER JOIN
-- Returns all rows from both tables, matched where possible.

SELECT e.e_fname,
       e.job,
       d.d_name
FROM employee e
FULL OUTER JOIN department d
    ON e.d_no = d.d_no;


-- PRACTICAL 8: SELF JOIN
-- A table is joined with itself using two different aliases.

-- Employees with their respective managers
SELECT e.e_code,
       e.e_fname AS employee_name,
       m.e_fname AS manager_name
FROM employee e
LEFT JOIN employee m
    ON e.manager_id = m.e_code;


-- PRACTICAL 9: SET OPERATIONS
-- Both queries must have the same number of columns and compatible datatypes.
-- Syntax: SELECT columns FROM t1 UNION | UNION ALL | INTERSECT | MINUS
--         SELECT columns FROM t2;

-- Create a table containing employees with the Tester role
CREATE TABLE tester AS
SELECT *
FROM employee
WHERE job = 'Tester';

-- UNION: combines records and removes duplicates
SELECT e_fname, job
FROM employee
UNION
SELECT e_fname, job
FROM tester;

-- UNION ALL: retains duplicate records
SELECT e_fname, job
FROM employee
UNION ALL
SELECT e_fname, job
FROM tester;

-- INTERSECT: returns common records
SELECT e_fname, job
FROM employee
INTERSECT
SELECT e_fname, job
FROM tester;

-- MINUS: returns records present in the first query
-- but absent from the second query
SELECT e_fname, job
FROM employee
MINUS
SELECT e_fname, job
FROM tester;


-- PRACTICAL 10: CREATING VIEWS
-- A view is a stored query that works like a virtual table.
-- Syntax:
--   CREATE OR REPLACE VIEW view_name AS
--   SELECT columns
--   FROM table_name
--   WHERE condition;

-- A view for basic employee information
CREATE OR REPLACE VIEW v_employee AS
SELECT e_code,
       e_fname,
       e_lname,
       job,
       salary,
       d_no
FROM employee;

SELECT *
FROM v_employee;

-- View containing only Tester employees
CREATE OR REPLACE VIEW v_testers AS
SELECT e_code,
       e_fname,
       salary
FROM employee
WHERE job = 'Tester';

SELECT *
FROM v_testers;

-- Department-wise employee information (view based on a join)
CREATE OR REPLACE VIEW v_department_employees AS
SELECT d.d_name,
       e.e_fname,
       e.job,
       e.salary
FROM department d
JOIN employee e
    ON d.d_no = e.d_no;

SELECT *
FROM v_department_employees;


-- PRACTICAL 11: VIEW WITH CHECK OPTION
-- WITH CHECK OPTION stops any INSERT or UPDATE through the view that would
-- make the row disappear from the view.
-- Syntax: CREATE VIEW view_name AS SELECT ... WHERE condition WITH CHECK OPTION;

-- This view allows only records with salary >= 30000
CREATE OR REPLACE VIEW v_high_salary AS
SELECT e_code,
       e_fname,
       salary
FROM employee
WHERE salary >= 30000
WITH CHECK OPTION;

SELECT *
FROM v_high_salary;

-- Valid update: the new salary still satisfies the view condition.
-- (Employee 5003 earns 42000, so the row is visible through the view.)
UPDATE v_high_salary
SET salary = 32000
WHERE e_code = 5003;

-- Invalid update: would violate the view condition (ORA-01402).
-- UPDATE v_high_salary
-- SET salary = 20000
-- WHERE e_code = 5003;


-- PRACTICAL 12: SELECTING AND DROPPING VIEWS
-- A view is queried exactly like a table.
-- Syntax: DROP VIEW view_name;

SELECT e_code,
       e_fname,
       salary
FROM v_employee
WHERE salary > 40000;

-- Drop a view when no longer required
-- DROP VIEW v_testers;


-- PRACTICE QUESTIONS (write and run the queries yourself)
--
-- Q1. Display employee names and department names for employees who work
--     in Mumbai (INNER JOIN with WHERE).
--
-- Q2. Display each department name with its number of employees, including
--     departments with no employees (LEFT JOIN with GROUP BY).
--
-- Q3. Display each manager's name with the number of employees reporting
--     to that manager (self join with GROUP BY).
--
-- Q4. Create a table developer from employee where job = 'Developer', then
--     display all employees who are not developers using MINUS.
--
-- Q5. Create a view of employees in department D105 using WITH CHECK
--     OPTION. Try changing an employee's d_no to D101 through the view
--     and explain the error.
--
-- Q6. Create a view with employee name and department name (use a join)
--     for employees earning above 40000, select from it, then drop it.


