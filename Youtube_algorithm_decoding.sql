-- Language analysis

use kulturehire;
SELECT `Language of the Video` AS Language,Round(AVG(`Video Views`),0) AS video_views
FROM youtube
WHERE `Language of the Video` IN('English','Hindi','Malayalam','Telugu','Tamil')
GROUP BY 1
ORDER BY 2 DESC;

-- Video quality analysis

SELECT `Maximum Quality of the Video` AS Video_quality, ROUND(AVG(`Video Views`),0) AS Video_views
FROM youtube
GROUP BY 1
ORDER BY 2 DESC;

-- Premiered video Analysis

SELECT `Premiered or Not` AS Premiered,ROUND(AVG(`Video Views`),0) AS Video_views
FROM youtube
GROUP BY 1
ORDER BY 2 DESC;

-- Hashtag analysis

SELECT Hashtags, ROUND(AVG(`Video Views`),0) AS Video_views
FROM youtube
WHERE Hashtags<=25
GROUP By 1
ORDER BY 2 DESC;

-- Creator category analysis

SELECT `Creator Gender`,ROUND(AVG(`Video Views`),0) AS video_views 
FROM youtube
WHERE `Creator Gender` IN ('Male','Female','Company')
GROUP BY 1
ORDER BY 2 DESC;

-- Video duration analysis

WITH duration_CTE AS
(
SELECT
CASE WHEN `Duration in Seconds` <60 THEN '<1 Min'
	 WHEN `Duration in Seconds` BETWEEN 61 AND 300 THEN '1 - 5 Min'
     WHEN `Duration in Seconds` BETWEEN 301 AND 660 THEN '6 - 11 Min'
     WHEN `Duration in Seconds` BETWEEN 661 AND 960 THEN '12 - 16 Min'
     WHEN `Duration in Seconds` BETWEEN 961 AND 1260 THEN '17 - 21 Min'
     WHEN `Duration in Seconds` BETWEEN 1261 AND 1560 THEN '22 - 26 Min'
     WHEN `Duration in Seconds` BETWEEN 1561 AND 1860 THEN '27 -31 Min'
     WHEN `Duration in Seconds` BETWEEN 1861 AND 2160 THEN '32 - 36 Min'
     WHEN `Duration in Seconds` BETWEEN 2161 AND 2460 THEN '37 - 41 Min'
     WHEN `Duration in Seconds` BETWEEN 2461 AND 2760 THEN '42 - 46 Min'
ELSE 'NA' END AS Duration,`Video Views`
FROM youtube
)
SELECT Duration, ROUND(AVG(`Video Views`),0) AS Video_view
FROM duration_CTE
WHERE duration <> 'NA'
GROUP BY 1
ORDER By 2 DESC;

-- Yearwise views analysis

WITH year_CTE AS
(
SELECT RIGHT(`Date of Video Upload`,4) AS year, `Video Views` 
FROM youtube
)
SELECT year, ROUND(AVG(`Video Views`),0) AS video_views
FROM year_CTE
WHERE year<=2022
GROUP BY 1
ORDER By 1;





