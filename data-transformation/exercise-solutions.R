install.packages("completejourney")
install.packages("tidyverse")
library(tidyverse)
library(completejourney)

#Data Tranformation Solutions

#change transactions, household, week, and time variables and removed day variable

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

#solved

# Question 2: Create three new variables named `regular_price`, `loyalty_price`, and `coupon_price` according to the following logic:
  
# logic is that regular_price = (sales_value + retail_disc + coupon_match_disc) / quantity,
#loyalty_price = (sales_value + coupon_match_disc) / quantity
#coupon_price  = (sales_value - coupon_disc) / quantity

transactions <- transactions %>% mutate(regular_price = (sales_value + retail_disc + coupon_match_disc) / quantity, loyalty_price = (sales_value + coupon_match_disc) / quantity, coupon_price  = (sales_value - coupon_disc) / quantity)

transactions

#solved
