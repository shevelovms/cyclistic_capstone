/*
====================================================================
Cyclistic 2024 Bike-Share Data Cleaning
Refactored version — declarative cleaning + primary-key dedup
====================================================================
*/


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
SELECT *
FROM `cyclistic_data_2024.cyclistic_data_2024`
LIMIT 10;

/*
Data import ends here.
Data cleaning begins here.
====================================================================
This entire cleaning step is expressed as ONE declarative
CREATE OR REPLACE TABLE AS SELECT statement rather than a sequence
of destructive DELETEs. This makes the cleaning logic:
  - fully auditable (every rule is visible in one place)
  - rebuildable from raw data at any time
  - dbt-model-ready (this SELECT could become a staging model as-is)

Cleaning rules applied:
  1. Dedup on primary key (ride_id), not full-row equality, using
     QUALIFY ROW_NUMBER() ... = 1. Full-row DISTINCT would miss
     duplicate ride_ids that differ by even one field (e.g. from
     re-ingested/reprocessed exports).
  2. Drop rows with NULL started_at / ended_at.
  3. Drop rows with non-positive ride duration (<= 0 minutes).
  4. Drop rows with unrealistic ride duration (>= 24 hrs / 1440 min).
====================================================================
*/

CREATE OR REPLACE TABLE `cyclistic_data_2024.cleaned_cyclistic_data_2024` AS
SELECT *
FROM `cyclistic_data_2024.cyclistic_data_2024`
WHERE started_at IS NOT NULL
  AND ended_at IS NOT NULL
  AND TIMESTAMP_DIFF(ended_at, started_at, MINUTE) BETWEEN 1 AND 1439
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY ride_id
  ORDER BY started_at
) = 1;

-- Audit check: confirm no null timestamps remain
SELECT COUNT(*) AS total_null_timestamps
FROM `cyclistic_data_2024.cleaned_cyclistic_data_2024`
WHERE started_at IS NULL OR ended_at IS NULL;
-- Expected: 0

-- Audit check: confirm no non-positive or >=24hr durations remain
SELECT COUNT(*) AS out_of_bounds_durations
FROM `cyclistic_data_2024.cleaned_cyclistic_data_2024`
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) NOT BETWEEN 1 AND 1439;
-- Expected: 0

-- Audit check: confirm ride_id is now unique (dedup worked)
SELECT COUNT(*) AS duplicate_ride_ids
FROM (
  SELECT ride_id, COUNT(*) AS cnt
  FROM `cyclistic_data_2024.cleaned_cyclistic_data_2024`
  GROUP BY ride_id
  HAVING cnt > 1
);
-- Expected: 0

/*
Data cleaning ends here.
Data analysis begins here.
====================================================================
Combined into a single pass over the cleaned table instead of two
separate SELECTs, to avoid scanning (and being billed for) the same
data twice for two closely related aggregates.
====================================================================
*/

SELECT
  member_casual,
  EXTRACT(MONTH FROM started_at) AS ride_month,
  AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)) AS average_trip_duration_min,
  COUNT(*) AS total_rides
FROM `cyclistic_data_2024.cleaned_cyclistic_data_2024`
GROUP BY member_casual, ride_month
ORDER BY member_casual, ride_month;

/*
Data analysis ends here.
*/
