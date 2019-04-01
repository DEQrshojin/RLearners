library(tidyverse)
library(AWQMSdata)



# Tidyverse attaches the following packages:
#   dplyr - data manipulation "Verbs"
#   ggplot2 - graphing
#   purrr - replace loops with vectorized functions
#   tibble - redone dataframe
#   tidyr - Data tidying . Ex: gather (wide to long), spread (long to wide), complete
#   stringr - Deal with strings (matching, joining, subsetting etc)
#   readr - data import - Honestly I don't use these
#   forcats - dealing with factors. Also don't use these.



data <- AWQMS_Data(startdate = '1949-09-15', 
                   enddate = '2019-04-01', 
                   station = c('11509370', '11507500'), 
                   char = c('Temperature, water'), 
                   crit_codes = TRUE)

# Filter to only 7DADM values
# add criteria
# compare result to criteria


standard <- data[data$Statistical_Base == '7DADM',]

standard$criteria <- 20

standard$excursion <- ifelse(standard$Result_Numeric > standard$criteria, 1, 0)

aggregate(standard$excursion, by=list(MLoc=standard$MLocID), FUN=sum)


#Dplyr method

dplyr <- data %>%
  filter(Statistical_Base == '7DADM') %>%
  mutate(criteria = 20,
         excursion = ifelse(Result_Numeric > criteria, 1, 0 )) %>%
  group_by(MLocID) %>%
  summarise(sum_excursions = sum(excursion))







ifelse_example <- data %>%
  mutate(Temp_category = ifelse(Result_Numeric > 22, "Very High", 
                                ifelse(Result_Numeric > 20 & Result_Numeric <= 22, "High", 
                                       ifelse(Result_Numeric > 20 & Result_Numeric <= 22, "Medium", 
                                              ifelse( Result_Numeric > 0 & Result_Numeric <= 10, "Low", 
                                                     ifelse(Result_Numeric < 0, "Freezing", "Error" ) )))))






# case_when example

case_when_example <- data %>%
  mutate(Temp_category = case_when(Result_Numeric > 22 ~ "Very High",
                                   Result_Numeric > 20 & Result_Numeric <= 22 ~ "High",
                                   Result_Numeric > 10 & Result_Numeric <= 20 ~ "Medium",
                                   Result_Numeric > 0 & Result_Numeric <= 10 ~ "Low",
                                   Result_Numeric < 0 ~ "Freezing",
                                   TRUE ~ "ERROR")) %>%
  group_by(MLocID, Temp_category) %>%
  summarise(sum_categories = n()) %>%
  spread(key = 'Temp_category', value = 'sum_categories') %>%
  gather(key = 'Temp_category', value = 'sum_categories', 2:5)
  #gather(key = 'Temp_category', value = 'sum_categories', "High", "Low", "Medium", "Very High")