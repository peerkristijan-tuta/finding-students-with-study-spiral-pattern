CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    major VARCHAR(50)
);

CREATE TABLE study_sessions (
    session_id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    subject VARCHAR(50) NOT NULL,
    session_date DATE NOT NULL,
    hours_studied FLOAT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES
    students(student_id)
);

INSERT INTO students (student_id, student_name, major) VALUES
    (1, 'Alice Smith', 'Computer Science'),
    (2, 'Bob Johnson', 'Mathematics'), 
    (3, 'Charlie Brown', 'Biology'),
    (4, 'Diana Prince', 'Physics');

INSERT INTO study_sessions (session_id, student_id, subject, session_date, hours_studied)
WITH RECURSIVE gen(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM gen WHERE n < 20
)
SELECT
    n,
    (ABS(RANDOM()) % 4) + 1,
    CASE (ABS(RANDOM()) % 5)
        WHEN 0 THEN 'Algorithms'
        WHEN 1 THEN 'Calculus I'
        WHEN 2 THEN 'Botany'
        WHEN 3 THEN 'Quantum Physics'
        ELSE 'Data Structures'
    END,
    DATE('2023-10-01', '+' || (ABS(RANDOM()) % 3) || ' days'),
    ROUND((ABS(RANDOM()) % 60 + 10) / 10.0, 1)
FROM gen;

SELECT
    student.student_id,
    student.student_name,
    student.major,
    cycle.cycle_length,
    ROUND(CAST(SUM(altsession.hours_studied) AS FLOAT), 2) AS total_study_hours
FROM students student
JOIN study_sessions altsession ON altsession.student_id = student.student_id
JOIN (
    SELECT
        session.student_id,
        COUNT(DISTINCT session.subject) as cycle_length
    FROM study_sessions session
    JOIN study_sessions othersession ON othersession.student_id = session.student_id 
    AND othersession.session_date > session.session_date 
    AND JULIANDAY(othersession.session_date) - JULIANDAY(session.session_date) < 3
    GROUP BY session.student_id
    HAVING COUNT(
        DISTINCT session.subject) > 2 AND COUNT(*) > 5
) cycle ON cycle.student_id = student.student_id
GROUP BY student.student_id, student.student_name, student.major, cycle.cycle_length
ORDER BY cycle.cycle_length DESC, total_study_hours DESC
