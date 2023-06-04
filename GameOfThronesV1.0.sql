--Removed unneccessary commander information

ALTER TABLE Battles DROP COLUMN attacker_commander, defender_commander
SELECT * FROM [GameOfThrones]..Battles

--Removed size of each battle party

ALTER TABLE Battles DROP COLUMN attacker_size, defender_size 
SELECT * FROM Battles

--Converts the lower case win and loss to capital for cohesive purposes.

SELECT attacker_outcome,
CASE WHEN attacker_outcome = 'win' THEN 'Win'
	 WHEN attacker_outcome = 'loss' THEN 'Loss'
	 ELSE attacker_outcome
	 END
FROM [GameOfThrones]..Battles

UPDATE Battles
SET attacker_outcome = CASE WHEN attacker_outcome = 'win' THEN 'Win'
	 WHEN attacker_outcome = 'loss' THEN 'Loss'
	 ELSE attacker_outcome
	 END 
FROM [GameOfThrones]..Battles

SELECT * FROM [GameOfThrones]..Battles

--Replacing the NULL values with NOT AVAILABLE
--Some of the information is not clearly stated in the books and is best to set them as NOT AVAILABLE

UPDATE Battles
SET attacker_king = 'NOT AVAILABLE'
WHERE attacker_king IS NULL;
SELECT * FROM [GameOfThrones]..Battles

UPDATE Battles
SET defender_king = 'NOT AVAILABLE'
WHERE defender_king IS NULL;

UPDATE Battles
SET defender_1 = 'NOT AVAILABLE'
WHERE defender_1 IS NULL;

UPDATE Battles
SET attacker_outcome = 'NOT AVAILABLE'
WHERE attacker_outcome IS NULL;

UPDATE Battles
SET major_death = 'NOT AVAILABLE'
WHERE major_death IS NULL;

SELECT * FROM [GameOfThrones]..Battles