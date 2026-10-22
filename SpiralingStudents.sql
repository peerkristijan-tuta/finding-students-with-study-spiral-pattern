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
