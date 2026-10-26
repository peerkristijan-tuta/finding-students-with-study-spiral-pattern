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

INSERT INTO study_sessions (session_id, student_id, subject, session_date, hours_studied) VALUES
    (101, 1, 'CS Fundamentals', '2023-10-01', 3.5),
    (102, 1, 'Algorithms', '2023-10-03', 4.0),
    (103, 1, 'Data Structures', '2023-10-07', 2.5),
    (104, 1, 'CS Fundamentals', '2023-10-10', 3.0),
    (105, 1, 'Machine Learning', '2023-10-15', 5.0),

    (201, 2, 'Calculus I', '2023-10-02', 4.0),
    (202, 2, 'Linear Algebra', '2023-10-04', 3.0),
    (203, 2, 'Differential Equations', '2023-10-08', 5.5),
    (204, 2, 'Calculus I', '2023-10-12', 2.0),
    (205, 2, 'Probability', '2023-10-16', 4.5),

    (301, 3, 'Botany', '2023-10-01', 2.0),
    (302, 3, 'Zoology', '2023-10-03', 3.0),
    (303, 3, 'Ecology', '2023-10-07', 4.5),
    (304, 3, 'Botany', '2023-10-10', 2.5),
    (305, 3, 'Zoology', '2023-10-15', 3.5),

    (401, 4, 'Classical Mechanics', '2023-10-01', 5.0),
    (402, 4, 'Quantum Physics', '2023-10-03', 6.0),
    (403, 4, 'Electromagnetism', '2023-10-07', 4.0),
    (404, 4, 'Classical Mechanics', '2023-10-10', 5.5),
    (405, 4, 'Quantum Physics', '2023-10-16', 7.0);

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
    AND JULIANDAY(othersession.session_date) - JULIANDAY(session.session_date) < 30
    GROUP BY session.student_id
    HAVING COUNT(DISTINCT session.subject) > 1 AND COUNT(*) > 2
) cycle ON cycle.student_id = student.student_id
GROUP BY student.student_id, student.student_name, student.major, cycle.cycle_length
ORDER BY cycle.cycle_length DESC, total_study_hours DESC;