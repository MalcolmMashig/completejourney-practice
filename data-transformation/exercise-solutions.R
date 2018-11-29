library(completejourney)

transactions <- transactions %>% 
  select(
    quantity,
    sales_value, 
    retail_disc, coupon_disc, coupon_match_disc,
    household_key, store_id, basket_id, product_id, 
    week_no, day, trans_time
  )

# Question 1: Change the discount variables (i.e., retail_disc, coupon_disc,
# coupon_match_disc) from negative to positive.

