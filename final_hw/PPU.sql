WITH RECURSIVE
    CTE(DT) AS (
        SELECT MIN(CAST(BEGIN_DTTM AS DATE)) AS DT
        FROM Melnikova.SESSIONS
        UNION ALL
        SELECT DT + INTERVAL 1 DAY
        FROM CTE
        WHERE DT + INTERVAL 1 DAY <= (SELECT MAX(CAST(BEGIN_DTTM AS DATE)) FROM Melnikova.SESSIONS)
    ),
    DAU AS (
        SELECT CAST(Melnikova.SESSIONS.BEGIN_DTTM AS DATE) AS DT, COUNT(DISTINCT USER_ID) AS COUNT_USER
        FROM Melnikova.SESSIONS
        GROUP BY DT
    ),
    PU AS (
        SELECT CAST(Melnikova.PAYMENTS.PAYMENT_DTTM AS DATE) AS DT, COUNT(DISTINCT USER_ID) AS COUNT_PAY_USER
        FROM Melnikova.PAYMENTS
        GROUP BY DT
    )
SELECT CTE.DT, COALESCE(COUNT_PAY_USER, 0) / COALESCE(COUNT_USER, 1) AS PPU
FROM CTE
         LEFT JOIN DAU ON CTE.DT = DAU.DT
         LEFT JOIN PU ON CTE.DT = PU.DT;
/*
2018-08-02,0.0000
2018-08-03,0.0000
2018-08-04,0.0000
2018-08-05,0.0000
2018-08-06,0.0000
2018-08-07,0.5000
2018-08-08,0.0000
2018-08-09,0.0000
2018-08-10,0.2000
2018-08-11,0.4000
2018-08-12,0.1667
2018-08-13,0.0000
2018-08-14,0.2222
2018-08-15,0.6667
2018-08-16,0.0909
2018-08-17,0.2857
2018-08-18,0.0769
2018-08-19,0.1429
2018-08-20,0.1250
2018-08-21,0.0909
2018-08-22,0.0000
2018-08-23,0.1429
2018-08-24,0.2857
2018-08-25,0.1538
2018-08-26,0.0000
2018-08-27,0.3636
2018-08-28,0.2667
2018-08-29,0.0714
2018-08-30,0.2105
2018-08-31,0.1875
2018-09-01,0.2222
2018-09-02,0.1000
2018-09-03,0.0000
2018-09-04,0.1250
2018-09-05,0.0625
2018-09-06,0.1818
2018-09-07,0.0870
2018-09-08,0.2609
2018-09-09,0.1200
2018-09-10,0.1538
2018-09-11,0.2273
2018-09-12,0.1250
2018-09-13,0.1154
2018-09-14,0.1250
2018-09-15,0.2143
2018-09-16,0.3000
2018-09-17,0.1538
2018-09-18,0.0667
2018-09-19,0.2581
2018-09-20,0.1714
2018-09-21,0.2059
2018-09-22,0.1333
2018-09-23,0.1563
2018-09-24,0.2857
2018-09-25,0.2432
2018-09-26,0.3243
2018-09-27,0.3889
2018-09-28,0.3235
2018-09-29,0.3095
2018-09-30,0.3000

*/