--double check rt tables were brought in
select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

-- Select going to be used 

select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--cases vs deaths
-- likely hood of dying in the U.S.

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2

--SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Covid_Deaths$';

--percentage that got contracted covid

select location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage
From PortfolioProject..CovidDeaths 
WHERE location like '%STATES%'
order by 1,2

--most infected countries compared to popluation
select location, population, MAX(Total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as MostInfectedPopPercent
From PortfolioProject..CovidDeaths
GROUP BY location, population
order by MostInfectedPopPercent desc

--highest death count
--change is not null to is null to get the continents w Canada and U.S. as North America
select Location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc
--highest Covid deaths


--instead of 
--ALTER TABLE Covid_Deaths$
--ALTER COLUMN total_deaths INT NOT NULL;
-- use "cast(Total_Deaths as int))" -more efficient
select continent, MAX(cast(Total_Deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc
--highest Covid deaths

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by date
order by 1,2

--take out date to get total for the world
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
--Group by date
order by 1,2

Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
order by 3,4

--total pop vs vax
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
 
 --instead of 'cast as int' you can also use (convert(int,
 --over (PARTITION)
 -- sum(vac.new_vaccinations) over (partition by dea.location) starts the count over by country
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location Order by dea.location, dea.Date) as RollingVax
,(RollingVax/population)*100
--you can't use (RollingVax/population)*100  because you just created RollingVax --you need to creat a temp table or use CTe
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE by naming all the coulumns

With PopvsVax (Continent, Location, Date, Population, New_Vaccinations, RollingVax)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location Order by dea.location, dea.Date) as RollingVax
--,(RollingVax/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingVax/population)*100
from PopvsVax

--Temp table

DROP Table if exists #RollingVaxpercent
Create table #RollingVaxpercent
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVax numeric
)

Insert into #RollingVaxpercent
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location Order by dea.location, dea.Date) as RollingVax
--,(RollingVax/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingVax/population)*100
from #RollingVaxpercent

--creating view to stare data for later visualizations
create view RollingVaxpercent as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location Order by dea.location, dea.Date) as RollingVax
--,(RollingVax/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From RollingVaxpercent