-- Вправа 3.1. Створення подання, яке виводить усі елементи довідника в порядку кодів.

CREATE VIEW "SortByDate" AS
SELECT "LastName", "FirstName", "MiddleName", "BirthDate"
FROM "Citizen"
ORDER BY "BirthDate";

-- Вправа 3.2. Створення запиту на вибірку з логічними операціями в умовах відбору записів.
--     1. Видати всі елементи довідника в порядку кодів.
--     2. Видати елементи іншої множини сутностей, застосувавши фільтр по кількості в запиті.

SELECT "Serie", "Number", "Given By", "Given When"
FROM "PassportData"
ORDER BY "Given When";

SELECT "LastName", "FirstName", "MiddleName", "BirthDate"
FROM "Citizen"
WHERE age("BirthDate") > INTERVAL '21 years'
ORDER BY "BirthDate";

-- Вправа 3.3. Підзапити.
--     У базі індивідуальної предметної області, користуючись підзапитами,
--     в т.ч.конструкціями EXISTS та IN, реалізувати у SQL три запити до
--     двох і більше таблиць.

SELECT *
FROM "Street"
WHERE "TownId" = (SELECT "id"
                  FROM "Town"
                  WHERE "Town"."Name" = 'Київ'
                  LIMIT 1);

SELECT *
FROM "Town"
WHERE EXISTS(SELECT "DistrictId"
             FROM "District"
             WHERE "District"."Name" IS NULL
               AND "District"."id" = "Town"."DistrictId");

SELECT *
FROM "Town"
WHERE "DistrictId" IN
      (SELECT "id"
       FROM "District"
       WHERE "District"."Name" = 'Конотопський'
          OR "District"."Name" = 'Ізмаїльський');

-- Вправа 3.4. З’єднання.
--     Для індивідуальної предметної області, користуючись конструкціями JOIN та іншими з’єднаннями, реалізувати у
--     SQL наступні запити:
--         - Запит з внутрішнім з’єднанням таблиць;
--         - Запит з лівим з’єднанням таблиць;
--         - Запит з правим з’єднанням таблиць.

SELECT *
FROM "Citizen"
         JOIN "PhoneNumber" ON "Citizen".id = "PhoneNumber"."CitizenId"; -- запит, який виводить усі дані громадян, які надали мобільний телефон

SELECT *
FROM "Citizen"
         LEFT JOIN "PhoneNumber" ON "Citizen".id = "PhoneNumber"."CitizenId"; -- запит, який виводить дані громадянина з його телефоном, якщо такий є

SELECT *
FROM "Citizen"
         RIGHT JOIN "Address" ON "Address".id = "Citizen"."AddressId"; -- запит, який виводить дані громадянина з його адресою, якзо така є

-- Вправа 3.5. Об’єднання таблиць.
--     Для індивідуальної предметної області, користуючись конструкцією UNION, реалізувати у SQL запит на об’єднання таблиць.

SELECT "LastName", "FirstName", "MiddleName", "BirthDate"
FROM "Citizen"
WHERE age("BirthDate") > INTERVAL '21 years'
UNION ALL
SELECT "LastName", "FirstName", "MiddleName", "BirthDate"
FROM "Citizen"
WHERE age("BirthDate") <= INTERVAL '21 years';

-- Вправа 3.6. (додатково)
--     Для індивідуальної предметної області, користуючись необхідними конструкціями, інформацію про які знайти самостійно, реалізувати наступні запити:
--         - з перетворенням типу даних результату і запиту (наприклад, дату в рядок, рядок в число, тощо)
--         - з пошуком фрагменту текстового поля (наприклад, знайти всі прізвища, що закінчуються на «ко»)
--         - з вибіркою та обробкою порожніх значень (NULL), заміною їх на інші з використанням функції умови в SQL-виразі для поля запиту, зміст базових таблиць не змінюється.

SELECT CAST(MIN("BirthDate") AS VARCHAR(50))
FROM "Citizen";

SELECT *
FROM "Citizen"
WHERE "LastName" LIKE '%ров%';

SELECT "Serie",
       CASE
           WHEN "Serie" IS NULL THEN '-'
           ELSE "Serie" END
FROM "PassportData";