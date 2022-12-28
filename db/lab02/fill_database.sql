INSERT INTO "Region" ("Name")
VALUES (NULL),
       ('Сумська'),
       ('Запорізька'),
       ('Харківська'),
       ('Одеська');

INSERT INTO "District" ("RegionId", "Name")
VALUES ((SELECT "id" FROM "Region" WHERE "Name" IS NULL LIMIT 1), NULL),
       ((SELECT "id" FROM "Region" WHERE "Name" LIKE 'Сумська' LIMIT 1), 'Конотопський'),
       ((SELECT "id" FROM "Region" WHERE "Name" LIKE 'Запорізька' LIMIT 1), 'Бердянський'),
       ((SELECT "id" FROM "Region" WHERE "Name" LIKE 'Харківська' LIMIT 1), 'Ізюмський'),
       ((SELECT "id" FROM "Region" WHERE "Name" LIKE 'Одеська' LIMIT 1), 'Ізмаїльський');

INSERT INTO "Town" ("DistrictId", "Name", "TownCode")
VALUES ((SELECT D."id"
         FROM "District" D
                  JOIN "Region" R ON R."id" = D."RegionId"
         WHERE R."Name" IS NULL
           AND D."Name" IS NULL
         LIMIT 1), 'Київ', '044'),
       ((SELECT D."id"
         FROM "District" D
                  JOIN "Region" R ON R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Сумська'
           AND D."Name" LIKE 'Конотопський'
         LIMIT 1), 'Попівка', '0544751'),
       ((SELECT D."id"
         FROM "District" D
                  JOIN "Region" R ON R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Запорізька'
           AND D."Name" LIKE 'Бердянський'
         LIMIT 1), 'Бердянськ', '06153'),
       ((SELECT D."id"
         FROM "District" D
                  JOIN "Region" R ON R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Харківська'
           AND D."Name" LIKE 'Ізюмський'
         LIMIT 1), 'Ізюм', '05743'),
       ((SELECT D."id"
         FROM "District" D
                  JOIN "Region" R ON R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Одеська'
           AND D."Name" LIKE 'Ізмаїльський'
         LIMIT 1), 'Ізмаїл', '04841');

INSERT INTO "Street" ("TownId", "Name")
VALUES ((SELECT T."id"
         FROM "Town" T
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" IS NULL
           AND D."Name" IS NULL
           AND T."Name" LIKE 'Київ'
         LIMIT 1), 'вулиця Академіка Янгеля'),
       ((SELECT T."id"
         FROM "Town" T
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Сумська'
           AND D."Name" LIKE 'Конотопський'
           AND T."Name" LIKE 'Попівка'
         LIMIT 1), 'вулиця Гастелло'),
       ((SELECT T."id"
         FROM "Town" T
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Запорізька'
           AND D."Name" LIKE 'Бердянський'
           AND T."Name" LIKE 'Бердянськ'
         LIMIT 1), 'вулиця Макарова'),
       ((SELECT T."id"
         FROM "Town" T
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Харківська'
           AND D."Name" LIKE 'Ізюмський'
           AND T."Name" LIKE 'Ізюм'
         LIMIT 1), 'вулиця Степана Разіна'),
       ((SELECT T."id"
         FROM "Town" T
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Одеська'
           AND D."Name" LIKE 'Ізмаїльський'
           AND T."Name" LIKE 'Ізмаїл'
         LIMIT 1), 'вулиця Чехова');

INSERT INTO "Address" ("PostIndex", "StreetId", "HouseHumber", "ApartmentNumber", "NumberOfPeople")
VALUES ('01001', (SELECT S."id"
                  FROM "Street" S
                           JOIN "Town" T on S."TownId" = T."id"
                           JOIN "District" D on T."DistrictId" = D.id
                           JOIN "Region" R on R."id" = D."RegionId"
                  WHERE R."Name" IS NULL
                    AND D."Name" IS NULL
                    AND T."Name" LIKE 'Київ'
                    AND S."Name" LIKE 'вулиця Академіка Янгеля'
                  LIMIT 1), 3, 17, 3),
       ('40000', (SELECT S."id"
                  FROM "Street" S
                           JOIN "Town" T on S."TownId" = T."id"
                           JOIN "District" D on T."DistrictId" = D.id
                           JOIN "Region" R on R."id" = D."RegionId"
                  WHERE R."Name" LIKE 'Сумська'
                    AND D."Name" LIKE 'Конотопський'
                    AND T."Name" LIKE 'Попівка'
                    AND S."Name" LIKE 'вулиця Гастелло'
                  LIMIT 1), 16, 5, 5),
       ('71100', (SELECT S."id"
                  FROM "Street" S
                           JOIN "Town" T on S."TownId" = T."id"
                           JOIN "District" D on T."DistrictId" = D.id
                           JOIN "Region" R on R."id" = D."RegionId"
                  WHERE R."Name" LIKE 'Запорізька'
                    AND D."Name" LIKE 'Бердянський'
                    AND T."Name" LIKE 'Бердянськ'
                    AND S."Name" LIKE 'вулиця Макарова'
                  LIMIT 1), 1, 5, 4),
       ('61001', (SELECT S."id"
                  FROM "Street" S
                           JOIN "Town" T on S."TownId" = T."id"
                           JOIN "District" D on T."DistrictId" = D.id
                           JOIN "Region" R on R."id" = D."RegionId"
                  WHERE R."Name" LIKE 'Харківська'
                    AND D."Name" LIKE 'Ізюмський'
                    AND T."Name" LIKE 'Ізюм'
                    AND S."Name" LIKE 'вулиця Степана Разіна'
                  LIMIT 1), 9, 16, 3),
       ('65000', (SELECT S."id"
                  FROM "Street" S
                           JOIN "Town" T on S."TownId" = T."id"
                           JOIN "District" D on T."DistrictId" = D.id
                           JOIN "Region" R on R."id" = D."RegionId"
                  WHERE R."Name" LIKE 'Одеська'
                    AND D."Name" LIKE 'Ізмаїльський'
                    AND T."Name" LIKE 'Ізмаїл'
                    AND S."Name" LIKE 'вулиця Чехова'
                  LIMIT 1), 21, 16, 6);


INSERT INTO "Citizen" ("LastName", "FirstName", "MiddleName", "Gender", "BirthDate", "IdentificationNumber",
                       "AddressId")
VALUES ('Іванов',
        'Іван',
        'Іванович',
        'Male',
        '1990-10-12',
        '000000001',
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
         LIMIT 1)),
       ('Сидоров',
        'Олег',
        'Петрович',
        'Male',
        '1998-11-22',
        '000000002',
        (SELECT A."id"
         FROM "Address" A
                  JOIN "Street" S on A."StreetId" = S.id
                  JOIN "Town" T on S."TownId" = T."id"
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Сумська'
           AND D."Name" LIKE 'Конотопський'
           AND T."Name" LIKE 'Попівка'
           AND S."Name" LIKE 'вулиця Гастелло'
           AND A."HouseHumber" = 16
           AND A."ApartmentNumber" = 5
         LIMIT 1)),
       ('Смирнова',
        'Анна',
        'Олегівна',
        'Female',
        '1969-06-21',
        '000000003',
        (SELECT A."id"
         FROM "Address" A
                  JOIN "Street" S on A."StreetId" = S.id
                  JOIN "Town" T on S."TownId" = T."id"
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Запорізька'
           AND D."Name" LIKE 'Бердянський'
           AND T."Name" LIKE 'Бердянськ'
           AND S."Name" LIKE 'вулиця Макарова'
           AND A."HouseHumber" = 1
           AND A."ApartmentNumber" = 5
         LIMIT 1)),
       ('Петров',
        'Данило',
        'Іванович',
        'Male',
        '2000-09-12',
        '000000004',
        (SELECT A."id"
         FROM "Address" A
                  JOIN "Street" S on A."StreetId" = S.id
                  JOIN "Town" T on S."TownId" = T."id"
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Харківська'
           AND D."Name" LIKE 'Ізюмський'
           AND T."Name" LIKE 'Ізюм'
           AND S."Name" LIKE 'вулиця Степана Разіна'
           AND A."HouseHumber" = 9
           AND A."ApartmentNumber" = 16
         LIMIT 1)),
       ('Іванова',
        'Олена',
        'Андріївна',
        'Female',
        '1996-01-02',
        '000000005',
        (SELECT A."id"
         FROM "Address" A
                  JOIN "Street" S on A."StreetId" = S.id
                  JOIN "Town" T on S."TownId" = T."id"
                  JOIN "District" D on T."DistrictId" = D.id
                  JOIN "Region" R on R."id" = D."RegionId"
         WHERE R."Name" LIKE 'Одеська'
           AND D."Name" LIKE 'Ізмаїльський'
           AND T."Name" LIKE 'Ізмаїл'
           AND S."Name" LIKE 'вулиця Чехова'
           AND A."HouseHumber" = 21
           AND A."ApartmentNumber" = 16
         LIMIT 1));


INSERT INTO "PassportType" ("Type")
VALUES ('Паспорт'),
       ('ID-картка'),
       ('Свідотство про народження');

INSERT INTO "PassportData" ("CitizenId", "TypeId", "Serie", "Number", "Given By", "Given When")
VALUES ((SELECT "id" FROM "Citizen" WHERE "IdentificationNumber" LIKE '000000001' LIMIT 1),
        (SELECT "id" FROM "PassportType" WHERE "Type" LIKE 'ID-картка' LIMIT 1),
        'NULL', '203394', '004040', '1990-10-12'),
       ((SELECT "id" FROM "Citizen" WHERE "IdentificationNumber" LIKE '000000002' LIMIT 1),
        (SELECT "id" FROM "PassportType" WHERE "Type" LIKE 'ID-картка' LIMIT 1),
        'NULL', '207394', '009940', '1991-10-12'),
       ((SELECT "id" FROM "Citizen" WHERE "IdentificationNumber" LIKE '000000003' LIMIT 1),
        (SELECT "id" FROM "PassportType" WHERE "Type" LIKE 'ID-картка' LIMIT 1),
        'NULL', '203894', '002340', '1992-10-12'),
       ((SELECT "id" FROM "Citizen" WHERE "IdentificationNumber" LIKE '000000004' LIMIT 1),
        (SELECT "id" FROM "PassportType" WHERE "Type" LIKE 'ID-картка' LIMIT 1),
        'NULL', '203494', '008740', '1993-10-12'),
       ((SELECT "id" FROM "Citizen" WHERE "IdentificationNumber" LIKE '000000005' LIMIT 1),
        (SELECT "id" FROM "PassportType" WHERE "Type" LIKE 'ID-картка' LIMIT 1),
        'NULL', '245694', '002340', '1994-10-12');

INSERT INTO "PhoneNumber" ("CitizenId", "TownCodeId", "Number")
VALUES ((SELECT "id" FROM "Citizen" WHERE "IdentificationNumber" LIKE '000000001' LIMIT 1), NULL, '0954444444'),
       ((SELECT "id" FROM "Citizen" WHERE "IdentificationNumber" LIKE '000000002' LIMIT 1), NULL, '0994444444'),
       ((SELECT "id" FROM "Citizen" WHERE "IdentificationNumber" LIKE '000000003' LIMIT 1), NULL, '0664444444'),
       ((SELECT "id" FROM "Citizen" WHERE "IdentificationNumber" LIKE '000000004' LIMIT 1),
        (SELECT "id" FROM "Town" WHERE "Name" LIKE 'Ізюм' LIMIT 1), '67575'),
       ((SELECT "id" FROM "Citizen" WHERE "IdentificationNumber" LIKE '000000005' LIMIT 1),
        (SELECT "id" FROM "Town" WHERE "Name" LIKE 'Ізмаїл' LIMIT 1), '85583');
