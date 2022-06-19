
SELECT *
FROM PortfolioProjet..CovidDeaths


--

select *
FROM PortfolioProjet..CovidVaccinations


--  select data we are goin g to be using

select location, date, total_cases, new_cases,total_deaths, population
FROM PortfolioProjet..CovidDeaths 
	ORDER BY 1,2 


 --lookign to total cases vs total deaths
 --showing the death percetage over total infected cases globally
 
 select location, date, total_cases ,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjet..CovidDeaths
	ORDER BY 1,2 


 --showing the death percetage over total infected cases in sudan

select location, date, total_cases ,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjet..CovidDeaths
WHERE location like 'sudan'
	ORDER BY 1,2 


--lookign to total cases percentage over vs population

select location, date,population, total_cases , (total_cases/population)*100 as TotalCasesPercentage
FROM PortfolioProjet..CovidDeaths
WHERE location like 'sudan'
	ORDER BY 1,2 


-- Looking at the contries with highest infectiom rate compared to population

select location, population, max(total_cases) , max(total_cases)/population*100 as HighestInfectionRate
FROM PortfolioProjet..CovidDeaths
where continent is not	null
group by location, population
	ORDER BY 4 desc


-- showing contries with highest death rate over population

select location, population , MAX(cast(total_deaths as int)) , max(cast(total_deaths as int))/population*100 as HighestDeathRate
FROM PortfolioProjet..CovidDeaths
where continent is not	null
group by location, population
ORDER BY 4 desc

-- Highest total death in numbers

select location , MAX(cast(total_deaths as int)) HighestDeathCount
FROM PortfolioProjet..CovidDeaths
where continent is not	null
group by location
ORDER BY 2 desc


-- HIGHEST DEATH COUNT PER CONTINENT

select location , MAX(cast(total_deaths as int)) HighestDeathCount
FROM PortfolioProjet..CovidDeaths
where continent is 	null
group by location
ORDER BY 2 desc


-- GLOBAL NUMBERS 

select date, SUM(new_cases) AS TotalCases, SUM(cast(new_deaths as int )) as TotalDeaths 
--, SUM(cast(new_deaths as int ))/SUM(new_cases)*100 as DeathPercetage
FROM PortfolioProjet..CovidDeaths
where continent is 	null
group by date
ORDER BY 1


-- LOOKING AT TOTAL POPULATION VS VACCINATIONS

select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as float)) over (partition by dea.location order by
dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProjet..CovidDeaths dea
JOIN PortfolioProjet..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not	null
ORDER BY 2, 3


-- USING CTE

WITH VaccinationTabel AS
(
select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as float)) over (partition by dea.location order by
dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProjet..CovidDeaths dea
JOIN PortfolioProjet..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not	null
--ORDER BY 2, 3
)

SELECT *, RollingPeopleVaccinated/population
FROM VaccinationTabel


--USING TEMP TABLE


CREATE TABLE #Vaccination_Table 
(
continent nvarchar(255), 
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

insert into #Vaccination_Table
select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as float)) over (partition by dea.location order by
dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProjet..CovidDeaths dea
JOIN PortfolioProjet..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not	null
--ORDER BY 2, 3

SELECT *, RollingPeopleVaccinated/population
FROM #Vaccination_Table
ORDER BY 2, 3



--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION

create view Vaccination_Table0 as
select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as float)) over (partition by dea.location order by
dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProjet..CovidDeaths dea
JOIN PortfolioProjet..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not	null
--ORDER BY 2, 3

select *
from Vaccination_Table0

