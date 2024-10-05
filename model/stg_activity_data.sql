SELECT 
  ORGANIZATION_ID,
  ACTIVITY_NAME,
  ACTIVITY_DETAIL,
  TIMESTAMP
FROM
  `softonicdatalake.dbt_rhoang.ae_test`

WHERE timestamp >= '2024-01-01' AND timestamp < '2024-04-01';

-- include timestamp to isolate data outside of Jan to Mar 
-- There seem to be ALOT of duplicate data (even the timestamp is exactly the same).
-- Can remove data by running DISTINCT: but in this case, will leave in data until confirmed by business. 
