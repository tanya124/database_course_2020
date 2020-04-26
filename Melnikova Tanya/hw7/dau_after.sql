CREATE INDEX dttm_index ON SESSIONS (BEGIN_DTTM) USING BTREE;
EXPLAIN
WITH RECURSIVE CTE (DT) AS
                   (
                       SELECT MIN(CAST(BEGIN_DTTM AS DATE)) AS DT
                       FROM SESSIONS
                       UNION ALL
                       SELECT DT + INTERVAL 1 DAY
                       FROM CTE
                       WHERE DT + INTERVAL 1 DAY <= (SELECT MAX(CAST(BEGIN_DTTM AS DATE)) FROM (SELECT BEGIN_DTTM FROM SESSIONS) AS SESSIONS_DTTM_)
                   )
SELECT CTE.DT, COUNT(DISTINCT USER_ID)
FROM CTE
         LEFT JOIN (SELECT BEGIN_DTTM, USER_ID FROM SESSIONS) AS SESSIONS_DTTM_USER
                   ON CTE.DT = CAST(SESSIONS_DTTM_USER.BEGIN_DTTM AS DATE)
GROUP BY CTE.DT
ORDER BY CTE.DT;

/*
EXPLAIN OUTPUT:
| id | select\_type | table | partitions | type | possible\_keys | key | key\_len | ref | rows | filtered | Extra |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | PRIMARY | &lt;derived2&gt; | NULL | ALL | NULL | NULL | NULL | NULL | 3 | 100 | Using filesort |
| 1 | PRIMARY | SESSIONS | NULL | ALL | NULL | NULL | NULL | NULL | 3591 | 100 | Using where |
| 2 | DERIVED | SESSIONS | NULL | index | NULL | dttm\_index | 5 | NULL | 3591 | 100 | Using index |
| 3 | UNION | CTE | NULL | ALL | NULL | NULL | NULL | NULL | 2 | 100 | Recursive; Using where |
| 5 | SUBQUERY | SESSIONS | NULL | index | NULL | dttm\_index | 5 | NULL | 3591 | 100 | Using index |

1) внешний запрос в JOIN'e, (CTE), метод доступа - ALL, количество прочитаных строк 3, подходит 100% строк. использованна файловая сортировка
1) внешний запрос в JOIN'e, (SESSION), метод доступа - ALL, количество прочитаных строк 3591, подходит 100% строк. сервер фильтрует строки после
фильтрации строк подсистемой хранения
2) подзапрос во FROM, метод доступа - index, количество прочитаных строк 3591, подходит 100% строк. использованны покрывающие индексы
3) UNION запрос в CTE, метод доступа - ALL, количество прочитаных строк 2, подходит 100% строк. использованна рекурсия и сервер фильтрует строки после
фильтрации строк подсистемой хранения
5) подзапрос в SELECT (в with), метод доступа - index, количество прочитаных строк 3591, подходит 100% строк. использованны покрывающие индексы

*/