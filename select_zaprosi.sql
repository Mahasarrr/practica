-- Вывести список кабинетов с количеством рабочих мест и закрепленным оборудованием
SELECT
    "cabinets".number AS "Номер кабинета",
    COUNT(DISTINCT "rabochie_mesta".id_mesta) AS "Количество рабочих мест",
    STRING_AGG(DISTINCT "tip".naimenovanie, ', ') AS "Закреплённое оборудование в кабинете"
FROM
    "cabinets"
JOIN
    "rabochie_mesta" ON "cabinets".id_cabineta = "rabochie_mesta".id_cabineta
LEFT JOIN
    "oborudovanie" ON "rabochie_mesta".id_mesta = "oborudovanie".id_mesta
LEFT JOIN
    "tip" ON "oborudovanie".id_tipa = "tip".id_tipa
GROUP BY
    "cabinets".number
ORDER BY
    "cabinets".number;

--Найти сотрудников, у которых закреплено больше 3 устройств
SELECT
    "sotrudniki".full_name AS "Сотрудник",
    COUNT("oborudovanie".unical_nomer) AS "Количество закрепленных устройств"
FROM
    "sotrudniki"
JOIN
    "rabochie_mesta" ON "sotrudniki".id_sotrudnika = "rabochie_mesta".id_sotrudnika
JOIN
    "oborudovanie" ON "rabochie_mesta".id_mesta = "oborudovanie".id_mesta
GROUP BY
    "sotrudniki".full_name
HAVING
    COUNT("oborudovanie".unical_nomer) > 3
ORDER BY
    "Количество закрепленных устройств" DESC;

--Вывести оборудование, которое не закреплено ни за одним рабочим местом
SELECT
    "oborudovanie".unical_nomer AS "Уникальный номер",
    "tip".naimenovanie AS "Тип оборудования"
FROM
    "oborudovanie"
JOIN
    "tip" ON "oborudovanie".id_tipa = "tip".id_tipa
WHERE
    "oborudovanie".id_mesta IS NULL;

--Подсчитать общее количество устройств каждого типа
SELECT
    "tip".naimenovanie AS "Тип устройства",
    COUNT("oborudovanie".unical_nomer) AS "Общее количество"
FROM
    "tip"
LEFT JOIN
    "oborudovanie" ON "tip".id_tipa = "oborudovanie".id_tipa
GROUP BY
    "tip".naimenovanie; 

--Найти кабинеты, где есть хотя бы одно устройство с годом выпуска старше 2018
SELECT DISTINCT
    "cabinets".korpus AS "Корпус",
    "cabinets".number AS "Номер кабинета"
FROM
    "cabinets"
JOIN
    "rabochie_mesta" ON "cabinets".id_cabineta = "rabochie_mesta".id_cabineta
JOIN
    "oborudovanie" ON "rabochie_mesta".id_mesta = "oborudovanie".id_mesta
WHERE
    "oborudovanie".god_vipuska > 2018;