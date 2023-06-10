--DeathArrests

SELECT * FROM DeathArrests

--Removing NULL state info to prevent overcrowding
--This will also cleanse the entire row based off of that NULL state column

DELETE FROM DeathArrests 
WHERE State IS NULL

--Removing the extra columns as I am not dealing with this information at the moment. 
ALTER TABLE DeathArrests DROP COLUMN Arrests1, Arrests2, Arrests3, Arrests4, Arrests5, Arrests6, Violent1, Violent2, Violent3, Violent4, Violent5, Violent6 
ALTER TABLE DeathArrests DROP COLUMN MixedRace, removeONE, AverageViolent, EstimateArrests


--States with the lowest count of deaths
SELECT * FROM DeathArrests 
WHERE [All People Killed by Police (1/1/2013-12/31/2019)] <= 5
ORDER BY State

--States with the highest count of deaths
SELECT * FROM DeathArrests 
WHERE [All People Killed by Police (1/1/2013-12/31/2019)] > 5
ORDER BY State

--Highest Murder Rate and Highest Death Count
SELECT * FROM DeathArrests
WHERE [Murder Rate] > 5 AND [All People Killed by Police (1/1/2013-12/31/2019)] > 5
ORDER BY State

--FatalEncounters

SELECT * FROM FatalEncounters
--Drop unused columns that I don't need. Broke them into different statements.
ALTER TABLE FatalEncounters DROP COLUMN [Url of image of deceased]

ALTER TABLE FatalEncounters DROP COLUMN [Subject's race with imputations], [Imputation probability],[Date of injury resulting in death (month/day/year)], [Location of death (city)],
[Full Address], [A brief description of the circumstances surrounding the death], [Dispositions/Exclusions INTERNAL USE, NOT FOR ANALYSIS], [Link to news article or photo of official document],
[Video], [Date&Description], [Unique ID Formula]

ALTER TABLE FatalEncounters DROP COLUMN [Location of injury (address)]

--Deleting unspecified race encounters
DELETE FROM  FatalEncounters
WHERE [Subject's race] = 'Race unspecified'

--Police Killings

SELECT * FROM PoliceKillings

--Removing unused columns

DELETE FROM PoliceKillings
WHERE [Victim's age] IS NULL


ALTER TABLE PoliceKillings DROP COLUMN [URL of image of victim], [Date of Incident (month/day/year)], [Street Address of Incident], [City], [County], [A brief description of the circumstances surrounding the death],
[Official disposition of death (justified or other)], [Criminal Charges?], [Link to news article or photo of official document], [Alleged Threat Level (Source: WaPo)], [Body Camera (Source: WaPo)], [WaPo ID (If included in WaPo database)], [Off-Duty Killing?]

ALTER TABLE PoliceKillings DROP COLUMN [Geography (via Trulia methodology based on zipcode population de]
