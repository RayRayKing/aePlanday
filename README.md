# aePlanday

# Instructions

For the first questions, the SQL models can be found the models folder. 
For the second analysis questions, the python and analysis can be found in the ae_planday notebook.


# Entity Relationship Model 

[![](https://mermaid.ink/img/pako:eNrdV9tu4jAQ_ZUoz-UHeGNLVCFtQaLRSpUiWZY9BEuJnXUcVmzh33eIidPEBFL6tPCCkznnjGcy48tHyBSHcBqCnguaaponMsBfaVJCmRE7YfaEU0ODD2uwRi1kGiidUin-UiOUJIJ7dseXNIdhKwdDRdbajcihNDQv2pE1Hu2fkIbkgCKMlFuxMV-ZGXKD2XO8-LWI38ly9hp1TW5OTJrWguFDADtAv6dhd6Znw2lIKsO6etamNAdNFGOVppLBUDCQF5naAzxKPEUl2ZYI-Vjx0KLQakezh4mKpkB2Av78nwE1kA1QU2lozRbeiTqnGj1oQTOSKpqVnwJ-i9eL5UtiBiNeR8-r9Twx9YpDmEZ3cMHc9HCJdY8ZuASpywg4AgZsrsR8O-W7U2ycnMMtW8h8Fke96U3q72Bj6WZ8sYyjl2jdxxtlMDfu673H876-F98IHz7ntp9uIkY46RFGeqg_w1h1C76m3FSR95kmJTAlORnYEe2MfNbtifkcWeWkkuJ38wZ7uxSmnaffC62XIPhKS_xYrX5Gs2Vi-jIE92xTebXpwboxOblOTdadOiBogScVwhQWGXT6zek19deU3zVJh72p2pbENb1PqHGKroRvqrbIm8pelVwT98GX9LGM7GDouHg4TCaHg39YmwYg8WnbCI1hupPRPWR3DLmf7Pb8uyTcBttne7k5WnJ_n0IiTVMNabvnXErOXWyXnW-wXXru03D5GU_3IAeP-mlVmwZ4xQCdCwll-BTmOKSC452nXu2S0GwBV-NwikMOG1plJgkTeUQorYx620sWTo2u4CnUqkq34XSDLvGpKk6dcb42ubfABa6Zr_ZWVV-ujv8AB62Nuw?type=png)](https://mermaid.live/edit#pako:eNrdV9tu4jAQ_ZUoz-UHeGNLVCFtQaLRSpUiWZY9BEuJnXUcVmzh33eIidPEBFL6tPCCkznnjGcy48tHyBSHcBqCnguaaponMsBfaVJCmRE7YfaEU0ODD2uwRi1kGiidUin-UiOUJIJ7dseXNIdhKwdDRdbajcihNDQv2pE1Hu2fkIbkgCKMlFuxMV-ZGXKD2XO8-LWI38ly9hp1TW5OTJrWguFDADtAv6dhd6Znw2lIKsO6etamNAdNFGOVppLBUDCQF5naAzxKPEUl2ZYI-Vjx0KLQakezh4mKpkB2Av78nwE1kA1QU2lozRbeiTqnGj1oQTOSKpqVnwJ-i9eL5UtiBiNeR8-r9Twx9YpDmEZ3cMHc9HCJdY8ZuASpywg4AgZsrsR8O-W7U2ycnMMtW8h8Fke96U3q72Bj6WZ8sYyjl2jdxxtlMDfu673H876-F98IHz7ntp9uIkY46RFGeqg_w1h1C76m3FSR95kmJTAlORnYEe2MfNbtifkcWeWkkuJ38wZ7uxSmnaffC62XIPhKS_xYrX5Gs2Vi-jIE92xTebXpwboxOblOTdadOiBogScVwhQWGXT6zek19deU3zVJh72p2pbENb1PqHGKroRvqrbIm8pelVwT98GX9LGM7GDouHg4TCaHg39YmwYg8WnbCI1hupPRPWR3DLmf7Pb8uyTcBttne7k5WnJ_n0IiTVMNabvnXErOXWyXnW-wXXru03D5GU_3IAeP-mlVmwZ4xQCdCwll-BTmOKSC452nXu2S0GwBV-NwikMOG1plJgkTeUQorYx620sWTo2u4CnUqkq34XSDLvGpKk6dcb42ubfABa6Zr_ZWVV-ujv8AB62Nuw)

# Data Model Overview

For data modeling style, I used a setup similar to facts and dims model. The data was broken up with more relations to the usage. In this particular case, it was separate by metric and the further aggregate to the business need at the end. In the INT layer, it was mainly a process for enrichment of data in this case (frequency, row_number information).

**The Raw data has a few concerns:**

1. There were duplicated data (with same exact time stamps) +  other fields. These transactions could be real, would require confirmation from business. For now, I've included it within the analysis. 
2. Data exceeding march, the request was for Jan - Mar, there were data within april mixed in. This was excluded from the analysis.

---

## 1. **Staging Layer**

### `stg_trial_events`:  
This staging layer cleans and filters events to only include data between January and March.

| Column              | Type       | Description                         |
|---------------------|------------|-------------------------------------|
| `organization_id`   | `STRING`   | Organization unique ID              |
| `activity_name`     | `STRING`   | Activity name                       |
| `activity_detail`   | `STRING`   | Additional activity details         |
| `timestamp`         | `TIMESTAMP`| Timestamp of event transaction      |

---

## 2. **Intermediate Layer (int_metric_{dimension})**

All dimensions follow a similar structure except for `page_views`, which contains two additional columns.

| Column                        | Type       | Description                                                                         |
|-------------------------------|------------|-------------------------------------------------------------------------------------|
| `organization_id`              | `STRING`   | Organization unique ID                                                              |
| `activity_name`                | `INT`      | Activity name                                                                       |
| `activity_cnt`                 | `INT`      | 1 transaction per line                                                              |
| `timestamp`                    | `TIMESTAMP`| Timestamp of event                                                                  |
| `event_date`                   | `DATE`     | Date of the event                                                                   |
| `event_time_utc`               | `TIME`     | UTC time of the event                                                               |
| `event_order_occurrence`       | `INT`      | Occurrence order by organization ID based on time                                   |
| `activity_detail`              | `STRING`   | *(only in `page_view`)* Additional detail to the activity name                      |
| `feature_occurrence_order`     | `INT`      | *(only in `page_view`)* Occurrence order by organization based on activity details. Groups occurrences within activity details |

---

## 3. **Mart Layer**

### `mart_trial_activation`:  
This table tracks individual goal activations and provides additional date details for each metric. The metrics are organized as records/structs for easier management.

| Column                                      | Type      | Description                                                                |
|---------------------------------------------|-----------|----------------------------------------------------------------------------|
| `organization_id`                           | `STRING`  | Organization unique ID                                                     |
| `shift_created.activation_date`             | `DATE`    | Date when the `shift_created` metric was completed                         |
| `shift_created.total_activity_YTD`          | `INTEGER` | Count of all shift_created activities within Jan-Mar                        |
| `employees_invited.activation_date`         | `DATE`    | Date when the `employees_invited` metric was completed                     |
| `employees_invited.total_activity_YTD`      | `INTEGER` | Count of all employees invited activities within Jan-Mar                    |
| `punched_in.activation_date`                | `DATE`    | Date when the `punched_in` metric was completed                            |
| `punched_in.total_activity_YTD`             | `INTEGER` | Count of all punched_in activities within Jan-Mar                           |
| `punch_approval.activation_date`            | `DATE`    | Date when the `punch_approval` metric was completed                        |
| `punch_approval.total_activity_YTD`         | `INTEGER` | Count of all punch_approval activities within Jan-Mar                       |
| `advanced_features.second_activity_name`    | `STRING`  | Second advanced feature activity name                                      |
| `advanced_features.activation_date`         | `DATE`    | Date when the `advanced_features` metric was completed                     |
| `advanced_features.num_uniq_feature_visit_YTD` | `INTEGER`| Unique count of activity details within advanced features during Jan-Mar    |

### `mart_trial_goals`:  
This table provides a summary of trial goal completion and activation status for each organization.

| Column                         | Type       | Description                                    |
|---------------------------------|------------|------------------------------------------------|
| `organization_id`               | `STRING`   | Organization unique ID                         |
| `trial_activation_status`        | `BOOLEAN`  | Final determination on trial completion        |
| `trial_activation_date`          | `DATE`     | Date of trial completion                       |
| `shift_created_goal_status`      | `BOOLEAN`  | Status of `shift_created` goal                 |
| `shift_date_completed`           | `DATE`     | Date when `shift_created` goal was completed   |
| `employee_invited_goal_status`   | `BOOLEAN`  | Status of `employees_invited` goal             |
| `employee_date_completed`        | `DATE`     | Date when `employees_invited` goal was completed|
| `punched_in_goal_status`         | `BOOLEAN`  | Status of `punched_in` goal                    |
| `punched_in_date_completed`      | `DATE`     | Date when `punched_in` goal was completed      |
| `punch_approval_goal_status`     | `BOOLEAN`  | Status of `punch_approval` goal                |
| `punch_approval_date_completed`  | `DATE`     | Date when `punch_approval` goal was completed  |
| `advanced_features_goal_status`  | `BOOLEAN`  | Status of `advanced_features` goal             |
| `advanced_features_date_completed`| `DATE`   | Date when `advanced_features` goal was completed|

---

## 4. **Optimization Strategies**

### Clustering:
- **Geo-local partitioning**: Assign numerical ID groups based on location, e.g., `Dim_Location` (country/region).
- More advanced clustering could be done by grouping frequency bins (e.g., how often a location is accessed).

### Fact Tables:
- **Partitioning**: All tables should be partitioned by event date.
- **Clustering**: clustering by activity, activity details can provide better performance.
  
### Indexing and Sharding:
- **Indexing**: Consider turning off indexing for very large tables (100GB+), as indexes turn off at 10GB by default.
- **Sharding**: Useful for very large datasets to reduce query times and optimize organization. This is particularly beneficial when the data is not date-partitioned or hits partition limits.

---


# Data quality and testing Suggestions:

Data quality can be verified via SQL, Python or 3rd party tools.

Standard Check tests 
#### 1. all organization_ids are unique and not null
#### 2. Accepted value checks on activity names, details, and date checks
#### 3. On the more complex level, doing data diff. Ensuring that all changes are within expectations (Row level impact, field impact for down stream data) 
#### 4. Model tests - run within staging environment to ensure code actually runs without breaking anything else. (Basically unit testing)
#### 5. Summary data stats - Min, max, row counts, expectations and nulls verifications.




