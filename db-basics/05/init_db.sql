CREATE TABLE "Listeners"
(
    "id"                  SERIAL PRIMARY KEY,
    "LastName"            VARCHAR NOT NULL,
    "FirsMiddleName"      VARCHAR NOT NULL,
    "WorkingPlace"        VARCHAR NOT NULL,
    "LastAttestationDate" DATE    NOT NULL
);

CREATE TABLE "Topics"
(
    "id"        SERIAL PRIMARY KEY,
    "TopicName" VARCHAR UNIQUE NOT NULL
);

CREATE TABLE "ExamsPlan"
(
    "id"            SERIAL PRIMARY KEY,
    "TopicID"       INT REFERENCES "Topics" ("id")    NOT NULL,
    "ListenersID"   INT REFERENCES "Listeners" ("id") NOT NULL,
    "AdmissionDate" DATE                              NOT NULL,
    "FinishDate"    DATE                              NOT NULL
);

CREATE TABLE "Exams"
(
    "id"             SERIAL PRIMARY KEY,
    "ListenersID"    INT REFERENCES "Listeners" ("id") NOT NULL,
    "TopicID"        INT REFERENCES "Topics" ("id")    NOT NULL,
    "ExamPassedDate" DATE                              NOT NULL
);
