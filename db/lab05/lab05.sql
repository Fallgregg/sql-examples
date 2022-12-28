-- 1. Створити базу даних по варіанту. Відобразити її структуру в ER-діаграмі або у скріншоті схеми БД.

-- 2. Показати зміст таблиць.

-- 3. Виконати завдання 1-5 по варіанту.
-- 3.1. Де працюють слухачі що склали іспит з теми “ Назва теми ” до дати “Дата”.
SELECT DISTINCT "WorkingPlace"
FROM "Listeners" L
         JOIN "Exams" E on L.id = E."ListenersID"
         JOIN "Topics" T on T."id" = E."TopicID"
WHERE "TopicName" = 'topic 2'
  AND "ExamPassedDate" < '2020-11-02';

-- 3.2. Які слухачі вчасно склали іспити з теми “Назва теми” (Список за алфавітом).
SELECT DISTINCT "LastName", "FirsMiddleName"
FROM "Listeners" L
         JOIN "Exams" E on L."id" = E."ListenersID"
         JOIN "ExamsPlan" EP ON E."ListenersID" = EP."ListenersID" AND E."TopicID" = EP."TopicID"
         JOIN "Topics" T on E."TopicID" = T."id"
WHERE "TopicName" = 'topic 2'
  AND "FinishDate" >= "ExamPassedDate"
ORDER BY "LastName";

-- 3.3. Визначити які слухачі були допущені до іспиту з теми “ Назва теми ”, але іспити не склали.
SELECT DISTINCT "LastName", "FirsMiddleName"
FROM "Listeners" L
         JOIN "ExamsPlan" EP ON L."id" = EP."ListenersID"
         JOIN "Topics" T on EP."TopicID" = T."id"
         LEFT JOIN "Exams" E ON EP."ListenersID" = E."ListenersID" AND EP."TopicID" = E."TopicID"
WHERE E."ListenersID" IS NULL
  AND "TopicName" LIKE 'topic 5';
-- 3.4. Яка кількість слухачів ще Має можливість скласти іспит (мають допуск та час до закінчення прийому іспиту з теми) з теми “ Назва теми ”.
SELECT count(DISTINCT L."id") AS "Number of listeners"
FROM "Listeners" L
         JOIN "ExamsPlan" EP ON L."id" = EP."ListenersID"
         JOIN "Topics" T on EP."TopicID" = T."id"
         LEFT JOIN "Exams" E ON EP."ListenersID" = E."ListenersID" AND EP."TopicID" = E."TopicID"
WHERE E."ListenersID" IS NULL
  AND "TopicName" LIKE 'topic 5'
  AND CURRENT_DATE < "FinishDate";
-- 3.5. Визначити слухача, що першим склав іспити зі всіх тем.
WITH listeners_exams AS (SELECT *
                         FROM "Listeners" L
                                  JOIN "ExamsPlan" EP ON L.id = EP."ListenersID"
                                  LEFT JOIN "Exams" E
                                            ON EP."ListenersID" = E."ListenersID" AND EP."TopicID" = E."TopicID"),
     listeners_last_exam AS (SELECT "id", "LastName", "FirsMiddleName", max("ExamPassedDate") AS "LastExamDate"
                             FROM listeners_exams
                             WHERE id NOT IN (SELECT DISTINCT id FROM listeners_exams WHERE "ExamPassedDate" IS NULL)
                             GROUP BY "id", "LastName", "FirsMiddleName")
SELECT *
FROM listeners_last_exam
WHERE "LastExamDate" = (SELECT min("LastExamDate") FROM listeners_last_exam);