-- Завдання:

-- Використовуючи Azure SQL Database*:
-- 1.	Створити базу даних, де назвою буде ваше прізвище. Впевнитись, що кодування бази даних підтримує українську мову.
CREATE DATABASE Zabilska

-- 2.	Створити таблицю music, що матиме колонки з назвою виконавця, пісні, альбому та року релізу, самостійно обравши типи даних.
CREATE TABLE Music
(
   Artist NVARCHAR(30),
   TrackName NVARCHAR (30),
   AlbumName NVARCHAR (30),
   ReleaseYear INT
)
GO

-- 3.	Відредагувати створену таблицю додавши нову колонку з ідентифікатором, що буде первинним ключем та матиме властивість автоінкременту.
ALTER TABLE Music ADD id INT NOT NULL IDENTITY(1,1) CONSTRAINT id PRIMARY KEY GO

-- 4.	Записати в таблицю music п’ять рядкова з піснями, що ви зараз слухаєте найчастіше. Серед них повинна бути хоча б одна з назвою чи виконавцем українською мовою.
INSERT INTO Music
   (Artist, TrackName, AlbumName, ReleaseYear)
VALUES
   ('Cage The Elephant', 'Ready To Let Go', 'Social Cues', 2019),
   ('The Zombies', 'Time Of The Season', 'Odessey&Oracle', 1967),
   ( 'The Storkes', 'The Adults Ar Talking', 'The New Abnormal', 2020),
   ('Dolly Parton, Kenny Rogers', 'Island in the Stream', 'Pure & Simple', 2016),
   ('Агата Крісті', 'Опіум для нікого', 'Опіум', 1994)
GO

-- 5.	Створити таблицю artists, що містить назви виконавців (музичних гуртів), країн їх походження, та рік заснування.
CREATE TABLE Artists
(
   id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   ArtistName VARCHAR(30),
   ArtistCountry VARCHAR (30),
   WhenCreated INT
)
GO


-- Додати до таблиці music нову колонку з ідентифікатором виконавця.
ALTER TABLE Music ADD ArtistId INT FOREIGN KEY REFERENCES Artists(id) GO

-- Заповнити відсутні значення шляхом пошуку відповідностей в назвах виконавців між таблицями.
UPDATE Music SET ArtistId = (
    SELECT Id FROM Artists
    JOIN Music ON Artists.ArtistName = Music.Artist
    WHERE Music.Id = Music.Id
)
GO

-- Видалити назву виконавця з таблиці music.
ALTER TABLE Music DROP COLUMN Artist GO

-- Впевнитись, що неможливо додати посилання не неіснуючого виконавця.
-- 6.	Створити представлення (view), що виводить всю інформацію про музичні треки виконавців зі Східної Європи.
CREATE VIEW EasternEurope
AS
    (
    SELECT *
    FROM Music
        JOIN Artists ON Music.AtristId = Atrists.Id
    WHERE Atrists.ArtistCountry = 'Eastern Europe')
GO

-- 7.	Створити збережену процедуру, що у якості параметрів приймає назву треку та виконавця і заповнює відповідні таблиці. Не додавати записи, якщо вони вже є в базі.
CREATE PROCEDURE [dbo].[AddTrackArtist]
    (@TrackName NVARCHAR(30),
    @ArtistName NVARCHAR(30))
AS
BEGIN
    IF NOT EXISTS (
    SELECT ArtistName
    FROM Atrists
    WHERE ArtistName = @ArtistName
) BEGIN
        INSERT INTO Atrists
            (ArtistName)
        VALUES
            (@ArtistName)
    END

    IF NOT EXISTS (
    SELECT TrackName
    FROM Music
    WHERE TrackName = @TrackName
) BEGIN
        INSERT INTO Music
            (TrackName, AtristId)
        VALUES(@TrackName, (SELECT Id
                FROM Atrists
                WHERE ArtistName = @ArtistName))
    END
END 
GO


-- 8.	Створити скалярну функцію, що приймає ідентифікатори пісні та виконавця та повертає назву треку з конкатенацією альбому та року за зразком:
Shine On You Crazy Diamond (Wish You Were Here, 1975)
ALTER FUNCTION [dbo].[AddTrachAlbum] (@TrackId INT, @ArtistId INT)
RETURNS NVARCHAR(100)
AS BEGIN
    RETURN CONCAT((SELECT TrackName
    FROM Music JOIN Atrists ON Atrists.Id = Music.AtristId
    WHERE Music.Id = @TrackId AND Atrists.Id = @ArtistId), ' ( ',
(SELECT AlbumName
    FROM Music JOIN Atrists ON Atrists.Id = Music.AtristId
    WHERE Music.Id = @TrackId AND Atrists.Id = @ArtistId), ', ',
(SELECT ReleaseYear
    FROM Music JOIN Atrists ON Atrists.Id = Music.AtristId
    WHERE Music.Id = @TrackId AND Atrists.Id = @ArtistId), ' )')
END 
GO

-- 9.	Створити табличну функцію, що повертає ті ж колонки, що і створене представлення, проте фільтрація по країнам відбувається згідно вхідного параметру.
CREATE FUNCTION TracksCountry (@Country NVARCHAR(30))
RETURNS TABLE
AS
RETURN
    SELECT *
FROM Music
    JOIN Artists ON Music.AtristId = Atrists.Id
WHERE Atrists.ArtistCountry = @Country
GO

-- 10.	Створити тригер, що при додаванні пісні буде перевіряти, що рік її релізу не менше за рік початку діяльності виконавця.
CREATE TRIGGER ReleaseYearCheck 
ON Music AFTER INSERT AS BEGIN
IF (
SELECT ReleaseYear
   FROM Music) < (SELECT WhenCreated
   FROM Atrists
   Where Id = (SELECT AtristId
   FROM inserted))
   BEGIN
(SELECT 'Release Year < Year Artist Created')
   END
END
   GO
