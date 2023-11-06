Select *
FROM PortfolioProject..CovidDeaths
Order by 3, 4

 
                               --DATA BY COUNTRIES




--Select *
--FROM PortfolioProject..CovidVaccinations
--Order by 3, 4

-- Select Data that I will be using
Select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
Order by 1, 2


--Total Cases VS Total Deaths
--Shows likelihood of dying from Covid based on Country lived in
Select location, date, total_cases,total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where total_cases > 0 AND location Like 'Canada'
Order by 1,2


--Total Cases VS Population
--Show what percentage of population got Covid
Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location Like 'Canada'
Order by 1,2


-- Show Countries with Highest Infection Rate compared to Population
Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as  PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
Order by PercentPopulationInfected DESC


--Show Countries with Highest Deaths Count per Population
Select location, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Group by location
Order by TotalDeathCount DESC



                               --DATA BY CONTINENT----



--Show Continents with Highest Deaths Count
Select continent, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent IN ('Antartica', 'Oceania', 'Asia' , 'South America', 'Africa', 'North America', 'Europe', 'Austrailia')
Group by continent
Order by TotalDeathCount DESC


-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2



--Looking at Total Population vs Vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent IN ('Antartica', 'Oceania', 'Asia' , 'South America', 'Africa', 'North America', 'Europe', 'Austrailia')
order by 1,2,3 



--USE CTE
With PopvsVac (Continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent IN ('Antartica', 'Oceania', 'Asia' , 'South America', 'Africa', 'North America', 'Europe', 'Austrailia')
--order by 1,2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac



--TEMPORARY TABLE 
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations nvarchar(255),
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent IN ('Antartica', 'Oceania', 'Asia' , 'South America', 'Africa', 'North America', 'Europe', 'Austrailia')
--order by 1,2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated






                     --Creating View to store data for later visualization--

 Create View PercentPopulationVaccinated as 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent IN ('Antartica', 'Oceania', 'Asia' , 'South America', 'Africa', 'North America', 'Europe', 'Austrailia')
--order by 1,2,3


Select *
From PercentPopulationVaccinated






