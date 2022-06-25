SELECT *
FROM `rock-cairn-351811.COVID19_PortfolioProject.covid_deaths`
WHERE continent is null
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `rock-cairn-351811.COVID19_PortfolioProject.covid_deaths`
ORDER BY 1,2

-- total_cases vs total deaths
-- shows the likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM `rock-cairn-351811.COVID19_PortfolioProject.covid_deaths`
WHERE location = "India"
ORDER BY 1,2

-- total cases vs oppulation
SELECT location, date, total_cases, population, (total_cases/population)*100 AS cases_percentage
FROM `rock-cairn-351811.COVID19_PortfolioProject.covid_deaths`
WHERE location = "India"
ORDER BY 1,2

-- contries with highest infectionrate comppared to ppoulartion
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percentage_population_infected
FROM `rock-cairn-351811.COVID19_PortfolioProject.covid_deaths`
--WHERE location = "India"
GROUP BY population, location
ORDER BY 4 desc


--CONTRIES WITH THE HIGHEST DEATH COUNT PER PPOPULATION
SELECT location, population, MAX(total_deaths) AS TOTAL_DEATH_COUNT 
FROM `rock-cairn-351811.COVID19_PortfolioProject.covid_deaths`
--WHERE location = "India"
WHERE continent is not null
GROUP BY population, location
ORDER BY 3 desc


--continents with highest death count
SELECT continent, MAX(total_deaths) AS TOTAL_DEATH_COUNT 
FROM `rock-cairn-351811.COVID19_PortfolioProject.covid_deaths`
WHERE continent is not null
GROUP BY continent
ORDER BY 2 desc


-- GLOBAL NUMBERS
SELECT SUM(new_cases) AS total_cases, SUM (new_deaths) AS total_deaths, SUM(new_deaths)/ SUM(new_cases)*100 AS death_percentage
FROM `rock-cairn-351811.COVID19_PortfolioProject.covid_deaths`
WHERE continent IS NOT null
--GROUP BY date
ORDER BY 1,2


SELECT *
FROM `rock-cairn-351811.COVID19_PortfolioProject.covid_deaths` dea
JOIN `rock-cairn-351811.COVID19_PortfolioProject.covid_vaccinations` vac
  ON dea.location = vac.location


--total poulation vs vaccination
CREATE TABLE rock-cairn-351811.COVID19_PortfolioProject.PopvsVac AS
  SELECT dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
  FROM `rock-cairn-351811.COVID19_PortfolioProject.covid_deaths` dea
  JOIN `rock-cairn-351811.COVID19_PortfolioProject.covid_vaccinations` vac
    ON dea.location = vac.location
    AND dea.date =vac.date
  WHERE dea.continent IS NOT null 

SELECT *, (Rolling_People_Vaccinated/population)*100
FROM `rock-cairn-351811.COVID19_PortfolioProject.PopvsVac`


