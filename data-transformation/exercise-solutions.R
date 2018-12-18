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

# Question 3`transactions` includes 92,339 unique product IDs. How many of these products (not transactions!) had a regular price of one dollar or less? What does this count equal for loyalty and coupon prices?

transactions %>% filter(regular_price <= 1) %>% select(product_id) %>% n_distinct()

transactions %>% 
  filter(loyalty_price <= 1) %>% 
  select(product_id) %>% 
  n_distinct()

transactions %>% 
  filter(coupon_price <= 1) %>% 
  select(product_id) %>% 
  n_distinct()

#solved

# Question 4: What proportion of baskets are over $10 in sales value? 

transactions %>%
  group_by(basket_id) %>%
  summarize(basket_value = sum(sales_value)) %>%
  ungroup() %>%
  summarize(proportion_over_10 = mean(basket_value > 10))

#solved

#Question 5: Which store with over $10K in total `sales_value` discounts its products the most for loyal customers? 

transactions %>%
  filter(
    is.finite(regular_price), 
    is.finite(loyalty_price), 
    regular_price > 0
  ) %>%
  mutate(
    pct_loyalty_disc     = 1 - (loyalty_price / regular_price)
  ) %>%
  group_by(store_id) %>%
  summarize(
    total_sales_value    = sum(sales_value), 
    avg_pct_loyalty_disc = mean(pct_loyalty_disc)
  ) %>%
  filter(total_sales_value > 10000) %>%
  arrange(desc(avg_pct_loyalty_disc))

#solved

# Data Visualization Solutions

# Question 1

# Create a histogram of `quantity`. What, if anything, do you find unusual 
# about this visualization? 
  
ggplot(transactions, mapping = aes(quantity)) + geom_histogram()

# Solved

# Question 2

# Use a line graph to plot total sales value by day. What, if anything, do you # find unusual about this visualization?

ggplot(transactions, mapping = aes(transaction_timestamp, sales_value)) + geom_line()

# No day variable so I used transaction_timestamp

# Alternate

transactions %>% 
  group_by(week) %>% 
  summarize(total_sales_value = sum(sales_value, na.rm = TRUE)) %>%
  ggplot() + 
  geom_line(mapping = aes(x = week, y = total_sales_value))

# used week instead of day

# Solved

# Question 3

# Use a bar graph to compare the total sales values of national and private
# -label brands. 

products

my_transaction_data <- left_join(transactions, products, by = 'product_id')

my_transaction_data %>%
  group_by(brand) %>%
  summarize(total_sales_value = sum(sales_value)) %>%
  ggplot() + 
  geom_bar(
    mapping = aes(x = brand, y = total_sales_value), 
    stat = 'identity'
  )

# Solved

