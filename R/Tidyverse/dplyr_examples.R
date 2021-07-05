library(tidyverse)
library(AWQMSdata)
library(lubridate)



# Tidyverse attaches the following packages:
#   dplyr - data manipulation "Verbs"
#   ggplot2 - graphing
#   purrr - replace loops with vectorized functions
#   tibble - redone dataframe
#   tidyr - Data tidying . Ex: gather (wide to long), spread (long to wide), complete
#   stringr - Deal with strings (matching, joining, subsetting etc)
#   readr - data import - Honestly I don't use these
#   forcats - dealing with factors. Also don't use these.
#   magrittr - the pipe


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


dplyr <- filter(data, Statistical_Base == '7DADM')
dplyr <- mutate(dplyr, criteria = 20, excursion = ifelse(Result_Numeric > criteria, 1, 0 ))
dplyr <- group_by(dplyr, MLocID, month(SampleStartDate) )
dplyr <- summarise(dplyr, sum_excursions = sum(excursion) )



#Dplyr with pipe

dplyr_with_pipe <- data %>%
  filter(Statistical_Base == '7DADM') %>%
  mutate(criteria = 20,
         excursion = ifelse(Result_Numeric > criteria, 1, 0 )) %>%
  group_by(MLocID) %>%
  summarise(sum_excursions = sum(excursion))


#select

select_example <- data %>%
  select(MLocID, Result_Numeric, Result_Operator )

select_example2 <- select_example %>%
  select(-Result_Operator)


# Case_when example -------------------------------------------------------


ifelse_example <- select_example %>%
  mutate(Temp_category = ifelse(Result_Numeric > 22, "Very High", 
                                ifelse(Result_Numeric > 20 & Result_Numeric <= 22, "High", 
                                       ifelse(Result_Numeric > 20 & Result_Numeric <= 22, "Medium", 
                                              ifelse( Result_Numeric > 0 & Result_Numeric <= 10, "Low", 
                                                     ifelse(Result_Numeric < 0, "Freezing", "Error" ) )))))






case_when_example <- data %>%
  mutate(Temp_category = case_when(Result_Numeric > 22 ~ "Very High",
                                   Result_Numeric > 20 & Result_Numeric <= 22 ~ '99',
                                   Result_Numeric > 10 & Result_Numeric <= 20 ~ "Medium",
                                   Result_Numeric > 0 & Result_Numeric <= 10 ~ "Low",
                                   Result_Numeric < 0 ~ "Freezing",
                                   TRUE ~ "ERROR")) %>%
  group_by(MLocID, Temp_category) %>%
  summarise(sum_categories = n()) %>%
  spread(key = 'Temp_category', value = 'sum_categories') %>%
  #gather(key = 'Temp_category', value = 'sum_categories', 2:5)
  gather(key = 'Temp_category', value = 'sum_categories', "High", "Low", "Medium", "Very High") %>%
  





# Joins example -----------------------------------------------------------



left <- data.frame("Left1" = c("A", "B", "C"),
                    "Left2" = c(1, 2, 3), 
                    stringsAsFactors = FALSE)

right <- data.frame("Right1" = c("A", "B", "D"),
                   "Right2" = c("X", "Y", "Z"), 
                   stringsAsFactors = FALSE)


# Join by Matching left to right 
ex_left_join <- left_join(left, right, by = c("Left1" = "Right1") )


# Join by Matching right to left 
ex_right_join <- right_join(left, right, by = c("Left1" = "Right1") )

# Retain only rows in left AND right
ex_inner_join <- inner_join(left, right, by = c("Left1" = "Right1") )

#Join everything. Retain all data in both tables
ex_full_join <- full_join(left, right, by = c("Left1" = "Right1"))
