/*
1: SELECT name
https://sqlzoo.net/wiki/SELECT_from_WORLD_Tutorial
*/

-- 1. Find the country that start with Y
SELECT name
FROM world
WHERE name LIKE 'Y%'

-- 2. Find the countries that end with y
SELECT name
FROM world
WHERE name LIKE '%y'

-- 3. Find the countries that contain the letter x
SELECT name
FROM world
WHERE name LIKE '%x%'

-- 4. Find the countries that end with land
SELECT name
FROM world
WHERE name LIKE '%land'

-- 5. Find the countries that start with C and end with ia
SELECT name
FROM world
WHERE name LIKE 'C%ia'

-- 6. Find the country that has oo in the name
SELECT name
FROM world
WHERE name LIKE '%oo%'

-- 7. Find the countries that have three or more a in the name
SELECT name
FROM world
WHERE name LIKE '%a%a%a%'

-- 8. Find the countries that have "t" as the second character
SELECT name
FROM world
WHERE name LIKE '_t%'
ORDER BY name

-- 9. Find the countries that have two "o" characters separated by two others
SELECT name
FROM world
WHERE name LIKE '%o__o%'

-- 10. Find the countries that have exactly four characters
SELECT name
FROM world
WHERE name LIKE '____'

-- 11. Find the country where the name is the capital city
SELECT name
FROM world
WHERE name = capital

-- 12. Find the country where the capital is the country plus "City"
SELECT name
FROM world
WHERE capital LIKE CONCAT(name, 'City')

-- 13. Find the capital and the name where the capital includes the name of the country
SELECT capital, name
FROM world
WHERE capital LIKE CONCAT(name, '%')

-- 14. Find the capital and the name where the capital is an extension of the name of the country
SELECT capital, name
FROM world
WHERE name <> capital
AND capital LIKE CONCAT(name, '%')

-- 15. Show the name and the extension where the capital is an extension of name of the country
SELECT name, REPLACE(capital, name, '') AS extension
FROM world
WHERE capital LIKE CONCAT(name, '%')
AND capital <> name



/*
2: SELECT from WORLD
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
3: SELECT from NOBEL
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
4: SELECT within SELECT
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



/*
5: SUM and COUNT
https://sqlzoo.net/wiki/SUM_and_COUNT
*/

-- 1. Total world population
SELECT SUM(population)
FROM world

-- 2. List of continents
SELECT DISTINCT(continent)
FROM world

-- 3. GDP of Africa
SELECT SUM(gdp) AS total_gdp_africa
FROM world
WHERE continent = 'Africa'

-- 4. Count the big countries
SELECT COUNT(name)
FROM world
WHERE area >= 1000000

-- 5. Baltic states population
SELECT SUM(population)
FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania')

-- 6. Counting the countries of each continent
SELECT continent, COUNT(name) AS num_of_countries
FROM world
GROUP BY continent

-- 7. Counting big countries in each continent
SELECT continent, COUNT(name)
FROM world
WHERE population >= 10000000
GROUP BY continent

-- 8. Counting big continents
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000



/*
The nobel table can be used to practice more SUM and COUNT functions.
https://sqlzoo.net/wiki/The_nobel_table_can_be_used_to_practice_more_SUM_and_COUNT_functions.
*/

-- 1. Show the total number of prizes awarded
SELECT COUNT(winner)
FROM nobel

-- 2. List each subject - just once
SELECT DISTINCT(subject)
FROM nobel

-- 3. Show the total number of prizes awared for Physics
SELECT COUNT(winner) AS physics_prizes
FROM nobel
WHERE subject = 'Physics'

-- 4. For each subject show the subject and the number of prizes
SELECT subject, COUNT(winner) as num_prizes
FROM nobel
GROUP BY subject
-- ORDER BY num_prizes DESC

-- 5. For each subject show the first year that the prize was awarded
SELECT subject, MIN(yr) AS first_awarded
FROM nobel
GROUP BY subject
-- ORDER BY first_awarded DESC

-- 6. For each subject show the number of prizes awarded in the year 2000
SELECT subject, COUNT(winner) AS num_awarded
FROM nobel
WHERE yr = 2000
GROUP BY subject
-- ORDER BY num_awarded DESC

-- 7. Show the number of different winners for each subject
SELECT subject, COUNT(DISTINCT(winner)) AS num_distinct_winners
FROM nobel
GROUP BY subject

-- 8. For each subject show how many years have had prizes awarded
SELECT subject, COUNT(DISTINCT(yr)) AS num_times_awarded
FROM nobel
GROUP BY subject

-- 9. Show the years in which three prizes were given for Physics
SELECT yr
FROM nobel
WHERE subject = 'Physics'
GROUP BY yr
HAVING COUNT(subject) = 3

-- 10. Show winners who have won more than once
SELECT winner
FROM nobel
GROUP BY winner
HAVING COUNT(yr) >= 2

-- 11. Show winners who have won more than one subject
SELECT winner
FROM nobel
GROUP BY winner
HAVING COUNT(DISTINCT(subject)) >= 2

-- 12. Show the year and subject where 3 prizes were given. Show only years 2000 onwards
SELECT yr, subject
FROM nobel
WHERE yr >= 2000
GROUP BY yr, subject
HAVING COUNT(winner) = 3



/*
6: JOIN
https://sqlzoo.net/wiki/The_JOIN_operation
*/

-- 1.
SELECT matchid, player
FROM goal
WHERE teamid = 'GER'

-- 2.
SELECT id, stadium, team1, team2
FROM game
WHERE id = 1012

-- 3.
SELECT player, teamid, stadium, mdate
FROM game JOIN goal ON (id = matchid)
WHERE teamid = 'GER'

-- 4.
SELECT team1, team2, player
FROM game JOIN goal ON (id = matchid)
WHERE player LIKE 'Mario%'

-- 5.
SELECT player, teamid, coach, gtime
FROM goal JOIN eteam ON (teamid = id)
WHERE gtime <= 10

-- 6.
SELECT mdate, teamname
FROM game JOIN eteam ON (team1 = eteam.id)
WHERE coach = 'Fernando Santos'

-- 7.
SELECT player
FROM goal JOIN game ON (matchid = id)
WHERE stadium = 'National Stadium, Warsaw'

-- 8.
SELECT DISTINCT(player)
FROM goal JOIN game ON (matchid = id)
WHERE (team1 = 'GER' OR team2 = 'GER')
AND teamid <> GER

-- 9.
SELECT teamname, COUNT(player) AS total_goals_scored
FROM eteam JOIN goal ON (id = teamid)
GROUP BY teamname

-- 10.
SELECT stadium, COUNT(matchid) AS num_goals
FROM game JOIN goal ON (id = matchid)
GROUP BY stadium

-- 11.
SELECT matchid.mdate, COUNT(teamid) AS num_goals
FROM game JOIN goal ON (matchid = id)
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid.mdate

-- 12.
SELECT matchid, mdate, COUNT(teamid) as num_goals
FROM goal JOIN game ON (matchid = id)
WHERE teamid = 'GER'
GROUP BY matchid, mdate

-- 13.
SELECT mdate, team1,
    SUM((CASE WHEN teamid=team1 THEN 1 ELSE 0 END)) AS score1,
    team2,
    SUM((CASE WHEN teamid=team2 THEN 1 ELSE 0 END)) AS score2
FROM game LEFT JOIN goal ON (id = matchid)
GROUP BY mdate, team1, team2



/*
7: More JOIN operations
https://sqlzoo.net/wiki/More_JOIN_operations
*/

-- 1. 1962 movies
SELECT id, title
FROM movie
WHERE yr=1962

-- 2. When was Citizen Kane released?
SELECT yr
FROM movie
WHERE title = 'Citizen Kane'

-- 3. Star Trek movies
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr

-- 4. id for actor Glenn Close
SELECT id
FROM actor
WHERE name = 'Glenn Close'

-- 5. id for Casablanca
SELECT id
FROM movie
WHERE title = 'Casablanca'

-- 6. Cast list for Casablanca
SELECT name
FROM actor JOIN casting ON (id = actorid)
WHERE movieid = 11768

SELECT name
FROM actor JOIN casting ON (id = actorid)
WHERE movieid = (SELECT id
                 FROM movie
                 WHERE title = 'Casablanca')

-- 7. Alien cast list
SELECT name
FROM actor JOIN casting ON (id = actorid)
WHERE movieid = (SELECT id
                 FROM movie
                 WHERE title = 'Alien')

-- 8. Harrison Ford movies
SELECT title
FROM movie JOIN casting ON (id = movieid)
WHERE actorid = (SELECT id
                 FROM actor
                 WHERE name = 'Harrison Ford')

-- 9. Harrison Ford as a supporting actor
SELECT title
FROM movie JOIN casting ON (id = movieid)
WHERE actorid = (SELECT id
                 FROM actor
                 WHERE name = 'Harrison Ford')
AND ord <> 1

-- 10. Lead actors in 1962 movies
SELECT title, name
FROM casting
JOIN movie ON (movieid = movie.id)
JOIN actor ON (actorid = actor.id)
WHERE yr = 1962
AND ord = 1

-- 11. Busy years for Rock Hudson
SELECT yr, COUNT(title) AS num_movies
FROM movie
JOIN casting ON (movie.id = movieid)
JOIN actor ON (actor.id = actorid)
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

-- 12. Lead actor in Julie Andrews movies
SELECT title, name
FROM casting
JOIN movie ON (movieid = movie.id)
JOIN actor ON (actorid = actor.id)
WHERE movie.id IN (SELECT movie.id
                   FROM casting
                   JOIN movie ON (movieid = movie.id)
                   JOIN actor ON (actorid = actor.id)
                   WHERE name = 'Julie Andrews')
AND ord = 1

-- 13. Actors with 15 leading roles
SELECT name
FROM casting
JOIN movie ON (movieid = movie.id)
JOIN actor ON (actorid = actor.id)
WHERE ord = 1
GROUP BY name
HAVING COUNT(ord) >= 15

-- 14. released in the year 1978
SELECT title, COUNT(actorid) AS num_actors
FROM casting
JOIN movie ON (movieid = movie.id)
WHERE yr = 1978
GROUP BY title
ORDER BY num_actors DESC, title

-- 15. with 'Art Garfunkel'
SELECT DISTINCT(name)
FROM casting JOIN actor ON (actorid = actor.id)
WHERE movieid IN (SELECT movieid
                  FROM casting JOIN actor ON (actorid = actor.id)
                  WHERE name = 'Art Garfunkel')
AND name <> 'Art Garfunkel'



/*
8: Using NULL
https://sqlzoo.net/wiki/Using_Null
*/

-- 1. List the teachers who have NULL for their department
SELECT name
FROM teacher
WHERE dept IS NULL

-- 2. Note the INNER JOIN misses the teachers with no department and the departments with no teacher
SELECT teacher.name, dept.name
FROM teacher INNER JOIN dept ON (teacher.dept = dept.id)

-- 3. Use a different JOIN so that all teachers are listed
SELECT teacher.name, dept.name
FROM teacher LEFT JOIN dept ON (teacher.dept = dept.id)

-- 4. Use a different JOIN so that all departments are listed
SELECT teacher.name, dept.name
FROM teacher RIGHT JOIN dept ON (teacher.dept = dept.id)

-- 5. Use COALESCE to print the mobile number. Use the number '07986 444 2266' if there is no number given.
SELECT name, COALESCE(mobile, '07986 444 2266')
FROM teacher

-- 6. Use the COALESCE function and a LEFT JOIN to print the teacher name and deparmtent name. Use the string 'None' when there is no department
SELECT teacher.name, COALESCE(dept.name, 'None')
FROM teacher LEFT JOIN dept ON (teacher.dept = dept.id)

-- 7. Use COUNT to show the number of teachers and the number of mobile phones
SELECT COUNT(teacher.name) AS num_teachers, COUNT(mobile) AS num_mobiles
FROM teacher

-- 8. Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the ENgineering department is listed
SELECT dept.name AS department, COUNT(teacher.dept) AS num_staff
FROM teacher RIGHT JOIN dept ON (teacher.dept = dept.id)
GROUP BY department

-- 9. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise
SELECT name, CASE 
WHEN dept = 1 THEN 'Sci'
WHEN dept = 2 THEN 'Sci'
ELSE 'Art' END AS subject
FROM teacher

-- 10. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise
SELECT name, CASE
WHEN dept = 1 THEN 'Sci'
WHEN dept = 2 THEN 'Sci'
WHEN dept = 3 THEN 'Art'
ELSE 'None' END AS subject
FROM teacher



/*
9: Self join
https://sqlzoo.net/wiki/Self_join
*/

-- 1. How many stops are in the database
SELECT COUNT(id) AS num_stops
FROM stops

-- 2. Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name = 'Craiglockhart'

-- 3. Give the id and name for the stops on the '4' 'LRT' service
SELECT id, name
FROM stops JOIN route ON (id = stop)
WHERE num = 4 AND company = 'LRT'
ORDER BY pos

-- 4. Add a HAVING clause to restrict the output to these two routes
SELECT company, num, COUNT(*)
FROM route WHERE stop = 149 OR stop = 53
GROUP BY company, num
HAVING COUNT(*) = 2

-- 5. Change the query so that it shows the services from Craiglockhart to London Road
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
WHERE a.stop = 53 AND b.stop = (SELECT id
                                FROM stops
                                WHERE name = 'London Road')

-- 6. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stopb = stopb.id)
WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'London Road'

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT(a.company), a.num
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop - stopb.id)
WHERE stopa.name = 'Haymarket' AND stopb.name = 'Leith'

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT a.company, a.num
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop - stopb.id)
WHERE stop1.name = 'Craiglockhart' AND stop2.name = 'Tollcross'

-- 9. Give a distinct list of the stops which may be reacher from 'Craiglockhart' by taking the bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services
SELECT stop2.name, a.company, a.num
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop - stopb.id)
WHERE stop1.name = 'Craiglockhart' AND a.company = 'LRT'

-- 10. Find the routes involving two buses that can go from Craiglockhart to Lochend. Show the bus no. and copmany for the first bus, the name of hte stop for the transfer, and the bus no and company for the second bus
SELECT initial.num, initial.company, initial.transfer, final.num, final.company
FROM (SELECT DISTINCT(a.num, a.company, stop1.name AS start, stop2.name AS 
      transfer)
      FROM route a JOIN route b ON (a.num = b.num AND a.company = b.company)
      JOIN stops stop1 ON (stop1.id = a.stop)
      JOIN stops stop2 ON (stop2.id = b.stop)
      WHERE stop1.name = 'Craiglockhart' AND stop2.name <> 'Craiglockhart')
      AS initial
JOIN (SELECT DISTINCT(c.num, c.company, stop3.name AS start, stop4.name AS 
      transfer)
      FROM route c JOIN route d ON (c.num = d.num AND c.company = d.company)
      JOIN stops stop3 ON (stop3.id = c.stop)
      JOIN stops stop4 ON (stop4.id = d.stop)
      WHERE stop3.name = 'Lochend' AND stop2.name <> 'Lochend')
      AS final
ON (initial.transfer = final.transfer)
ORDER BY initial.num, initial.transfer