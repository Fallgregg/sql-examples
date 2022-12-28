-- Вправа 6.1. Налаштування унікальності поля
-- 1. Реалізувати вимогу унікальності коду в довіднику при наявності іншого первинного ключа (як-от Id).
-- 2. Перевірити контроль унікальності цього поля, намагаючись присвоїти йому неунікальне значення запитом на оновлення з консолі.

INSERT INTO "Citizen" ("LastName", "FirstName", "MiddleName", "Gender", "BirthDate", "IdentificationNumber",
                       "AddressId")
VALUES ('Івченко',
        'Анна',
        'Івановна',
        'Female',
        '1991-12-12',
        '0000000003',
        (SELECT A."id"
         FROM "Address" A
                  JOIN "Street" S on A."StreetId" = S.id
                  JOIN "Town" T on S."TownId" = T."id"
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" IS NULL
           AND D."Name" IS NULL
           AND T."Name" LIKE 'Київ'
           AND S."Name" LIKE 'вулиця Академіка Янгеля'
           AND A."HouseHumber" = 3
           AND A."Apar";

-- Вправа 6.2. Налаштування обмежень рівня атрибутів або кортежів
-- 1. Реалізувати обмеження, виходячи зі змісту предметної області, на один атрибут, залежно від констант (це обмеження рівня атрибуту) або інших атрибутів кортежу (це обмеження рівня кортежу).
-- 2. Перевірити дію цього обмеження, намагаючись присвоїти йому значення, що порушує обмеження, запитом на оновлення з консолі MS.

ALTER TABLE "Citizen"
    ADD CONSTRAINT "GenderCheck" CHECK ( "Gender" = 'Male' OR "Gender" = 'Female');

UPDATE "Citizen"
SET "Gender" = 'M'
WHERE "Gender" = 'Male';

-- Вправа 6.3. Тригери
-- 1. Реалізувати вимогу на заборону певних дій, виходячи з логіки предметної області. Якщо додавання, оновлення або видалення запису порушує умову, не вносити відповідні зміни.
-- 2. Перевірити роботу тригера. Запитом на оновлення з консолі MS треба спробувати додати в певну таблицю БД кортеж, який порушує умову, та який не порушує її.

CREATE OR REPLACE FUNCTION checkIdentificationNumber() RETURNS TRIGGER AS
$$
BEGIN
    IF NEW."IdentificationNumber" IS NULL OR char_length(NEW."IdentificationNumber") != 10 THEN
        RAISE EXCEPTION 'Wrong Identification Number legth';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER "IdentificationCheck"
    BEFORE INSERT OR UPDATE
    ON "Citizen"
    FOR EACH ROW
EXECUTE PROCEDURE checkIdentificationNumber();

UPDATE "Citizen"
SET "IdentificationNumber" = '020'
WHERE "IdentificationNumber" = '0000000001';

-- Вправа 6.4. Ключі посилальної цілісності
-- У БД індивідуальної предметної області для одного зв’язку, який підтримує посилальну цілісність, замість підтримання його за допомогою Data Relational Integrity (DRI), тобто через оголошення при створенні таблиці та задання зв’язків у діаграмі БД,
--    Відмінити контроль посилальної цілісності за допомогою створення діаграми БД для двох пов’язаних таблиць шляхом видалення з неї зв’язку. Діаграма створюється пунктом контекстного меню New Diagram на папці Database Diagrams.
--    Організувати контроль посилальної цілісності при додаванні запису на стороні зовнішнього ключа за допомогою тригера.
--    Перевірити роботу тригера. Запитом на оновлення з консолі MS треба спробувати додати в певну таблицю БД кортеж, який порушує умову, та який не порушує її.

CREATE OR REPLACE FUNCTION checkForeignKey() RETURNS TRIGGER AS
$$
BEGIN
    IF (SELECT "id" FROM "Address" WHERE "id" = NEW."AddressId") IS NULL THEN
        RAISE EXCEPTION 'AddressId key is not present in table "Address".';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER "ForeignKeyCheck"
    BEFORE INSERT OR UPDATE
    ON "Citizen"
    FOR EACH ROW
EXECUTE PROCEDURE checkForeignKey();

ALTER TABLE "Citizen"
    DROP CONSTRAINT IF EXISTS "Citizen_AddressId_fkey";

INSERT INTO "Citizen" ("LastName", "FirstName", "MiddleName", "Gender", "BirthDate", "IdentificationNumber",
                       "AddressId")
VALUES ('Івченко',
        'Анна',
        'Івановна',
        'Female',
        '1991-12-12',
        '0000000010',
        1),
       ('Петров',
        'Данило',
        'Іванович',
        'Male',
        '2000-09-12',
        '0000000004',
        100);

-- Вправа 6.6. Створення збереженої процедури
-- 1. Для БД предметної області створити процедуру з вхідними і вихідними параметрами (використовувати цикл і курсор)
--     передаючи їх комбінованим способом (позиційно і по імені).
-- 2. Для індивідуальної предметної області за допомогою збереженої процедури перевести всі назви певного довідника у
--     верхній регістр.

CREATE OR REPLACE FUNCTION "revokePrivileges"(
    "username" TEXT
) RETURNS VOID AS
$$
DECLARE
    tableName NAME;
    tableCursor CURSOR FOR
        SELECT table_name
        FROM information_schema.tables;
BEGIN
    OPEN tableCursor;
    LOOP
        FETCH tableCursor INTO tableName;
        EXIT WHEN NOT FOUND;

        IF tableName LIKE 'prod\_%' THEN
            EXECUTE 'REVOKE ALL PRIVILEGES ON TABLE' || tableName || 'FROM ' || username;
        END IF;
    END LOOP;
    CLOSE tableCursor;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM "revokePrivileges"('TestUser');

SELECT *
FROM "revokePrivileges"(username := 'TestUser');


CREATE OR REPLACE FUNCTION "upperName"()
    RETURNS TABLE
            (
                "Name"      TEXT,
                "BirthDate" DATE
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT upper(C."LastName" || ' ' || C."FirstName") as "Name", C."BirthDate" FROM "Citizen" C;
END
$$ LANGUAGE plpgsql;

SELECT *
FROM "upperName"();

-- Вправа 6.7. Створення функції і використання в DML операторах
-- Створити функцію і використовувати її виклик в блоці, в команді SQL (select, insert, update).

CREATE OR REPLACE FUNCTION "uppercaseGender"("gender" TEXT)
    RETURNS TEXT
AS
$$
BEGIN
    RETURN UPPER(gender);
END
$$ LANGUAGE plpgsql;

SELECT "LastName", "FirstName", "uppercaseGender"("Gender") AS "Gender"
FROM "Citizen";

INSERT INTO "Citizen" ("LastName", "FirstName", "MiddleName", "Gender", "BirthDate", "IdentificationNumber",
                       "AddressId")
VALUES ('Ivanov',
        'Viktor',
        'Ivanovich',
        "uppercaseGender"('Male'),
        '1989-10-12',
        '0000000079',
        (SELECT A."id"
         FROM "Address" A
                  JOIN "Street" S on A."StreetId" = S.id
                  JOIN "Town" T on S."TownId" = T."id"
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" IS NULL
           AND D."Name" IS NULL
           AND T."Name" LIKE 'Київ'
           AND S."Name" LIKE 'вулиця Академіка Янгеля'
           AND A."HouseHumber" = 3
           AND A."ApartmentNumber" = 17
         LIMIT 1));

UPDATE "Citizen"
SET "Gender" = "uppercaseGender"("Gender");

-- Вправа 6.8. Системна інформація
-- Перегляд системної інформації про об’єкти БД
--     1. Отримати дані («вихідні коди», помилки компіляції) про створених процедурах, функціях, тригерах.
--     2. Показати залежності між об'єктами бази даних для своєї схеми.

SELECT dependent_ns.nspname   as dependent_schema
     , dependent_view.relname as dependent_view
     , source_ns.nspname      as source_schema
     , source_table.relname   as source_table
     , pg_attribute.attname   as column_name
FROM pg_depend
         JOIN pg_rewrite ON pg_depend.objid = pg_rewrite.oid
         JOIN pg_class as dependent_view ON pg_rewrite.ev_class = dependent_view.oid
         JOIN pg_class as source_table ON pg_depend.refobjid = source_table.oid
         JOIN pg_attribute ON pg_depend.refobjid = pg_attribute.attrelid
    AND pg_depend.refobjsubid = pg_attribute.attnum
         JOIN pg_namespace dependent_ns ON dependent_ns.oid = dependent_view.relnamespace
         JOIN pg_namespace source_ns ON source_ns.oid = source_table.relnamespace
ORDER BY dependent_schema, dependent_view;
