CREATE SCHEMA khdataprep;
use khdataprep;

-- call stored procedure for select all statement
call get_all();

-- cleaning data with sql
-- To remove null in communiity engagement 
UPDATE youtube_uncleaned
SET `Community Engagement (Posts per week)`=0
WHERE `Community Engagement (Posts per week)`='None';

-- to remove p in video quality column
UPDATE youtube_uncleaned
SET `Maximum Quality of the Video` = TRIM('p' FROM `Maximum Quality of the Video`);

-- video description as 'yes' or 'no' 
UPDATE youtube_uncleaned
SET `Video Description` = CASE WHEN `Video Description`='None' THEN 'No'
                               ELSE 'Yes' END;
                               
-- add column no.of hashtags
ALTER TABLE youtube_uncleaned
ADD COLUMN no_of_hashtag INT;   

--  no.of hashtag update
UPDATE youtube_uncleaned
SET no_of_hashtag = length(Hashtags)-length(replace(Hashtags,"#",""));  

-- clean creator gender fill blanks with company
UPDATE youtube_uncleaned
SET `Creator Gender`='Company'
WHERE `Creator Gender` = ""; 

-- clean date of video upload table     
UPDATE youtube_uncleaned
SET `Date of Video Upload`= REPLACE(`Date of Video Upload`,"/","-");   

ALTER TABLE youtube_uncleaned
ADD COLUMN date_cleaned DATE; 

UPDATE youtube_uncleaned
SET date_cleaned = concat(right(`Date of Video Upload`,4),"-",substring(`Date of Video Upload`,4,2),"-",left(`Date of Video Upload`,2));             
							
ALTER TABLE youtube_uncleaned
ADD COLUMN date_comment_cleaned DATE; 

UPDATE youtube_uncleaned
SET `Date of the Last Comment`=REPLACE(`Date of the Last Comment`,"D","DAY");

UPDATE youtube_uncleaned
SET `Date of the Last Comment`=REPLACE(`Date of the Last Comment`,"W","WEEK");

UPDATE youtube_uncleaned
SET date_comment_cleaned = date_cleaned;
-- Clean date update days
UPDATE youtube_uncleaned
SET date_comment_cleaned = date_comment_cleaned + INTERVAL LEFT(`Date of the Last Comment`,1) DAY 
WHERE `Date of the Last Comment` LIKE '%DAY%';
-- clean date update weeks
UPDATE youtube_uncleaned
SET date_comment_cleaned = date_comment_cleaned + INTERVAL LEFT(`Date of the Last Comment`,1) WEEK 
WHERE `Date of the Last Comment` LIKE '%WEEK%';

-- clean no.of playlist column
UPDATE youtube_uncleaned 
SET `No of Playlist` = 0
WHERE `No of Playlist`='None';

-- Split table
CREATE TABLE comments_table AS
SELECT `No of Comments`,date_comment_cleaned,`Community Engagement (Posts per week)`
FROM youtube_uncleaned;

CREATE TABLE channel_table AS
SELECT `Channel URL`,`Creator Name`,`Creator Gender`,`Total Channel Subcribers`
FROM youtube_uncleaned;

CREATE TABLE video_table AS
SELECT `Video Title`,`Video Link`,`Total Chanel Views`,`Duration of Video`,date_upload_cleaned,`No of Likes`,Subtitle,`Video Description`,no_of_hashtag,`Maximum Quality of the Video`,`No of Videos the Channel`,`No of Playlist`,`Premiered or Not`
FROM youtube_uncleaned;