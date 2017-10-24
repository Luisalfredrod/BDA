-- The most visited destiny in the year.
SELECT city_name, SUM(tickets_sold) as TotalTickets
FROM D_DESTINY, DESTINY_TICKETS
WHERE D_DESTINY.id_destiny = DESTINY_TICKETS.id_destiny
GROUP BY city_name
ORDER BY SUM(tickets_sold) DESC;

-- How much money was gained per destiny.
SELECT city_name, SUM(income) as TotalIncome
FROM D_DESTINY, DESTINY_TICKETS
WHERE D_DESTINY.id_destiny = DESTINY_TICKETS.id_destiny
GROUP BY city_name
ORDER BY SUM(income) DESC;

-- How much tickets were sold for a destiny in X day?
SELECT city_name, SUM(tickets_sold) as Tickets
FROM DESTINY_TICKETS, D_DESTINY, D_TIME
WHERE D_DESTINY.code_city = 1
    AND DESTINY_TICKETS.id_destiny = D_DESTINY.id_destiny
    AND DESTINY_TICKETS.id_time = D_TIME.id_time
    AND DESTINY_TICKETS.id_time IN (SELECT id_time FROM D_TIME WHERE DATE_DAY = 14 AND DATE_MONTH LIKE 'APRIL%' AND DATE_YEAR = '2016')
    GROUP BY city_name;

-- How much tickets were sold for a destiny in X month?
SELECT city_name, SUM(tickets_sold) as Tickets
FROM DESTINY_TICKETS, D_DESTINY, D_TIME
WHERE D_DESTINY.code_city = 1
    AND DESTINY_TICKETS.id_destiny = D_DESTINY.id_destiny
    AND DESTINY_TICKETS.id_time = D_TIME.id_time
    AND DESTINY_TICKETS.id_time IN (SELECT id_time FROM D_TIME WHERE DATE_MONTH LIKE 'MAYO%' AND DATE_YEAR = '2016')
    GROUP BY city_name;

-- How much tickets were sold for a destiny in X year?
SELECT city_name, SUM(tickets_sold) as Tickets
FROM DESTINY_TICKETS, D_DESTINY, D_TIME
WHERE D_DESTINY.code_city = 1
    AND DESTINY_TICKETS.id_destiny = D_DESTINY.id_destiny
    AND DESTINY_TICKETS.id_time = D_TIME.id_time
    AND DESTINY_TICKETS.id_time IN (SELECT id_time FROM D_TIME WHERE DATE_YEAR = '2016')
    GROUP BY city_name;

-- Which contient sold more tickets?
SELECT continent_name, SUM(tickets_sold)
FROM D_DESTINY, DESTINY_TICKETS
WHERE D_DESTINY.id_destiny = DESTINY_TICKETS.id_destiny
GROUP BY continent_name
ORDER BY SUM(tickets_sold) DESC;

-- How much money was raised by continent?
SELECT continent_name, SUM(income)
FROM D_DESTINY, DESTINY_TICKETS
WHERE D_DESTINY.id_destiny = DESTINY_TICKETS.id_destiny
GROUP BY continent_name
ORDER BY SUM(income) DESC;

-- Which was the least destiny visited?
SELECT city_name, SUM(tickets_sold) as TotalTickets
FROM D_DESTINY, DESTINY_TICKETS
WHERE D_DESTINY.id_destiny = DESTINY_TICKETS.id_destiny
GROUP BY city_name
ORDER BY SUM(tickets_sold);

