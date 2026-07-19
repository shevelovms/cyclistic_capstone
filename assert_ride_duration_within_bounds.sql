-- tests/assert_ride_duration_within_bounds.sql
--
-- Singular dbt test: fails (returns rows) if any ride in the
-- cleaned model has a duration outside the accepted bounds
-- (> 0 minutes and < 24 hours). This encodes a business rule
-- that a generic not_null/unique/accepted_values test can't
-- express, so it lives as its own query. dbt treats any row
-- returned by this query as a test failure.

SELECT
  ride_id,
  started_at,
  ended_at,
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS duration_minutes
FROM {{ ref('cleaned_cyclistic_data_2024') }}
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) NOT BETWEEN 1 AND 1439
