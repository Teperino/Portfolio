/*
Covid 19 Data Exploration LastDate =2021/05/09
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM CovidProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM CovidProject..CovidVaccinations
WHERE continent is not null
ORDER BY 3,4


-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases,	total_deaths, population
FROM CovidProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in 'Dominican Republic'

SELECT location, date, total_cases,	total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM CovidProject..CovidDeaths
WHERE location = 'Dominican Republic'
and continent is not null
ORDER BY 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT location, date, total_cases,	population, (total_cases/population)*100 as percent_population_infected
FROM CovidProject..CovidDeaths
WHERE location = 'Dominican Republic'
ORDER BY 1,2


-- Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population)*100) as percent_population_infected
FROM CovidProject..CovidDeaths
--WHERE Location = 'Dominican Republic'
GROUP BY location, population
ORDER BY percent_population_infected desc


-- Countries with Highest Death Count per Population

SELECT location, MAX(cast(total_deaths as int)) as total_deaths_count
FROM CovidProject..CovidDeaths
Where continent is not null
GROUP BY location
ORDER BY total_deaths_count desc


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as total_deaths_count
FROM CovidProject..CovidDeaths
Where continent is not null
GROUP BY continent
ORDER BY total_deaths_count desc	


-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_percentage
FROM CovidProject..CovidDeaths
WHERE continent is not null 
ORDER BY 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.date) as rollin_people_vaccionated
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3




