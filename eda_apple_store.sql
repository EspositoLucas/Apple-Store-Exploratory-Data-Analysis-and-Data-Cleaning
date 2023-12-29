-- 1) Combine all appappleStore_description datasets in a single only dataset in order to work in with the data

create table appleStore_description_combined as 
select * from appleStore_description1
union ALL
select * from appleStore_description2
union all
select * from appleStore_description3
union all
select * from appleStore_description4

select * from appleStore_description_combined

**EXPLORATORY DATA ANALYSIS **

-- check the number of unique apps in both tableAppleStore

select count(DISTINCT id) as UniqueAppIds
from appleStore_description_combined 

select count(DISTINCT id) as UniqueAppIds
from AppleStore 


-- check for any missing values in key fields

SELECT count(*) as MissingValues
from AppleStore 
where track_name is null OR user_rating IS NULL or prime_genre is null 

SELECT count(*) as MissingValues
from appleStore_description_combined adc
where adc.app_desc is null


-- Find out the number of apps per genre

select count(aps.id) as number_of_apps, aps.prime_genre
from AppleStore aps
group by aps.prime_genre
order by 1 desc


-- Get an overview of the apps' rating

SELECT min(aps.user_rating) as min_rating, max(aps.user_rating) as max_rating ,avg(aps.user_rating) as avg_rating
from AppleStore aps


--Get the distribution of app prices

SELECT (price / 2) *2 AS PriceBinStart,((price / 2) * 2) + 2 AS PriceBinEnd, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY PriceBinStart
ORDER BY PriceBinStart 



**DATA ANALYSIS**

--Determine whether paid apps have higher ratings than free apps

SELECT case 
			when aps.price > 0 then 'Paid'
            else 'Free'
        end as app_type,
      	avg(aps.user_rating) avg_rating
from AppleStore aps
group by app_type


--Check if apps with more supported languages have higher ratings

select CASE
			when aps.lang_num < 10 then '< 10 languages'
            when aps.lang_num BETWEEN 10 and 30 then '10-30 languages'
            else '> 30 languages'
        end as languages_support,
        avg(aps.user_rating) avg_rating
from AppleStore aps
group by languages_support
order by 2 desc


--Check genre with low ratings

SELECT aps.prime_genre, avg(aps.user_rating) as avg_rating
from AppleStore aps
group by aps.prime_genre
order by 2
limit 10


-- Check if there is correlation between the length of the app description and the user rating

SELECT case 
			when length(adc.app_desc) < 500 then 'Shorth'
            When length(adc.app_desc) between 100 and 500 then 'Medium'
            else 'Long'
       end as app_length, 
		avg(aps.user_rating) avg_rating
from AppleStore aps
join appleStore_description_combined adc on aps.id = adc.id
group by app_length
order by 2 desc


--Check the top-rated apps for each genre

SELECT prime_genre, track_name, user_rating
FROM (
	SELECT prime_genre,track_name,user_rating, RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) as rank
	FROM AppleStore
) AS aps
WHERE aps.rank = 1



**Conclusions**

--1. PAID APPS HAVE BETTER RATINGS
--2. APPS SUPPORTING BETWEEN 10 AND 30 LANGUAGES HAVE BETTER RATINGS
--3. FINANCE AND BOOK APPS HAVE LOW RATINGS
--4. APPS WITH A LONGER DESCRIPTION HAVE BETTER RATINGS
--5. A NEW APP SHOULD AIM FOR AN AVERAGE RATING ABOVE 3.5
--6. GAMES AND ENTERTEINMENT HAVE HIGH COMPETITION


