CREATE TABLE Apple_Description_Combined AS

SELECT *
FROM appleStore_description1

UNION ALL

SELECT *
FROM appleStore_description2

UNION ALL

SELECT *
FROM appleStore_description3


UNION ALL

SELECT *
FROM appleStore_description4

**EXPLORATORY DATA ANALYSIS**.
--Check the number of unique Apps in both Tablesappstore
SELECT COUNT(DISTINCT ID) AS UniqueAppsIds
from applestore

SELECT COUNT(DISTINCT ID) AS UniqueAppsIds
from Apple_Description_Combined

--Check for any missing values in Key FieldsApplestore
SELECT COUNT(*) as MissingValues
from AppleStore
where track_name is NULL or user_rating is null or prime_genre is NULL

SELECT COUNT(*) as MissingValues
from Apple_Description_Combined
where app_desc is null

--Find out the number of apps per genre
SELECT prime_genre,COUNT(*) as sumapps
from AppleStore
group by prime_genre
ORDER BY sumapps DESC

--Overview of the apps ratings
select min(user_rating) as Min_Rating,
       max(user_rating) AS Max_Rating,
       avg(user_rating) as Avg_Rating
FROM AppleStore


**DATA ANALYSIS**

--Determine whether Paid Apps have higher ratings than Free Apps.

SELECT CASE
       WHEN price > 0 THEN 'Paid'
       ELSE 'Free'
       END AS App_Type,
       Avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type

--Check If app with more supported language have higher ratings?

SELECT CASE
       WHEN lang_num < 10 THEN '<10 Languages'
       WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Languages'
       ELSE '>30 Languages'
       end as Language_Bucket,
  Avg(user_rating) AS Avg_Rating
  FROM AppleStore
  GROUP BY Language_Bucket
  ORDER BY Avg_Rating DESC

--Check Genres with low ratings?

SELECT prime_genre,
       Avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
Order By Avg_Rating ASC
LIMIT 10

--Check to see if there is correlation between the length of the app description and the user rating?

SELECT CASE
       WHEN Length(B.app_desc) < 500 THEN 'Short'
       WHEN Length(B.app_desc) Between 500 and 1000 then 'Medium'
       ELSE 'Long'
       END AS Description_Length_Bucket,
       Avg(A.user_rating) AS Average_Rating
FROM AppleStore as A
JOIN Apple_Description_Combined AS B
ON A.ID = B.ID
GROUP BY Description_Length_Bucket
ORDER BY Average_Rating DESC

--Check the Top-Rated Apps for each genre.

SELECT prime_genre,track_name,user_rating
FROM   (
        SELECT
        prime_genre,track_name,user_rating,
        RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC,rating_count_tot DESC) AS RANK
        FROM AppleStore
        ) AS A
where A.rank = 1

