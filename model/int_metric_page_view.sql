CREATE OR REPLACE TABLE dbt_rhoang.int_metric_page_view AS
SELECT
  organization_id,
  activity_name,
  activity_detail,
  timestamp,
  1 AS activity_cnt,
  date(timestamp) AS event_date,
  time(timestamp) AS event_time_utc,
  ROW_NUMBER() OVER (PARTITION BY organization_id ORDER BY TIMESTAMP) AS event_order_occurance, 
  DENSE_RANK() OVER (PARTITION BY organization_id,activity_detail order by timestamp) as feature_occurance_order

FROM `softonicdatalake.dbt_rhoang.stg_activity_data`
WHERE activity_name = 'Page.Viewed';