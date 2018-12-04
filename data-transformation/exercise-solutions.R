install.packages("completejourney")
install.packages("tidyverse")
library(tidyverse)
library(completejourney)

#Data Tranformation Solutions

#change transactions, household, week, and time variables and removed week

transactions <- transactions %>% 
  select(
    quantity,
    sales_value, 
    retail_disc, coupon_disc, coupon_match_disc,
    household_id, store_id, basket_id, product_id, 
    week, transaction_timestamp
  )

transactions

# Question 1: Change the discount variables (i.e., retail_disc, coupon_disc,
# coupon_match_disc) from negative to positive.

transactions <- transactions %>% mutate( 
  retail_disc = abs(retail_disc),
  coupon_disc = abs(coupon_disc),
  coupon_match_disc =
  abs(coupon_match_disc))

transactions

#Done


