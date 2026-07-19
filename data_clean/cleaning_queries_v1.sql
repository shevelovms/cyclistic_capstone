/*
Data import begins here.
*/


-- Loading data (.CSV) files from Google Cloud Storage into the "cyclistic_data_2024" BigQuery table:
LOAD DATA INTO `civil-glyph-451218-p0.cyclistic_data_2024.cyclistic_data_2024`
FROM FILES (
  format = 'CSV',
  uris = ['gs://cyclistic-2025/*.csv']
);


-- Previewing the first 10 rows of the imported dataset for a quick inspection:
SELECT
  *
FROM
  `cyclistic_data_2024.cyclistic_data_2024`
LIMIT 10;


/*
Data import ends here.
Data cleaning begins here.
*/


-- Removing duplicates rows from the data and saving the cleaned data into a new table:
CREATE OR REPLACE TABLE `cyclistic_data_2024.cleaned_cyclistic_data_2024` AS
  SELECT DISTINCT *
  FROM `cyclistic_data_2024.cyclistic_data_2024`;


-- Counting rows with missing timestamps (nullable values) across both the "started_at" and "ended_at" fields and labeling the data under the "total_null_timestamps" field:
SELECT
  COUNT(*) AS total_null_timestamps
FROM `cyclistic_data_2024.cleaned_cyclistic_data_2024`
WHERE
  started_at IS NULL OR ended_at IS NULL;
  -- The result is 0 instances. Proceeding to the next step of cleaning data.


-- Counting negative/nullable ride durations (in minutes) across both the "started_at" and "ended_at" fields and labeling the data under the "negative_or_zero_durations" field:
SELECT
  COUNT(*) AS negative_or_zero_durations
FROM `cyclistic_data_2024.cleaned_cyclistic_data_2024`
WHERE
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 0;
-- The result is 131530 instances. Proceeding to removing this data.


-- Deleting the negative/nullable ride durations:
DELETE FROM `cyclistic_data_2024.cleaned_cyclistic_data_2024`
WHERE
 TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 0;


-- Ensuring the data deletion of the negative/nullable ride durations (<= 0 minutes) was successfull: 
SELECT
  COUNT(*)
FROM
  `cyclistic_data_2024.cleaned_cyclistic_data_2024`
WHERE
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 0;
-- The result is 0. Proceeding to the next step of cleaning data.


-- Counting the number of long rides (>= 24 hrs.) for each group (member vs. casual):
SELECT
  member_casual,
  COUNT(*) AS ride_count
FROM
  `cyclistic_data_2024.cleaned_cyclistic_data_2024`
WHERE
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1440
GROUP BY member_casual;
-- Identified 7,596 such rides. Evaluating the trustworthiness of the data.


-- Deleting long rides (>= 24 hrs.) having made a decision to consider the data "non-reliable/non-realistic":
DELETE FROM `cyclistic_data_2024.cleaned_cyclistic_data_2024`
WHERE
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1440


-- Ensuring the data deletion of the long rides (>= 24 hrs.) was successfull:
SELECT
  COUNT(*)
FROM
  `cyclistic_data_2024.cleaned_cyclistic_data_2024`
WHERE
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1440
-- Deletion of the 7,596 rows is successfull. Proceeding to analyzing the data to answer the question.


/*
Data cleaning ends here.
Data analysis begins here.
*/


-- Given the type of data available for exploration, I will attempt to find out the difference between the two most obvious variables that come to my mind - trip duration and ride frequency of each of the groups and how they compare to each other.


-- Calculating the average trip duration (in minutes) per group on a monthly level and labeling under the "average_trip_duration_min" field: 
SELECT
  member_casual,
  EXTRACT(MONTH FROM started_at) AS ride_month,
  AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)) AS average_trip_duration_min
FROM
   `cyclistic_data_2024.cleaned_cyclistic_data_2024`
GROUP BY member_casual, ride_month
ORDER BY member_casual, ride_month;


--Calculating the average rides per group on a monthly level and labeling under the "average_monthly_rides" field:
SELECT
  member_casual,
  EXTRACT(MONTH FROM started_at) AS ride_month,
  COUNT(*) AS total_rides
FROM
  `cyclistic_data_2024.cleaned_cyclistic_data_2024`
GROUP BY member_casual, ride_month
ORDER BY member_casual, ride_month;


/*
Data analysis ends here.
*/
