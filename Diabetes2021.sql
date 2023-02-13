-- Create a new database called 'DiabetesData2021'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'DiabetesData2021'
)
CREATE DATABASE DiabetesData2021
GO

--CHECKING IF DATA IS IMPORTED CORRECTLY IN ALL THE TABLES

SELECT *
FROM DiabetesData2021..[deaths-attributable-to-diabetes]

SELECT *
FROM DiabetesData2021..[new-cases-of-type-1-diabetes-0-19-y]

SELECT *
FROM DiabetesData2021..[people-with-diabetes]

SELECT *
FROM DiabetesData2021..[people-with-undiagnosed-diabetes]

SELECT *
FROM DiabetesData2021..[population-of-children-and-adolescents-0-19-y]

SELECT *
FROM DiabetesData2021..[total-adult-population-20-79-y]


--RANKING REGION BY NUMBER OF PEOPLE WITH DIABETES FROM HIGHEST TO LOWEST IN 2021
SELECT Region , people_with_diabetes
FROM DiabetesData2021..[people-with-diabetes]
WHERE [Type] like '%region'
ORDER BY people_with_diabetes DESC


--RANKING COUNTRY BY NUMBER OF PEOPLE OF PEOPLE WITH DIABETES FROM HIGHEST TO LOWEST IN 2021
SELECT Country_Territory, people_with_diabetes
FROM DiabetesData2021..[people-with-diabetes]
WHERE [Type] like '%Country%'
ORDER BY people_with_diabetes DESC



--RANKING OF PERCENTAGE OF CHILDREN AND ADOLESCENT POPULATION (0-19 YEARS) WITH TYPE 1 DIABETES IN 2021 BY REGION (HIGHEST TO LOWEST)
SELECT pop19.Region ,pop19.population ,new19.new_cases,pop19.Type,100*new_cases/population as Percentageofchildrenwithtype1diabetes
FROM DiabetesData2021..[population-of-children-and-adolescents-0-19-y] pop19
JOIN DiabetesData2021..[new-cases-of-type-1-diabetes-0-19-y] new19
on pop19.REGION = new19.REGION
and pop19.Country_Territory = new19.Country_Territory
WHERE pop19.Type like '%Region%'
ORDER BY Percentageofchildrenwithtype1diabetes DESC


--RANKING OF PERCENTAGE OF CHILDREN AND ADOLESCENT POPULATION (0-19 YEARS) WITH TYPE 1 DIABETES IN 2021 BY COUNTRY (HIGHEST TO LOWEST)
SELECT pop19.Country_Territory ,pop19.population ,new19.new_cases,pop19.Type,100*new_cases/population as Percentageofchildrenwithtype1diabetes
FROM DiabetesData2021..[population-of-children-and-adolescents-0-19-y] pop19
JOIN DiabetesData2021..[new-cases-of-type-1-diabetes-0-19-y] new19
on pop19.REGION = new19.REGION
and pop19.Country_Territory = new19.Country_Territory
WHERE pop19.Type like '%Country%'
ORDER BY Percentageofchildrenwithtype1diabetes DESC


--RANKING DEATHS ATTRIBUTABLE TO DIABETES (HIGHEST TO LOWEST) BY REGION IN 2021
SELECT Region , numberofdeaths, Type 
FROM DiabetesData2021..[deaths-attributable-to-diabetes]
WHERE Type like '%Region%'
ORDER BY numberofdeaths DESC


--RANKING DEATHS ATTRIBUTABLE TO DIABETES (HIGHEST TO LOWEST) BY COUNTRY IN 2021
SELECT Country_Territory , numberofdeaths, Type 
FROM DiabetesData2021..[deaths-attributable-to-diabetes]
WHERE Type like '%Country%'
ORDER BY numberofdeaths DESC

--PERCENTAGE OF ADULT POPULATION (20-79 YEARS) WHOSE DEATH WAS ATTRIBUTABLE TO DIABETES BY REGION IN 2021
SELECT dea.Region , numberofdeaths ,population , 100.0*numberofdeaths/population AS PercentageofAdultDeathsDueToDiabetes , pop20.Type
FROM DiabetesData2021..[total-adult-population-20-79-y] pop20
JOIN DiabetesData2021..[deaths-attributable-to-diabetes] dea
ON pop20.Region = dea.Region
AND pop20.Type = dea.Type
WHERE dea.Type like '%Region%'
ORDER BY PercentageofAdultDeathsDueToDiabetes DESC




--RANKING OF PEOPLE WITH UNDIAGNOSED DIABETES BY REGION IN 2021
SELECT Region,people_with_undiagnosed_diabetes,Type
FROM DiabetesData2021..[people-with-undiagnosed-diabetes]
WHERE Type like '%Region%'
ORDER BY people_with_undiagnosed_diabetes DESC 

--RANKING OF PEOPLE WITH UNDIAGNOSED DIABETES BY COUNTRY IN 2021
SELECT Country_Territory,people_with_undiagnosed_diabetes,Type
FROM DiabetesData2021..[people-with-undiagnosed-diabetes]
WHERE Type like '%Country%'
ORDER BY people_with_undiagnosed_diabetes DESC 


--PERCENTAGE OF CHILDREN AND ADOLESCENT (0-19 YEARS) WHOSE DEATH WAS ATTRIBUTABLE TO DIABETES BY REGION IN 2021
SELECT dea.Region , numberofdeaths ,population , 100.0*numberofdeaths/population AS PercentageofChildrenDeathsDueToDiabetes , pop19.Type
FROM DiabetesData2021.. [population-of-children-and-adolescents-0-19-y] pop19
JOIN DiabetesData2021..[deaths-attributable-to-diabetes] dea
ON pop19.Region = dea.Region
AND pop19.Type = dea.Type
WHERE dea.Type like '%Region%'
ORDER BY PercentageofChildrenDeathsDueToDiabetes DESC

--PERCENTAGE OF CHILDREN AND ADOLESCENT (0-19 YEARS) WHOSE DEATH WAS ATTRIBUTABLE TO DIABETES BY COUNTRY IN 2021
SELECT dea.Country_Territory , numberofdeaths ,population , 100*numberofdeaths/population AS PercentageofChildrenDeathsDueToDiabetes , pop19.Type
FROM DiabetesData2021.. [population-of-children-and-adolescents-0-19-y] pop19
JOIN DiabetesData2021..[deaths-attributable-to-diabetes] dea
ON pop19.Region = dea.Region
AND pop19.Type = dea.Type
WHERE dea.Type like '%Country%'
ORDER BY PercentageofChildrenDeathsDueToDiabetes DESC


--Creating views for later visualization

--Percentageofchildrenwithtype1diabetes by country
Create view Percentageofchildrenwithtype1diabetes AS
SELECT pop19.Country_Territory ,pop19.population ,new19.new_cases,pop19.Type,100*new_cases/population as Percentageofchildrenwithtype1diabetes
FROM DiabetesData2021..[population-of-children-and-adolescents-0-19-y] pop19
JOIN DiabetesData2021..[new-cases-of-type-1-diabetes-0-19-y] new19
on pop19.REGION = new19.REGION
and pop19.Country_Territory = new19.Country_Territory
WHERE pop19.Type like '%Country%'
--ORDER BY Percentageofchildrenwithtype1diabetes DESC

--Peoplewithdiabetes by region
Create view people_with_diabetes AS
SELECT Region , people_with_diabetes
FROM DiabetesData2021..[people-with-diabetes]
WHERE [Type] like '%region'
--ORDER BY people_with_diabetes DESC

--Numberofdeaths by country
Create view numberofdeaths AS
SELECT Country_Territory , numberofdeaths, Type 
FROM DiabetesData2021..[deaths-attributable-to-diabetes]
WHERE Type like '%Country%'
--ORDER BY numberofdeaths DESC

--PercentageofAdultDeathsDueToDiabetes by region
Create view PercentageofAdultDeathsDueToDiabetes AS
SELECT dea.Region , numberofdeaths ,population , 100.0*numberofdeaths/population AS PercentageofAdultDeathsDueToDiabetes , pop20.Type
FROM DiabetesData2021..[total-adult-population-20-79-y] pop20
JOIN DiabetesData2021..[deaths-attributable-to-diabetes] dea
ON pop20.Region = dea.Region
AND pop20.Type = dea.Type
WHERE dea.Type like '%Region%'
--ORDER BY PercentageofAdultDeathsDueToDiabetes DESC

--people_with_undiagnosed_diabetes by country
Create view people_with_undiagnosed_diabetes AS
SELECT Country_Territory,people_with_undiagnosed_diabetes,Type
FROM DiabetesData2021..[people-with-undiagnosed-diabetes]
WHERE Type like '%Country%'
--ORDER BY people_with_undiagnosed_diabetes DESC 

--PercentageofChildrenDeathsDueToDiabetes by region
Create view PercentageofChildrenDeathsDueToDiabetes AS
SELECT dea.Region , numberofdeaths ,population , 100.0*numberofdeaths/population AS PercentageofChildrenDeathsDueToDiabetes , pop19.Type
FROM DiabetesData2021.. [population-of-children-and-adolescents-0-19-y] pop19
JOIN DiabetesData2021..[deaths-attributable-to-diabetes] dea
ON pop19.Region = dea.Region
AND pop19.Type = dea.Type
WHERE dea.Type like '%Region%'
--ORDER BY PercentageofChildrenDeathsDueToDiabetes DESC