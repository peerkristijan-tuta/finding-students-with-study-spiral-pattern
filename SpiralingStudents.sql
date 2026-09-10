.headers on
.mode column

CREATE TABLE students (
    student_id   INTEGER PRIMARY KEY,
    student_name VARCHAR,
    major        VARCHAR
);

CREATE TABLE study_sessions (
    session_id    INTEGER PRIMARY KEY,
    student_id    INTEGER,
    subject       VARCHAR,
    session_date  DATE,
    hours_studied DECIMAL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students VALUES
(1, 'Alice Chen',   'Computer Science'),
(2, 'Bob Johnson',  'Mathematics'),
(3, 'Carol Davis',  'Physics'),
(4, 'David Wilson', 'Chemistry'),
(5, 'Emma Brown',   'Biology');

INSERT INTO study_sessions VALUES
(1,  1, 'Math',       '2023-10-01', 2.5),
(2,  1, 'Physics',    '2023-10-02', 3.0),
(3,  1, 'Chemistry',  '2023-10-03', 2.0),
(4,  1, 'Math',       '2023-10-04', 2.5),
(5,  1, 'Physics',    '2023-10-05', 3.0),
(6,  1, 'Chemistry',  '2023-10-06', 2.0),
(7,  2, 'Algebra',    '2023-10-01', 4.0),
(8,  2, 'Calculus',   '2023-10-02', 3.5),
(9,  2, 'Statistics', '2023-10-03', 2.5),
(10, 2, 'Geometry',   '2023-10-04', 3.0),
(11, 2, 'Algebra',    '2023-10-05', 4.0),
(12, 2, 'Calculus',   '2023-10-06', 3.5),
(13, 2, 'Statistics', '2023-10-07', 2.5),
(14, 2, 'Geometry',   '2023-10-08', 3.0),
(15, 3, 'Biology',    '2023-10-01', 2.0),
(16, 3, 'Chemistry',  '2023-10-02', 2.5),
(17, 3, 'Biology',    '2023-10-03', 2.0),
(18, 3, 'Chemistry',  '2023-10-04', 2.5),
(19, 4, 'Organic',    '2023-10-01', 3.0),
(20, 4, 'Physical',   '2023-10-05', 2.5);

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
HAVING COUNT(DISTINCT session.subject) > 2 AND COUNT(*) > 5
) cycle ON cycle.student_id = student.student_id
GROUP BY student.student_id, student.student_name, student.major, cycle.cycle_length
ORDER BY cycle.cycle_length DESC, total_study_hours DESC