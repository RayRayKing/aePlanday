# aePlanday



Entity Relationship Model 

[![](https://mermaid.ink/img/pako:eNrdV1GPojAQ_iuE5_UP8OatZGNyp4lLLtmEpGnKiE2g5crgxVv971eoFKGirPd0-mJh5vtmvmGmhU-fyQT8wAe14DRVNI-Fp38lpoQy5HuOB5JQpN6nMRij4iL1pEqp4H8ocikITxy7xQuaw7g1AaQ86-zIcyiR5kW3MsaT-eMCSQ6ahJFyx7f4lcw01pu_Rsufy-iDrOY_wr7J5sQEdhYtHzzYg45bL_uZng31klTI-nzGJlUCikjGKkUFgzExkBeZPAA8i56iEmxHuHguPbQolNzT7GlU0RTInsPv_1NQ67IFipWCzmzce6pzqnQExWlmtrZG16Xs92izXL3FOKp7E76uN4sYm32HMKWDwhVzO8ml7n5dh2suTTNBoh1GbLbRXDtN9rXChJxFl53LYh6Fg_RmndZB3ZerKHwLN0N_lNhWqH6GH9FiyO_omxDDxdyP0y_EhCADwMQIzWOYym6cbzG3XeQ8plkJTIqEjJyLJiMXdT8xFyOqnFSC_2rv6AkvOXZ5uhORSpqVXxqGb-v193C-inE4UkSf2Vg5Xem49dVYul43NnmNEBrHmoUwqdsLepNm-drOaxvvFqX1vcvaNcMtvguvaYy2ee-ydp53mZ3-uEXuOl_j1w1kFmOvi8fjbHY8ui9rgQdCX-1aoilI-2b0CNi-hjwOtmf-QxT2gB2indqcDNiZysCjaaog7U6ba8V5CG2r8w9oW57HOGx9psMdl6MDvTjhA09_YoDKuYDSf_FzvaQ80d88zW4X-7gDvQ_7gV4msKVVhrEfi5N2pRXK94NgfoCqghdfySrd-cFWh9RXVVFPxvmz6Xz39BfOzIcm?type=png)](https://mermaid.live/edit#pako:eNrdV1GPojAQ_iuE5_UP8OatZGNyp4lLLtmEpGnKiE2g5crgxVv971eoFKGirPd0-mJh5vtmvmGmhU-fyQT8wAe14DRVNI-Fp38lpoQy5HuOB5JQpN6nMRij4iL1pEqp4H8ocikITxy7xQuaw7g1AaQ86-zIcyiR5kW3MsaT-eMCSQ6ahJFyx7f4lcw01pu_Rsufy-iDrOY_wr7J5sQEdhYtHzzYg45bL_uZng31klTI-nzGJlUCikjGKkUFgzExkBeZPAA8i56iEmxHuHguPbQolNzT7GlU0RTInsPv_1NQ67IFipWCzmzce6pzqnQExWlmtrZG16Xs92izXL3FOKp7E76uN4sYm32HMKWDwhVzO8ml7n5dh2suTTNBoh1GbLbRXDtN9rXChJxFl53LYh6Fg_RmndZB3ZerKHwLN0N_lNhWqH6GH9FiyO_omxDDxdyP0y_EhCADwMQIzWOYym6cbzG3XeQ8plkJTIqEjJyLJiMXdT8xFyOqnFSC_2rv6AkvOXZ5uhORSpqVXxqGb-v193C-inE4UkSf2Vg5Xem49dVYul43NnmNEBrHmoUwqdsLepNm-drOaxvvFqX1vcvaNcMtvguvaYy2ee-ydp53mZ3-uEXuOl_j1w1kFmOvi8fjbHY8ui9rgQdCX-1aoilI-2b0CNi-hjwOtmf-QxT2gB2indqcDNiZysCjaaog7U6ba8V5CG2r8w9oW57HOGx9psMdl6MDvTjhA09_YoDKuYDSf_FzvaQ80d88zW4X-7gDvQ_7gV4msKVVhrEfi5N2pRXK94NgfoCqghdfySrd-cFWh9RXVVFPxvmz6Xz39BfOzIcm)


For data modeling style, I used a setup similar to facts and dims model. The data was broken up with more relations to the usage. In this particular case, it was separate by metric and the further aggregate to the business need at the end. In the INT layer, it was mainly a process for enrichment of data in this case (frequency, row_number information). The final mart is the model . 

The Raw data has a few concerns. 
 1.There were duplicated data (with same exact time stamps) +  other fields. These transactions could be real, if a mass creation was done. For now, I've kept it within the analysis. 
 2. Data exceeding march, the request was for Jan - Mar, there were data within april mixed in.

Docs for Model Short form 

How to read
table_name : descrpition
    Datatype | column name | descriptions



stg_trial_events: staging layer only cleaning and filtering to jan - mar. 
    string organization_id - Organization unique ID - 
    string activity_name - Activity name
    string activity_detail - additional activity details to activity name
    timestamp timestamp - time stamp of event transaction
    

int_metric_{dimesions}: int models - all dimensions share almost the same layout except for page_views. page_view has 2 additional columns
    string organization_id
    int ACTIVITY_NAME
    int activity_cnt - 1 transaction per line. 
    timestamp timestamp - datetime timestamp of event
    date event_date - date of the event
    time event_time_utc - time of event
    int event_order_occurance - occurance order by organization id by time
    string activity_detail - *only in page view* -  additional detail to activity name
    int feature_occurance_order - *only in page view* - occurance order by organization by activity details - groups the occurance individually within activity details
    
mart_trial_activation: individual goal activation and additional date details; each metric is in record/struct setup for easier management
    STRING	organization_id
    RECORD	shift_created
    DATE	shift_created-activation_date - date when metric was completed
    INTEGER	shift_created-total_activity_YTD - count of all activity within jan-mar
    RECORD	employees_invited
    DATE	employees_invited-activation_date
    INTEGER	employees_invited-total_activity_YTD
    RECORD	punched_in
    DATE	punched_in-activation_date
    INTEGER	punched_in-total_activity_YTD
    RECORD	punch_approval
    DATE	punch_approval-activation_date
    INTEGER	punch_approval-total_activity_YTD
    RECORD	advanced_features
    STRING	advanced_features-second_activity_name
    DATE	advanced_features-activation_date
    INTEGER	advanced_features-num_uniq_feature_visit_YTD - unique activity details count 

  
mart_trial_goals {
      STRING	organization_id
      BOOLEAN	trial_activation_status - boolean for final determination on trial completion 
      DATE	trial_activation_date - date of trial completion
      BOOLEAN	shift_created_goal_status - boolean for metric of status completion
      DATE	shift_date_completed - date of status completion
      BOOLEAN	employee_invited_goal_status
      DATE	employee_date_completed
      BOOLEAN	punched_in_goal_status
      DATE	punched_in_date_completed
      BOOLEAN	punch_approval_goal_status
      DATE	punch_approval_date_completed
      BOOLEAN	advanced_features_goal_status
      DATE	advanced_features_date_completed
  }

  
Optimization:

Clustering, possible to do geo-local partition by assigning numerical ID groups. e.g Dim_Location (country/region), at a more complex level of clustering (creating frequency bins, how often this location is driven to, offer provided etc, group it into least low, medium, high)
Fact tables:

partition tables All tables on event date.
Clustering by. most likely some form of location first, pending usage from analyst.
Indexing + Sharding when we're working with extremely large tables. (100gb + tables) index turns off at 10gb. Sharding a bit of overhead, but in terms of organization and quick queries, definitely helps. Particularly more important when it isnt date partitioned or hitting parition limits.
