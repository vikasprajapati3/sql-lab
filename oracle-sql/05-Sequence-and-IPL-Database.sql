-- FILE 05: SEQUENCES AND IPL DATABASE
-- DATABASE: ORACLE SQL
-- Uses tables created in file 01: employee, project and project_assignment.
-- Only the IPL tables (teams, players) are created here.


-- PRACTICAL 13: CREATING SEQUENCES
-- A sequence generates unique numbers automatically.
-- Syntax:
--   CREATE SEQUENCE sequence_name
--   START WITH n
--   INCREMENT BY n
--   MAXVALUE n
--   NOCYCLE
--   NOCACHE;

-- Sequence for generating employee IDs
CREATE SEQUENCE sq_employee
START WITH 6001
INCREMENT BY 1
MINVALUE 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

-- Sequence for generating project IDs
CREATE SEQUENCE sq_project
START WITH 100
INCREMENT BY 1
MAXVALUE 9999
NOCYCLE
NOCACHE;


-- PRACTICAL 14: USING NEXTVAL AND CURRVAL
-- NEXTVAL generates the next number; CURRVAL shows the last one generated.

-- Generate the next employee ID
SELECT sq_employee.NEXTVAL
FROM dual;

-- Get the current sequence value
-- (NEXTVAL must be called first in the session)
SELECT sq_employee.CURRVAL
FROM dual;

-- Insert a new project using the sequence (project table is from file 01)
INSERT INTO project
VALUES (sq_project.NEXTVAL, 'Inventory Management');

SELECT *
FROM project;


-- PRACTICAL 15: ALTER AND DROP SEQUENCE
-- START WITH cannot be changed with ALTER SEQUENCE.
-- Syntax: ALTER SEQUENCE sequence_name INCREMENT BY n;

ALTER SEQUENCE sq_project
INCREMENT BY 5;

-- Drop a sequence when no longer needed
-- DROP SEQUENCE sq_project;


-- PRACTICAL 16: IPL DATABASE

CREATE TABLE teams (
    t_id     NUMBER(5) PRIMARY KEY,
    t_name   VARCHAR2(40) NOT NULL,
    captain  VARCHAR2(40),
    t_owner  VARCHAR2(60)
);

CREATE TABLE players (
    p_id    NUMBER(5) PRIMARY KEY,
    p_name  VARCHAR2(40) NOT NULL,
    role    VARCHAR2(20),
    teamno  NUMBER(5),
    CONSTRAINT fk_player_team
        FOREIGN KEY (teamno)
        REFERENCES teams (t_id),
    CONSTRAINT chk_player_role
        CHECK (role IN ('Batter', 'Bowler', 'WK', 'All-Rounder'))
);

-- Create IPL sequences
CREATE SEQUENCE sq_team
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE sq_player
START WITH 5000
INCREMENT BY 1
NOCYCLE;

-- Insert IPL teams
INSERT INTO teams
VALUES (sq_team.NEXTVAL, 'Mumbai Indians',
        'Hardik Pandya', 'Reliance Industries');
INSERT INTO teams
VALUES (sq_team.NEXTVAL, 'Delhi Capitals',
        'Rishabh Pant', 'GMR Group and JSW Group');
INSERT INTO teams
VALUES (sq_team.NEXTVAL, 'Sunrisers Hyderabad',
        'Pat Cummins', 'Sun TV Networks');

-- Insert players. INSERT ALL cannot use NEXTVAL, so one
-- INSERT ... SELECT adds all players and takes ids from sq_player.
INSERT INTO players
SELECT sq_player.NEXTVAL, p_name, role, teamno
FROM (
    -- Mumbai Indians players
    SELECT 'Rohit Sharma' AS p_name, 'Batter' AS role, 1 AS teamno FROM dual
    UNION ALL SELECT 'Suryakumar Yadav', 'Batter', 1 FROM dual
    UNION ALL SELECT 'Ishan Kishan', 'WK', 1 FROM dual
    UNION ALL SELECT 'Hardik Pandya', 'All-Rounder', 1 FROM dual
    UNION ALL SELECT 'Jasprit Bumrah', 'Bowler', 1 FROM dual
    -- Delhi Capitals players
    UNION ALL SELECT 'Rishabh Pant', 'WK', 2 FROM dual
    UNION ALL SELECT 'Prithvi Shaw', 'Batter', 2 FROM dual
    UNION ALL SELECT 'Axar Patel', 'All-Rounder', 2 FROM dual
    UNION ALL SELECT 'Kuldeep Yadav', 'Bowler', 2 FROM dual
    -- Sunrisers Hyderabad players
    UNION ALL SELECT 'Pat Cummins', 'Bowler', 3 FROM dual
    UNION ALL SELECT 'Travis Head', 'Batter', 3 FROM dual
    UNION ALL SELECT 'Abhishek Sharma', 'All-Rounder', 3 FROM dual
    UNION ALL SELECT 'Heinrich Klaasen', 'WK', 3 FROM dual
);

COMMIT;


-- PRACTICAL 17: IPL DATABASE QUERIES

-- Display all teams
SELECT *
FROM teams;

-- Display all players
SELECT *
FROM players;

-- Display players with their team names
SELECT p.p_name,
       p.role,
       t.t_name,
       t.captain
FROM players p
JOIN teams t
    ON p.teamno = t.t_id;

-- Count players in each team
SELECT t.t_name,
       COUNT(p.p_id) AS total_players
FROM teams t
LEFT JOIN players p
    ON t.t_id = p.teamno
GROUP BY t.t_name;

-- Find all bowlers
SELECT p_name,
       role,
       teamno
FROM players
WHERE role = 'Bowler';

-- Find teams having more than four players
SELECT t.t_name,
       COUNT(p.p_id) AS total_players
FROM teams t
JOIN players p
    ON t.t_id = p.teamno
GROUP BY t.t_name
HAVING COUNT(p.p_id) > 4;


-- PRACTICE QUESTIONS (write and run the queries yourself)
--
-- Q1. Create a sequence sq_assignment starting at 200. Insert two rows
--     into project_assignment using NEXTVAL, then display CURRVAL.
--
-- Q2. Alter sq_employee to increment by 10, generate two values with
--     NEXTVAL, and then drop the sequence.
--
-- Q3. Display each team's name with the number of All-Rounders it has
--     (JOIN with WHERE and GROUP BY).
--
-- Q4. Display the names of all Mumbai Indians players in alphabetical
--     order, along with the team's captain.
--
-- Q5. Display each role with the number of players in it, highest count
--     first (GROUP BY role).
--
-- Q6. Insert a new team using sq_team.NEXTVAL and one player for it using
--     sq_player.NEXTVAL and sq_team.CURRVAL, then display them with a join.


-- END OF FILE 05