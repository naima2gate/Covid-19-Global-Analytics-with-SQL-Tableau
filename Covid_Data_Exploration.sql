-- ==========================================================
-- Project: COVID-19 SQL Exploration and Tableau Dashboard
-- Database: ProjectDB
-- Tables: CovidDeaths, CovidVaccinations
-- Author: Naima Rashid
-- ==========================================================

/* =========================================================
   SECTION 1: Data Exploration
   Purpose: Understand dataset, check missing values, and review raw data
   ========================================================= */

-- 1. Count rows where continent is NULL
SELECT COUNT(*) AS NullContinentCount
FROM ProjectDB..CovidDeaths
WHERE continent IS NULL;

-- 2. View vaccination data ordered by location and date
SELECT *
FROM ProjectDB..CovidVaccinations
ORDER BY location, date;

-- 3. View COVID-19 deaths data
SELECT 
    location, 
    date, 
    total_cases, 
    new_cases, 
    total_deaths, 
    population
FROM ProjectDB..CovidDeaths
ORDER BY location, date;

--------------------------------------------------------------------------------
/* =========================================================
   SECTION 2: Key Metrics
   Purpose: Compute infection percentages, death percentages, and rolling vaccination totals
   ========================================================= */

-- 4. Death Percentage per country
SELECT
    location, 
    date, 
    total_cases, 
    total_deaths, 
    ROUND(CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT),0) * 100, 2) AS Death_Percentage
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- 5. Percentage of population infected (example for US states)
SELECT
    location,
    date,
    total_cases,
    population,
    ROUND(CAST(total_cases AS FLOAT) / population * 100, 2) AS Infected_Population
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL
  AND location LIKE '%states%'
ORDER BY location, date;

-- 6. Maximum infection count and population percentage
SELECT 
    location,
    population,
    date,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((CONVERT(FLOAT, total_cases)/population) * 100) AS PercentPopulationCount
FROM ProjectDB..CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopulationCount DESC;

-- 7. Countries with highest infection rate relative to population
SELECT 
    location,
    population,
    MAX(CONVERT(INT, total_cases)) AS Highest_Infection_Count,
    MAX(ROUND(CAST(total_cases AS FLOAT) / population * 100, 4)) AS Infected_Population
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Infected_Population DESC;

-- 8. Countries with highest death counts
SELECT 
    location,
    MAX(CONVERT(INT, total_deaths)) AS Highest_Death_Count
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Highest_Death_Count DESC;

-- 9. Global deaths by continent
SELECT 
    continent,
    MAX(total_deaths) AS Highest_Death_Count
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Highest_Death_Count DESC;

-- 10. Global daily numbers
SELECT
    date, 
    SUM(new_cases) AS TotalCases, 
    SUM(new_deaths) AS TotalDeaths,
    CAST(SUM(new_deaths) AS FLOAT) / SUM(new_cases) * 100 AS Death_Percentage
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- 11. Overall totals
SELECT
    SUM(TRY_CAST(new_cases AS FLOAT)) AS TotalCases,
    SUM(TRY_CAST(new_deaths AS FLOAT)) AS TotalDeaths,
    (SUM(TRY_CAST(new_deaths AS FLOAT)) / NULLIF(SUM(TRY_CAST(new_cases AS FLOAT)), 0)) * 100 AS Death_Percentage
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL;

-- 12. Total population vs vaccinations (rolling sum by date)
SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations,
    SUM(CONVERT(INT, v.new_vaccinations)) OVER (
        PARTITION BY d.location 
        ORDER BY d.location, d.date
    ) AS RollingPeopleVaccinatedByDate
FROM ProjectDB..CovidDeaths d
JOIN ProjectDB..CovidVaccinations v
    ON d.location = v.location
   AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY d.continent, d.location, d.date;

-- 13. Using CTE for population vs vaccination percentage
WITH PopulationVSVaccination AS (
    SELECT 
        d.continent, 
        d.location, 
        d.date, 
        d.population, 
        v.new_vaccinations,
        SUM(CONVERT(INT, v.new_vaccinations)) OVER (
            PARTITION BY d.location 
            ORDER BY d.location, d.date
        ) AS RollingPeopleVaccinatedByDate
    FROM ProjectDB..CovidDeaths d
    JOIN ProjectDB..CovidVaccinations v
        ON d.location = v.location
       AND d.date = v.date
    WHERE d.continent IS NOT NULL
)
SELECT *, 
       (CONVERT(FLOAT, RollingPeopleVaccinatedByDate)/Population) * 100 AS PercentPopulationVaccinated
FROM PopulationVSVaccination;

--------------------------------------------------------------------------------
/* =========================================================
   SECTION 3: Temporary Tables and Views
   Purpose: Create reusable objects for analysis
   ========================================================= */

-- 14. Temporary table example
DROP TABLE IF EXISTS #PercentPeopleVaccinated;

CREATE TABLE #PercentPeopleVaccinated (
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccination NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPeopleVaccinated
SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations,
    SUM(CONVERT(INT, v.new_vaccinations)) OVER (
        PARTITION BY d.location 
        ORDER BY d.location, d.date
    )
FROM ProjectDB..CovidDeaths d
JOIN ProjectDB..CovidVaccinations v
    ON d.location = v.location
   AND d.date = v.date
WHERE d.continent IS NOT NULL;

-- Querying temporary table
SELECT *,
       (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
FROM #PercentPeopleVaccinated;

-- 15. Create view for rolling vaccinations over time
CREATE OR ALTER VIEW PeopleVaccinatedByDate AS
SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations,
    SUM(CONVERT(INT, v.new_vaccinations)) OVER (
        PARTITION BY d.location 
        ORDER BY d.location, d.date
    ) AS RollingPeopleVaccinatedByDate
FROM ProjectDB..CovidDeaths d
JOIN ProjectDB..CovidVaccinations v
    ON d.location = v.location
   AND d.date = v.date
WHERE d.continent IS NOT NULL;

-- Querying the view
SELECT *
FROM PeopleVaccinatedByDate;

--------------------------------------------------------------------------------
/* =========================================================
   SECTION 4: Tableau Dashboard Queries
   Purpose: Metrics directly used in visualizations
   ========================================================= */

-- Case fatality % - Top 10 countries
SELECT TOP 10
    location,
    (SUM(TRY_CAST(new_deaths AS FLOAT)) / NULLIF(SUM(TRY_CAST(new_cases AS FLOAT)), 0)) * 100 AS Death_Percentage
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Death_Percentage DESC;

-- Top 10 countries with highest COVID cases
SELECT TOP 10
    location,
    MAX(CONVERT(INT,total_cases)) AS Highest_Cases
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Highest_Cases DESC;

-- Pandemic timeline: Monthly impact
SELECT
    YEAR(date) AS Year,
    MONTH(date) AS Month,
    SUM(CONVERT(INT, new_cases)) AS Total_Cases, 
    SUM(CONVERT(INT, new_deaths)) AS Total_Deaths
FROM ProjectDB..CovidDeaths
GROUP BY YEAR(date), MONTH(date)
ORDER BY Year, Month;

-- Global cases vs deaths
SELECT
    SUM(TRY_CAST(new_cases AS FLOAT)) AS TotalCases,
    SUM(TRY_CAST(new_deaths AS FLOAT)) AS TotalDeaths,
    (SUM(TRY_CAST(new_deaths AS FLOAT)) / NULLIF(SUM(TRY_CAST(new_cases AS FLOAT)), 0)) * 100 AS Death_Percentage
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL;

-- Covid-19 spread across globe
SELECT 
    location,
    population,
    MAX(CONVERT(INT, total_cases)) AS Highest_Infection_Count,
    MAX(ROUND(CAST(total_cases AS FLOAT) / population * 100, 4)) AS Infected_Population
FROM ProjectDB..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Infected_Population DESC;
