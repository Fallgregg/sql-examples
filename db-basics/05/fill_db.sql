INSERT INTO "Listeners" ("LastName", "FirsMiddleName", "WorkingPlace", "LastAttestationDate")
VALUES ('Сидоров', 'Олег Петрович', 'Google Company', '2019-09-01'),
       ('Смирнова', 'Анна Олегівна', 'Microsoft Company', '2018-10-03'),
       ('Іванова', 'Олена Андріївна', 'Acer Company', '2018-11-03'),
       ('Іванов', 'Іван Іванович', 'Apple Company', '2019-10-20'),
       ('Петров', 'Данило Іванович', 'Facebook Company', '2017-09-20');

INSERT INTO "Topics" ("TopicName")
VALUES ('topic 1'),
       ('topic 2'),
       ('topic 3'),
       ('topic 4'),
       ('topic 5'),
       ('topic 6'),
       ('topic 7');

INSERT INTO "ExamsPlan" ("TopicID", "ListenersID" , "AdmissionDate", "FinishDate")
VALUES ((SELECT "id" FROM "Topics" WHERE "TopicName" LIKE 'topic 3'), (SELECT "id"
                                                                       FROM "Listeners"
                                                                       WHERE "LastName" LIKE 'Смирнова'
                                                                         AND "FirsMiddleName" LIKE 'Анна Олегівна'),
        '2020-09-01', '2020-09-02'),
       ((SELECT "id" FROM "Topics" WHERE "TopicName" LIKE 'topic 1'), (SELECT "id"
                                                                       FROM "Listeners"
                                                                       WHERE "LastName" LIKE 'Сидоров'
                                                                         AND "FirsMiddleName" LIKE 'Олег Петрович'),
        '2020-09-02', '2020-09-02'),
       ((SELECT "id" FROM "Topics" WHERE "TopicName" LIKE 'topic 4'), (SELECT "id"
                                                                       FROM "Listeners"
                                                                       WHERE "LastName" LIKE 'Іванова'
                                                                         AND "FirsMiddleName" LIKE 'Олена Андріївна'),
        '2020-09-02', '2020-09-02'),
       ((SELECT "id" FROM "Topics" WHERE "TopicName" LIKE 'topic 5'), (SELECT "id"
                                                                       FROM "Listeners"
                                                                       WHERE "LastName" LIKE 'Іванов'
                                                                         AND "FirsMiddleName" LIKE 'Іван Іванович'),
        '2020-09-03', '2020-09-05'),
       ((SELECT "id" FROM "Topics" WHERE "TopicName" LIKE 'topic 2'), (SELECT "id"
                                                                       FROM "Listeners"
                                                                       WHERE "LastName" LIKE 'Петров'
                                                                         AND "FirsMiddleName" LIKE 'Данило Іванович'),
        '2020-09-02', '2020-09-03');

INSERT INTO "Exams" ("ListenersID", "TopicID", "ExamPassedDate")
VALUES ((SELECT "id"
         FROM "Listeners"
         WHERE "LastName" LIKE 'Смирнова'
           AND "FirsMiddleName" LIKE 'Анна Олегівна'), (SELECT "id" FROM "Topics" WHERE "TopicName" LIKE 'topic 3'),
        '2020-10-05'),
       ((SELECT "id"
         FROM "Listeners"
         WHERE "LastName" LIKE 'Сидоров'
           AND "FirsMiddleName" LIKE 'Олег Петрович'), (SELECT "id" FROM "Topics" WHERE "TopicName" LIKE 'topic 1'),
        '2020-10-04'),
       ((SELECT "id"
         FROM "Listeners"
         WHERE "LastName" LIKE 'Іванова'
           AND "FirsMiddleName" LIKE 'Олена Андріївна'), (SELECT "id" FROM "Topics" WHERE "TopicName" LIKE 'topic 4'),
        '2020-09-25'),
       ((SELECT "id"
         FROM "Listeners"
         WHERE "LastName" LIKE 'Петров'
           AND "FirsMiddleName" LIKE 'Данило Іванович'), (SELECT "id" FROM "Topics" WHERE "TopicName" LIKE 'topic 5'),
        '2020-11-01'),
       ((SELECT "id"
         FROM "Listeners"
         WHERE "LastName" LIKE 'Петров'
           AND "FirsMiddleName" LIKE 'Данило Іванович'), (SELECT "id" FROM "Topics" WHERE "TopicName" LIKE 'topic 2'),
        '2020-09-25');


