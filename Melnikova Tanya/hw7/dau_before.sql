EXPLAIN
WITH RECURSIVE CTE (DT) AS
                   (
                       SELECT MIN(CAST(BEGIN_DTTM AS DATE)) AS DT
                       FROM SESSIONS
                       UNION ALL
                       SELECT DT + INTERVAL 1 DAY
                       FROM CTE
                       WHERE DT + INTERVAL 1 DAY <= (SELECT MAX(CAST(BEGIN_DTTM AS DATE)) FROM SESSIONS)
                   )
SELECT CTE.DT, COUNT(DISTINCT USER_ID)
FROM CTE
         LEFT JOIN SESSIONS
                   ON CTE.DT = CAST(SESSIONS.BEGIN_DTTM AS DATE)
GROUP BY CTE.DT
ORDER BY CTE.DT;

/*
output explain:
| id | select\_type | table | partitions | type | possible\_keys | key | key\_len | ref | rows | filtered | Extra |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | PRIMARY | &lt;derived2&gt; | NULL | ALL | NULL | NULL | NULL | NULL | 3 | 100 | Using filesort |
| 1 | PRIMARY | SESSIONS | NULL | ALL | NULL | NULL | NULL | NULL | 3591 | 100 | Using where |
| 2 | DERIVED | SESSIONS | NULL | index | NULL | dttm\_index | 5 | NULL | 3591 | 100 | Using index |
| 3 | UNION | CTE | NULL | ALL | NULL | NULL | NULL | NULL | 2 | 100 | Recursive; Using where |
| 5 | SUBQUERY | SESSIONS | NULL | index | NULL | dttm\_index | 5 | NULL | 3591 | 100 | Using index |

output dau:
2018-08-02,1
2018-08-03,2
2018-08-04,1
2018-08-05,2
2018-08-06,3
2018-08-07,2
2018-08-08,6
2018-08-09,6
2018-08-10,5
2018-08-11,5
2018-08-12,6
2018-08-13,6
2018-08-14,9
2018-08-15,6
2018-08-16,11
2018-08-17,7
2018-08-18,13
2018-08-19,14
2018-08-20,8
2018-08-21,11
2018-08-22,13
2018-08-23,15
2018-08-24,14
2018-08-25,13
2018-08-26,13
2018-08-27,12
2018-08-28,16
2018-08-29,14
2018-08-30,19
2018-08-31,17
2018-09-01,18
2018-09-02,20
2018-09-03,20
2018-09-04,16
2018-09-05,16
2018-09-06,23
2018-09-07,24
2018-09-08,24
2018-09-09,26
2018-09-10,26
2018-09-11,23
2018-09-12,25
2018-09-13,26
2018-09-14,24
2018-09-15,29
2018-09-16,31
2018-09-17,26
2018-09-18,30
2018-09-19,32
2018-09-20,35
2018-09-21,34
2018-09-22,30
2018-09-23,32
2018-09-24,35
2018-09-25,38
2018-09-26,37
2018-09-27,36
2018-09-28,34
2018-09-29,42
2018-09-30,41
*/