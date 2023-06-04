--Have to convert the data type to allow for a string to be placed

ALTER TABLE CharacterDeaths
ALTER COLUMN [Death Year] VARCHAR(20)

--Changing NULL values to NOT AVAILABLE
--Information taken from incomplete book series

UPDATE CharacterDeaths
SET [Death Year] = 'NOT AVAILABLE'
WHERE [Death Year] IS NULL;


SELECT * FROM [GameOfThrones]..CharacterDeaths
