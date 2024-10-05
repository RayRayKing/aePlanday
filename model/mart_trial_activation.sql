CREATE OR REPLACE TABLE dbt_rhoang.mart_trial_activation AS (

SELECT
  organization_id,
  CASE WHEN
    shift_created is not null
      AND employees_invited is not null
      AND punched_in is not null
      AND punch_approval is not null
      AND advanced_features is not null
    THEN TRUE ELSE FALSE END AS trial_activation_status,
  CASE WHEN
    shift_created is not null
      AND employees_invited is not null
      AND punched_in is not null
      AND punch_approval is not null
      AND advanced_features is not null
    THEN GREATEST(
      shift_created.activation_date,
      employees_invited.activation_date,
      punched_in.activation_date,
      punch_approval.activation_date,
      advanced_features.activation_date)
    ELSE NULL END AS trial_activation_date,
  CASE WHEN shift_created is not null THEN TRUE ELSE FALSE END AS shift_created_goal_status,
  shift_created.activation_date AS shift_date_completed,
  CASE WHEN employees_invited is not null THEN TRUE ELSE FALSE END AS employee_invited_goal_status,
  employees_invited.activation_date AS employee_date_completed,
  CASE WHEN punched_in is not null THEN TRUE ELSE FALSE END AS punched_in_goal_status,
  punched_in.activation_date AS punched_in_date_completed,
  CASE WHEN punch_approval is not null THEN TRUE ELSE FALSE END AS punch_approval_goal_status,
  punch_approval.activation_date AS punch_approval_date_completed,
  CASE WHEN advanced_features is not null THEN TRUE ELSE FALSE END AS advanced_features_goal_status,
  advanced_features.activation_date AS advanced_features_date_completed
FROM
  `softonicdatalake.dbt_rhoang.mart_trial_goals`
)