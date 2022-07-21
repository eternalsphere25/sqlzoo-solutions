/*
SELECT from WORLD Tutorial
https://sqlzoo.net/wiki/SELECT_from_WORLD_Tutorial
*/

-- 1. Introduction
SELECT name, continent, population
FROM world

-- 2. Large Countries
SELECT name
FROM world
WHERE population >= 200000000

-- 3. Per capita GDP
SELECT name, (gdp/population) AS per_capita_gdp
FROM world
WHERE population >= 200000000

-- 4. South America In Millions
SELECT name, (population/1000000) AS pop_in_millions
FROM world
WHERE continent = 'South America'

-- 5. France, Germany, Italy
SELECT name, population
FROM world
WHERE name IN ('France', 'Germany', 'Italy')

-- 6. United
SELECT name
FROM world
WHERE name LIKE '%United%'

-- 7. Two ways to be big
SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 250000000

-- 8. One or the other (but not both)
SELECT name, population, area
FROM world
WHERE (area > 3000000 OR population > 250000000)
AND (area < 3000000 OR population < 250000000)

-- 9. Rounding
SELECT name, ROUND(population/1000000,2) AS pop_mil, ROUND(gdp/1000000000,2) AS gdp_bil
FROM world
WHERE continent = 'South America'

-- 10. Trillion dollar economies
SELECT name, ROUND(gdp/population,-3) AS per_capita_gdp
FROM world
WHERE gdp >= 1000000000000

-- 11. Name and capital have the same length
SELECT name, capital
FROM world
WHERE LENGTH(name) = LENGTH(capital)

-- 12. Matching name and capital
SELECT name, capital
FROM world
WHERE LEFT(name,1) = LEFT(capital,1)
AND name <> capital

-- 13. All the vowels
SELECT name
FROM world
WHERE name LIKE '%a%'
AND name LIKE '%e%'
AND name LIKE '%i%'
AND name LIKE '%o%'
AND name LIKE '%u%'
AND name NOT LIKE '% %'



/*
SELECT from NOBEL Tutorial
https://sqlzoo.net/wiki/SELECT_from_Nobel_Tutorial
*/

-- 1. Winners from 1950
SELECT *
FROM nobel
WHERE yr = 1950

-- 2. 1962 Literature
SELECT winner
FROM nobel
WHERE yr = 1962
AND subject = 'Literature'

-- 3. Albert Einstein
SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein'

-- 4. Recent Peace Prizes
SELECT winner
FROM nobel
WHERE yr >= 2000
AND subject = 'Peace'

-- 5. Literature in the 1980's
SELECT *
FROM nobel
WHERE subject = 'Literature'
AND yr >= 1980
AND yr <= 1989

-- 6. Only Presidents
SELECT *
FROM nobel
WHERE winner IN ('Theodore Roosevelt', 'Woodrow Wilson', 'Jimmy Carter', 'Barack Obama')

-- 7. John
SELECT winner
FROM nobel
WHERE winner LIKE 'John%'

-- 8. Chemistry and Physics from different years
SELECT yr, subject, winner
FROM nobel
WHERE (subject = 'Physics' AND yr = 1980)
OR (subject = 'Chemistry' AND yr = 1984)

-- 9. Exclude Chemists and Medics
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1980
AND subject NOT IN ('Chemistry'. 'Medicine')

-- 10. Early Medicine, Late Literature
SELECT yr, subject, winner
FROM nobel
WHERE (subject = 'Medicine' AND yr < 1910)
OR (subject = 'Literature' AND yr >= 2004)

-- 11. Umlaut
SELECT *
FROM nobel
WHERE winner = 'Peter Grünberg'

-- 12. Apostrophe
SELECT *
FROM nobel
WHERE winner = 'Eugene O''Neill'

-- 13. Knights of the realm
SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC

-- 14. Chemistry and Physics last



/*
SELECT within SELECT Tutorial
https://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial
*/

-- 1. Bigger than Russia
SELECT name
FROM world
WHERE population > (SELECT population
                    FROM world
                    WHERE name = 'Russia')

-- 2. Richer than UK
SELECT name
FROM world
WHERE (gdp/population) > (SELECT (gdp/population)
                          FROM world
                          WHERE name = 'United Kingdom')
AND continent = 'Europe'

-- 3. Neighbours of Argentina and Australia
SELECT name, continent
FROM world
WHERE continent = (SELECT continent
                   FROM world
                   WHERE name = 'Argentina')
OR continent = (SELECT continent
                FROM world
                WHERE name = 'Australia')
ORDER BY name

-- 4. Between Canada and Poland
SELECT name, population
FROM world
WHERE population > (SELECT population
                    FROM world
                    WHERE name = 'United Kingdom')
AND population < (SELECT population
                  FROM world
                  WHERE name = 'Germany')

-- 5. Percentages of Germany
SELECT name, CONCAT(CAST(ROUND((population/(SELECT population
                                           FROM world
                                           WHERE name = 'Germany')*100),0) AS INT),'%') AS percentage
FROM world
WHERE continent = 'Europe'

-- 6. Bigger than every country in Europe
SELECT name
FROM world
WHERE gdp > ALL(SELECT gdp
                FROM world
                WHERE gdp >= 0
                AND continent = 'Europe')

-- 7. Largest in each continent
SELECT continent, name, area
FROM world x
WHERE area >= ALL(SELECT area
                  FROM world y
                  WHERE y.continent = x.continent
                  AND area >= 0)

-- 8. First country of each continent (alphabetically)
SELECT continent, name
FROM world x
WHERE name <= ALL(SELECT name
                  FROM world y
                  WHERE y.continent = x.continent)

-- 9. Difficult Questions That Utilize Techniques Not Covered In Prior Sections
SELECT name, continent, population
FROM world x
WHERE 25000000 > ALL(SELECT population
                     FROM world y
                     WHERE y.population > 0
                     AND x.continent = y.continent)

-- 10. Three time bigger
SELECT name, continent
FROM world x
WHERE population >= ALL(SELECT (population*3)
                        FROM world y
                        WHERE x.continent = y.continent
                        AND population >0
                        AND x.name <> y.name)