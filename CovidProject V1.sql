--This SQL file is using imported data sets from a Covid 
statistics site. The information was cleaned in Excel and imported into Management Studio
to work with the data via tables and queries. 





--Total Cases VERSUS Total Deaths
SELECT Location, date, total_cases, new_cases, total_deaths, ( total_deaths/total_cases) * 100 AS DeathPercentage
FROM Covid19Project..CovidDeaths
ORDER BY 1,2

--Probability of death contracting COVID in home country. I.E United States
SELECT Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM Covid19Project..CovidDeaths
WHERE Location like '%states%'
ORDER BY 1,2

--Total Cases VERSUS Population 
--Shows percent of populous contracting COVID.
SELECT Location, date, total_cases, population, (total_cases/population) * 100 AS ContractionPercent
FROM Covid19Project..CovidDeaths
WHERE Location like '%states%'
ORDER BY 1,2

--Countries with the Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) AS HighInfectionCount, MAX((total_cases/population)) * 100 AS ContractionPercent
FROM Covid19Project..CovidDeaths
GROUP BY Location, population
ORDER BY ContractionPercent DESC

--Countries with the Highest Deaths per Populous
SELECT Location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM Covid19Project..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC

--Continent Breakdown
SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM Covid19Project..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers
SELECT SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM Covid19Project..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date	
ORDER BY 1,2


--Join both tables
SELECT * FROM Covid19Project..CovidDeaths death
JOIN Covid19Project..CovidVaccinations vaccine
ON death.location = vaccine.location
AND death.date = vaccine.date

--CTE to access joined tables
WITH PopVERSUSVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccineCount)
AS (
	SELECT death.continent, death.location, death.date, death.population, vaccine.new_vaccinations, SUM(CONVERT(int, vaccine.new_vaccinations)) 
	OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingVaccineCount
	FROM Covid19Project..CovidDeaths death
	JOIN Covid19Project..CovidVaccinations vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
	WHERE death.continent IS NOT NULL
)
SELECT *, (RollingVaccineCount/Population) * 100
FROM PopVERSUSVac
