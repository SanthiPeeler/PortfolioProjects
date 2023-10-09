/*
Select Location, date, total_cases, new_cases, total_deaths, population
From [dbo].[CovidDeaths]
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercentage
From [dbo].[CovidDeaths]
Where location like '%states%'
and continent is not null
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 PercentofPopulation
From [dbo].[CovidDeaths]
Where location like '%states%'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
Select Location, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 PercentPopulationInfected
From [dbo].[CovidDeaths]
Where continent is not null
Group by Location, Population
order by PercentPopulationInfected desc

--Showing Countries with Highest Dealth Count per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [dbo].[CovidDeaths]
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- Let's break things down by continent
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [dbo].[CovidDeaths]
Where continent is null and location not like '%income%' and location not like '%world%'
Group by location
order by TotalDeathCount desc


--Global Numbers
Select date, Sum(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/Sum(New_Cases)*100 as DeathPercentage
From [dbo].[CovidDeaths]
Where new_cases != 0
Group by date
order by 1,2

Select Sum(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/Sum(New_Cases)*100 as DeathPercentage
From [dbo].[CovidDeaths]
Where new_cases != 0
order by 1,2



-- Looking at Total Population vs Vaccinations
--Use CTE
With PopvsVac (Continent, Location, Data, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [dbo].[CovidDeaths]dea
Join [dbo].[CovidVaccinations]vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null	
--	order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(255),
Data datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [dbo].[CovidDeaths]dea
Join [dbo].[CovidVaccinations]vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null	
--	order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Create View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [dbo].[CovidDeaths]dea
Join [dbo].[CovidVaccinations]vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null	
--order by 2,3
*/
Select *
From [dbo].[PercentPopulationVaccinated]
