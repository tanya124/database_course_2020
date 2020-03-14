-- Посчитать средний платёж платящего пользователя
SELECT AVG(PAYMENT_USER.SUM)
FROM (
    SELECT SUM(PAYMENT_SUM) AS SUM
    FROM PAYMENTS
    GROUP BY USER_ID) AS PAYMENT_USER;
-- Результат
/*
 AVG_SUM
2813.9591836734694
*/
