CREATE TABLE dbt_rhoang.mart_trial_goals AS (

    WITH shift_created AS (
        SELECT
            organization_id,
            -- Metric Grouped organization
            STRUCT(
                CASE when event_order_occurance = 2 then event_date else null end as activation_date,
                -- OVER to handle scd and granularity separately
                SUM(activity_cnt) OVER (partition by organization_id) AS total_activity_YTD)
            AS shift_created
            FROM
                `softonicdatalake.dbt_rhoang.int_metric_shift`
            QUALIFY
                shift_created.activation_date is not null
    )
    , employees_invited AS (
        SELECT
            organization_id,

            -- Metric Grouped organization
            STRUCT(
                CASE when event_order_occurance = 1 then event_date else null end as activation_date,
                -- OVER to handle scd and granularity separately
                SUM(activity_cnt) OVER (partition by organization_id) AS total_activity_YTD)
            AS employees_invited
        FROM
            `softonicdatalake.dbt_rhoang.int_metric_employee`
        QUALIFY
            employees_invited.activation_date is not null
    )
    , punched_in AS (
        SELECT
            organization_id,
            -- Metric Grouped organization
            STRUCT(
                CASE when event_order_occurance = 1 then event_date else null end as activation_date,
                -- OVER to handle scd and granularity separately
                SUM(activity_cnt) OVER (partition by organization_id) AS total_activity_YTD)
            AS punched_in
            FROM
                `softonicdatalake.dbt_rhoang.int_metric_punch_in`
            QUALIFY
                punched_in.activation_date is not null
    )
    , punch_approval AS (
        SELECT
            organization_id,
            -- Metric Grouped organization
            STRUCT(
                CASE when event_order_occurance = 1 then event_date else null end as activation_date,
                -- OVER to handle scd and granularity separately
                SUM(activity_cnt) OVER (partition by organization_id) AS total_activity_YTD)
            AS punch_approval
            FROM
                `softonicdatalake.dbt_rhoang.int_metric_punch_in`
            QUALIFY
                punch_approval.activation_date is not null
    )
    , advanced_features AS (
        SELECT
            organization_id,
            STRUCT(
                activity_detail AS second_activity_name,
                --getting activation date for the second feature; when it actually triggers metric completition
                CASE WHEN ROW_NUMBER() OVER (PARTITION BY organization_id, feature_occurance_order ORDER BY timestamp) = 2 THEN event_date else null end as activation_date,
                COUNT(feature_occurance_order) OVER (PARTITION BY organization_id, feature_occurance_order) AS num_uniq_feature_visit_YTD
            ) AS advanced_features
        FROM
            `softonicdatalake.dbt_rhoang.int_metric_page_view`
        WHERE
            feature_occurance_order = 1
        QUALIFY
            advanced_features.activation_date is not null
    )
    , dim_org_id AS (
        -- base dim org table. Could have been a seperate INT/dim table. 
        SELECT DISTINCT 
            organization_id
        FROM `softonicdatalake.dbt_rhoang.stg_activity_data`
    )



    SELECT
        base_id.organization_id,

        --Metric Data (Struct types)
        shift_created.shift_created,
        employees_invited.employees_invited,
        punched_in.punched_in,
        punch_approval.punch_approval,
        advanced_features.advanced_features

    FROM dim_org_id AS base_id
        LEFT JOIN shift_created ON base_id.organization_id = shift_created.organization_id
        LEFT JOIN employees_invited ON base_id.organization_id = employees_invited.organization_id
        LEFT JOIN punched_in ON base_id.organization_id = punched_in.organization_id
        LEFT JOIN punch_approval ON base_id.organization_id = punch_approval.organization_id
        LEFT JOIN advanced_features ON base_id.organization_id = advanced_features.organization_id
    )
-- if data exists within the new table, that means the trial was completed, otherwise it is nulled out 