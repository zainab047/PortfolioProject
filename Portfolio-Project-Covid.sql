select *
from CovidDeaths
where continent is not null
order by 3,4

--select *
--from CovidVaccinations
--order by 3, 4

-- selecting the data were going to be using
select location, date, total_cases,new_cases,total_deaths, population
from CovidDeaths
where continent is not null
order by 1,2

--looking at total_cases vs total deaths 
select location, date, total_cases,new_cases, total_deaths, population
from CovidDeaths
where continent is not null
order by 1, 2;


-- looking at total cases vs total deaths (% of deaths vs cases)
select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as 'Death_Percentage'
from CovidDeaths
--where location like '%kuwait%'
where continent is not null
order by 1,2;

-- looking at total cases vs population (% of population got infected)
select location, date, population, total_cases, (total_cases/population) * 100 as 'Percentage_Infected'
from CovidDeaths
--where location like '%kuwait%'
order by 1,2;

-- Looking at the countries with highest infection rate
select location, population, max(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as percentage_population_infected
from CovidDeaths
where continent is not null
group by location, population
order by 4 desc;

-- Looking at the countries with highest death rate
select location, MAX(total_deaths) as total_deaths
from CovidDeaths
where continent is not null
group by location
order by 2 desc;

-- Breaking down numbers by continent
select continent, MAX(total_deaths) as total_deaths
from CovidDeaths
where continent is not null
group by continent
order by 2 desc;


--Global numbers (overall)
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) as death_percentage
from CovidDeaths
where continent is not null


--Global numbers (every day)
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, nullif(sum(new_deaths),0)/nullif(sum(new_cases),0) as death_percentage
from CovidDeaths
where continent is not null
group by date
order by date

-- looking at total population vs vaccinations (joining tables and using 2 columns)
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location ORDER BY dea.location, dea.date) as running_people_vaccinated
--, (running_people_vaccinated/population) *100
from CovidDeaths dea
join CovidVaccinations vac
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
order by 2,3;


-- Using CTE

WITH popvsVac (Continent,Location, Date, Population, New_vaccinations, Running_people_vaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location ORDER BY dea.location, dea.date) as running_people_vaccinated
--, (running_people_vaccinated/population) *100
from CovidDeaths dea
join CovidVaccinations vac
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
--order by 2,3
)
select *, (Running_people_vaccinated/Population)*100 as percentage_people_vaccinated
from popvsVac

-- Using Temp table

Drop Table if exists #PercentPeopleVaccinated
--added incase i made a change to the query; i can update the temp table by rerunning the code.

CREATE TABLE #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Running_People_Vaccinated numeric
)

INSERT INTO #PercentPeopleVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location ORDER BY dea.location, dea.date) as running_people_vaccinated
--, (running_people_vaccinated/population) *100
from CovidDeaths dea
join CovidVaccinations vac
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
--order by 2,3

SELECT * From #PercentPeopleVaccinated

-- Creating View for later visualization

CREATE VIEW PercentPeopleVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location ORDER BY dea.location, dea.date) as running_people_vaccinated
--, (running_people_vaccinated/population) *100
from CovidDeaths dea
join CovidVaccinations vac
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
--order by 2,3

select * from PercentPeopleVaccinated
order by location, date asc