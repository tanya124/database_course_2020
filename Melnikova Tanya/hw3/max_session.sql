-- Вывести логины трёх пользователей с наибольшим количеством сессий
SELECT USER_ID, COUNT(USER_ID) AS COUNT_SESSION
FROM SESSIONS
GROUP BY USER_ID
ORDER BY COUNT_SESSION DESC
LIMIT 3;
-- Результат
/*
 USER_ID COUNT_SESSIONS
57	147
9	134
83	133
 */