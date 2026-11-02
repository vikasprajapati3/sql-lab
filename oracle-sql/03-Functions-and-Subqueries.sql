-- FILE 03: FUNCTIONS AND SUBQUERIES
-- DATABASE: STUDENT MANAGEMENT SYSTEM
-- Requires tables: students, courses, enrollments, employee, movies, director.


-- PRACTICAL 1: AGGREGATE FUNCTIONS
-- Aggregate functions return one value from many rows.
-- Syntax: SELECT COUNT(*) | MAX(col) | MIN(col) | AVG(col) | SUM(col) FROM table;

-- Total number of students
SELECT COUNT(*) AS total_students
FROM students;

-- Total number of courses
SELECT COUNT(*) AS total_courses
FROM courses;

-- Highest marks obtained
SELECT MAX(marks) AS highest_marks
FROM enrollments;

-- Lowest marks obtained
SELECT MIN(marks) AS lowest_marks
FROM enrollments;

-- Average marks of all students
SELECT ROUND(AVG(marks), 2) AS average_marks
FROM enrollments;

-- Total marks recorded
SELECT SUM(marks) AS total_marks
FROM enrollments;

-- Count students with unique department IDs
SELECT COUNT(DISTINCT dept_id) AS total_departments
FROM students;


-- PRACTICAL 2: GROUP BY CLAUSE
-- Groups rows with the same value so aggregates work per group.
-- Syntax: SELECT column, AGGREGATE(column) FROM table GROUP BY column;

-- Number of students in each department
SELECT dept_id, COUNT(*) AS total_students
FROM students
GROUP BY dept_id;

-- Average marks for each course
SELECT course_id, ROUND(AVG(marks), 2) AS average_marks
FROM enrollments
GROUP BY course_id;

-- Highest marks in each course
SELECT course_id, MAX(marks) AS highest_marks
FROM enrollments
GROUP BY course_id;

-- Lowest marks in each course
SELECT course_id, MIN(marks) AS lowest_marks
FROM enrollments
GROUP BY course_id;

-- Total marks recorded for each course
SELECT course_id, SUM(marks) AS total_marks
FROM enrollments
GROUP BY course_id;

-- Number of students registered for each course
SELECT course_id, COUNT(student_id) AS enrolled_students
FROM enrollments
GROUP BY course_id;


-- PRACTICAL 3: HAVING CLAUSE
-- HAVING filters groups after GROUP BY (WHERE filters rows before it).
-- Syntax: SELECT col, AGGREGATE(col) FROM table GROUP BY col HAVING condition;

-- Departments having more than two students
SELECT dept_id, COUNT(*) AS total_students
FROM students
GROUP BY dept_id
HAVING COUNT(*) > 2;

-- Courses having average marks above 80
SELECT course_id, ROUND(AVG(marks), 2) AS average_marks
FROM enrollments
GROUP BY course_id
HAVING AVG(marks) > 80;

-- Courses with more than one enrolment
SELECT course_id, COUNT(*) AS total_enrolments
FROM enrollments
GROUP BY course_id
HAVING COUNT(*) > 1;


-- PRACTICAL 4: GROUP BY WITH ORDER BY
-- ORDER BY comes last and can use a column alias.

-- Course-wise average marks, best performance first
SELECT course_id, ROUND(AVG(marks), 2) AS average_marks
FROM enrollments
GROUP BY course_id
ORDER BY average_marks DESC;

-- Departments according to student count
SELECT dept_id, COUNT(*) AS total_students
FROM students
GROUP BY dept_id
ORDER BY total_students DESC;


-- PRACTICAL 5: MATHEMATICAL FUNCTIONS
-- dual is a dummy table used to run functions on fixed values.
-- Syntax: SELECT function_name(arguments) FROM dual;

-- ABS: Absolute value
SELECT ABS(-567) AS result FROM dual;

-- SQRT: Square root
SELECT SQRT(144) AS result FROM dual;

-- ROUND: Round a number
SELECT ROUND(675.345, 2) AS result
FROM dual;

-- TRUNC: Remove decimal places without rounding
SELECT TRUNC(675.345, 2) AS result
FROM dual;

-- SIGN: Identify negative (-1), positive (1) or zero (0)
SELECT SIGN(-25) AS negative_number,
       SIGN(25)  AS positive_number,
       SIGN(0)   AS zero_number
FROM dual;

-- POWER: Calculate exponent
SELECT POWER(5, 3) AS result
FROM dual;

-- MOD: Calculate remainder
SELECT MOD(17, 5) AS remainder
FROM dual;

-- FLOOR: Largest integer less than or equal to value
SELECT FLOOR(87.98) AS result FROM dual;

-- CEIL: Smallest integer greater than or equal to value
SELECT CEIL(68.18) AS result FROM dual;


-- PRACTICAL 6: COMBINING MATHEMATICAL FUNCTIONS
-- Functions can be used together and nested; the innermost runs first.

-- Different functions in one query
SELECT ABS(-36)    AS absolute_value,
       SQRT(36)    AS square_root,
       POWER(3, 3) AS power_value,
       MOD(20, 3)  AS remainder
FROM dual;

-- Nested functions: ABS, then SQRT, then ROUND, then CEIL
SELECT CEIL(ROUND(SQRT(ABS(-36)), 2)) AS result
FROM dual;

-- Math function applied to an aggregate
SELECT ROUND(AVG(marks), 1) AS average_marks
FROM enrollments;


-- PRACTICAL 7: DATE FUNCTION
-- Syntax: MONTHS_BETWEEN(later_date, earlier_date)

-- Approximate working duration in years (employee database)
SELECT e_fname,
       ROUND(MONTHS_BETWEEN(SYSDATE, hire_date) / 12, 1) AS years_of_service
FROM employee;

-- Months between two fixed dates
SELECT MONTHS_BETWEEN(DATE '2025-12-01', DATE '2025-01-01') AS months_difference
FROM dual;


-- PRACTICAL 8: NESTED SUBQUERIES
-- A subquery is a query inside another query; the inner query runs first.
-- Syntax:
--   SELECT columns FROM table_name
--   WHERE column operator (SELECT column FROM table_name WHERE condition);

-- Students who scored above the average marks
SELECT student_id, course_id, marks
FROM enrollments
WHERE marks > (SELECT AVG(marks) FROM enrollments);

-- Student with the highest marks
SELECT student_id, course_id, marks
FROM enrollments
WHERE marks = (SELECT MAX(marks) FROM enrollments);

-- Student with the lowest marks
SELECT student_id, course_id, marks
FROM enrollments
WHERE marks = (SELECT MIN(marks) FROM enrollments);

-- Courses having marks greater than the average marks of all courses
SELECT course_id, marks
FROM enrollments
WHERE marks > (SELECT AVG(marks) FROM enrollments);

-- Students enrolled in the DBMS course
SELECT student_id, first_name
FROM students
WHERE student_id IN (SELECT student_id FROM enrollments WHERE course_id = 201);

-- Students who have not registered for any course
-- (IS NOT NULL is needed: NOT IN returns no rows if the list has a NULL)
SELECT student_id, first_name
FROM students
WHERE student_id NOT IN (
    SELECT student_id
    FROM enrollments
    WHERE student_id IS NOT NULL
);


-- PRACTICAL 9: SECOND HIGHEST VALUE

-- Second-highest marks using a subquery
SELECT MAX(marks) AS second_highest_marks
FROM enrollments
WHERE marks < (SELECT MAX(marks) FROM enrollments);

-- Second-highest distinct marks using DENSE_RANK
-- Syntax: DENSE_RANK() OVER (ORDER BY column DESC)
SELECT student_id,
       course_id,
       marks
FROM (
    SELECT student_id,
           course_id,
           marks,
           DENSE_RANK() OVER (ORDER BY marks DESC) AS ranking
    FROM enrollments
)
WHERE ranking = 2;


-- PRACTICAL 10: EMPLOYEE SUBQUERIES

-- Employees earning more than the average salary
SELECT e_code, e_fname, job, salary
FROM employee
WHERE salary > (SELECT AVG(salary) FROM employee);

-- Highest-paid employee
SELECT e_code, e_fname, salary
FROM employee
WHERE salary = (SELECT MAX(salary) FROM employee);

-- Second-highest distinct salary
SELECT MAX(salary) AS second_highest_salary
FROM employee
WHERE salary < (SELECT MAX(salary) FROM employee);

-- Employees earning more than their department's average salary
-- (correlated subquery: the inner query uses e.d_no from the outer query)
SELECT e.e_code,
       e.e_fname,
       e.salary,
       e.d_no
FROM employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employee e2
    WHERE e2.d_no = e.d_no
);


-- PRACTICAL 11: MOVIE DATABASE SUBQUERIES

-- Movies directed by directors with rating above 8
SELECT *
FROM movies
WHERE di_id IN (SELECT d_id FROM director WHERE d_rating > 8);

-- Movie with the highest budget
SELECT movie_name, budget
FROM movies
WHERE budget = (SELECT MAX(budget) FROM movies);

-- Movie with the lowest budget
SELECT movie_name, budget
FROM movies
WHERE budget = (SELECT MIN(budget) FROM movies);

-- Second-highest budgeted movie (a subquery inside a subquery)
SELECT movie_name, budget
FROM movies
WHERE budget = (
    SELECT MAX(budget)
    FROM movies
    WHERE budget < (
        SELECT MAX(budget)
        FROM movies
    )
);

-- Movies with budgets above the average budget
SELECT movie_name, budget
FROM movies
WHERE budget > (SELECT AVG(budget) FROM movies);

-- Movie and director names for the highest-budgeted movie
SELECT m.movie_name,
       m.budget,
       d.d_name
FROM movies m
JOIN director d
    ON m.di_id = d.d_id
WHERE m.budget = (SELECT MAX(budget) FROM movies);

-- Movies of the director who has directed the maximum number of movies
SELECT m.movie_name, d.d_name
FROM movies m
JOIN director d
    ON m.di_id = d.d_id
WHERE d.no_movie_dir = (SELECT MAX(no_movie_dir) FROM director);


-- PRACTICE QUESTIONS (write and run the queries yourself)
--
-- Q1. Show departments with at least two students, highest count first.
--
-- Q2. Show each course's highest and lowest marks together, and keep
--     only the courses where the highest mark is above 85.
--
-- Q3. Using dual, show FLOOR, CEIL, ROUND and TRUNC (1 decimal place)
--     of -45.678 in a single query.
--
-- Q4. Find students whose marks are below the average marks, showing
--     student_id and course_id.
--
-- Q5. Find the third-highest distinct salary using DENSE_RANK, then
--     solve the same using nested subqueries.
--
-- Q6. Find movies whose budget is above the average budget and whose
--     director's rating is above 8.


-- END OF FILE 03