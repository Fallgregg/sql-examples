-- Вправа 4.1. Створення простого групуючого запиту із використанням статистичної функції Sum.
SELECT "ApartmentNumber", SUM("NumberOfPeople") AS "TotalNumber"
FROM "Address"
GROUP BY "ApartmentNumber"
ORDER BY "TotalNumber";

-- Вправа 4.2. Створення групуючого запиту з використанням речення HAVING.
SELECT "ApartmentNumber", SUM("NumberOfPeople") AS "TotalNumber"
FROM "Address"
GROUP BY "ApartmentNumber"
HAVING SUM("NumberOfPeople") > 5;

-- Вправа 4.3. Створення об'єкту Таблиця на основі запиту
SELECT *
INTO "FemaleCitizens"
FROM "Citizen"
WHERE "Gender" = 'Female';

-- Вправа 4.4. Створення запиту на оновлення
UPDATE "Citizen"
SET "Gender" = 'M'
WHERE "Gender" = 'Male';

-- Вправа 4.5. Створення запиту на видалення
DELETE
FROM "PassportData"
WHERE "Given When" < '1992-01-01';

-- Вправа 4.6. Створення запиту на додавання
INSERT INTO "FemaleCitizens"
SELECT *
FROM "Citizen"
WHERE "FirstName" = 'Олена';
