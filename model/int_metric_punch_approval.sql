CREATE OR REPLACE TABLE dbt_rhoang.int_metric_punch_approval AS
SELECT
  organization_id,
  ACTIVITY_NAME,
  timestamp,
  1 AS activity_cnt,
  date(timestamp) AS event_date,
  time(timestamp) AS event_time_utc,
  ROW_NUMBER() OVER (PARTITION BY organization_id ORDER BY TIMESTAMP) AS event_order_occurance

FROM `softonicdatalake.dbt_rhoang.stg_activity_data`
WHERE activity_name = 'PunchClock.Approvals.EntryApproved' ;
