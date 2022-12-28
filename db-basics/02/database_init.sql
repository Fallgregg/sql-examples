CREATE TABLE "Region"
(
    "id"        SERIAL PRIMARY KEY,
    "Name"      VARCHAR UNIQUE,
    "ShortName" VARCHAR(5) UNIQUE
);

ALTER TABLE "Region"
    DROP COLUMN "ShortName";

CREATE TABLE "District"
(
    "id"       SERIAL PRIMARY KEY,
    "RegionId" INT REFERENCES "Region" ("id"),
    "Name"     VARCHAR,
    UNIQUE ("RegionId", "Name")
);

CREATE TABLE "Town"
(
    "id"         SERIAL PRIMARY KEY,
    "DistrictId" INT REFERENCES "District" ("id") NOT NULL,
    "Name"       VARCHAR                          NOT NULL,
    UNIQUE ("DistrictId", "Name")
);

ALTER TABLE "Town"
    ADD COLUMN "TownCode" VARCHAR UNIQUE NOT NULL DEFAULT '000';

CREATE TABLE "Street"
(
    "id"     SERIAL PRIMARY KEY,
    "TownId" INT REFERENCES "Town" ("id") NOT NULL,
    "Name"   VARCHAR(80)                  NOT NULL,
    UNIQUE ("TownId", "Name")
);

ALTER TABLE "Street"
    ALTER COLUMN "Name" TYPE VARCHAR;

CREATE TABLE "Address"
(
    "id"              SERIAL PRIMARY KEY,
    "PostIndex"       VARCHAR(5)                     NOT NULL,
    "StreetId"        INT REFERENCES "Street" ("id") NOT NULL,
    "HouseHumber"     INT                            NOT NULL,
    "ApartmentNumber" INT,
    "NumberOfPeople"  INT                            NOT NULL,
    UNIQUE ("PostIndex", "StreetId", "HouseHumber", "ApartmentNumber")
);

CREATE TABLE "Citizen"
(
    "id"                   SERIAL PRIMARY KEY,
    "LastName"             VARCHAR                         NOT NULL,
    "FirstName"            VARCHAR                         NOT NULL,
    "MiddleName"           VARCHAR                         NOT NULL,
    "Gender"               VARCHAR                         NOT NULL,
    "BirthDate"            DATE                            NOT NULL,
    "IdentificationNumber" VARCHAR UNIQUE,
    "AddressId"            INT REFERENCES "Address" ("id") NOT NULL
);

CREATE TABLE "PassportType"
(
    "id"   SERIAL PRIMARY KEY,
    "Type" VARCHAR UNIQUE NOT NULL
);

CREATE TABLE "PassportData"
(
    "CitizenId"  INT REFERENCES "Citizen" ("id")      NOT NULL,
    "TypeId"     INT REFERENCES "PassportType" ("id") NOT NULL,
    "Serie"      VARCHAR,
    "Number"     VARCHAR                              NOT NULL,
    "Given By"   VARCHAR                              NOT NULL,
    "Given When" DATE                                 NOT NULL,
    UNIQUE ("TypeId", "Serie", "Number")
);

CREATE TABLE "PhoneNumber"
(
    "CitizenId"  INT REFERENCES "Citizen" ("id") NOT NULL,
    "TownCodeId" INT REFERENCES "Town" ("id"),
    "Number"     VARCHAR                         NOT NULL
);





CREATE TABLE Client
(
Id SERIAL PRIMARY KEY,
Name VARCHAR(60) NOT null
);

CREATE TABLE Card
(
Id SERIAL PRIMARY KEY,
modeId INTEGER REFERENCES visit_mode (Id),
ClientId INTEGER REFERENCES Client (Id)

);

CREATE TABLE Visit_mode
(
Id SERIAL PRIMARY KEY,
visiting_types VARCHAR(60) NOT null,
visit_time_start time,
visit_time_finish time,
visit_period_start date,
visit_period_finish date

);

CREATE TABLE List_Service
(
Id SERIAL PRIMARY KEY,
receiving_date date ,
service_Id INTEGER REFERENCES Service (Id),
card_Id INTEGER REFERENCES card (Id)
);

CREATE TABLE Service
(
Id SERIAL PRIMARY KEY,
types_service VARCHAR(30) UNIQUE NOT null
);