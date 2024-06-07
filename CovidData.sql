-- Covid-19 Data Exploration

-- Selecting all columns from the coviddeaths table where continent is not null, ordered by the third and fourth columns
SELECT *
FROM Portfolio.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;

-- Selecting specific columns to get a focused view of the data, ordered by location and date
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Calculating the percentage of the population infected by Covid-19 for each location and date
SELECT Location, date, population, total_cases, 
       (total_cases / population) * 100 AS InfectedPercentPop
FROM Portfolio.coviddeaths
ORDER BY 1, 2;

-- Finding the highest infection rate by country compared to their population
SELECT Location, population, 
       MAX(total_cases) AS HighestInfectionCount, 
       MAX(total_cases / population) * 100 AS InfectedPercentPop
FROM Portfolio.coviddeaths
GROUP BY Location, population
ORDER BY InfectedPercentPop DESC;

-- Identifying countries with the highest death count per population
SELECT Location, 
       MAX(total_deaths) AS TotalDeathCount
FROM Portfolio.coviddeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- Exploring data by continent
-- Continent with the highest death count per population
SELECT continent, 
       MAX(total_deaths) AS TotalDeathCount
FROM portfolio.coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Calculating global numbers for total cases and deaths
SELECT SUM(new_cases) AS total_cases, 
       SUM(new_deaths) AS total_deaths
FROM Portfolio.coviddeaths
WHERE continent IS NOT NULL;

-- Diving into vaccination data
-- Calculating the percentage of vaccinated people
SELECT coviddeaths.continent, coviddeaths.location, coviddeaths.date, 
       coviddeaths.population, covidvaccinations.new_vaccinations,
       SUM(covidvaccinations.new_vaccinations) OVER (PARTITION BY coviddeaths.location ORDER BY coviddeaths.location, coviddeaths.date) AS PeopleVaccinated
FROM Portfolio.coviddeaths
JOIN Portfolio.covidvaccinations 
ON coviddeaths.location = covidvaccinations.location
AND coviddeaths.date = covidvaccinations.date
WHERE coviddeaths.continent IS NOT NULL
ORDER BY 2, 3;

-- Joining both tables to see the ratio of vaccinated people to deaths
SELECT coviddeaths.continent, coviddeaths.location, coviddeaths.date, 
       SUM(coviddeaths.total_deaths) AS deaths, 
       SUM(covidvaccinations.new_vaccinations) AS vaccinated,
       SUM(coviddeaths.total_deaths) / SUM(covidvaccinations.new_vaccinations) AS death_to_vaccination_ratio
FROM Portfolio.coviddeaths
JOIN Portfolio.covidvaccinations
ON coviddeaths.location = covidvaccinations.location 
AND coviddeaths.date = covidvaccinations.date
WHERE coviddeaths.continent IS NOT NULL
GROUP BY coviddeaths.continent, coviddeaths.location, coviddeaths.date;
