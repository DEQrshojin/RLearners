# Smita Mehta
# 2/1/2019
# This is a script for looking at UDWC's 2016 hourly temperature data

library(ggplot2)
library(tidyverse)

options(stringsAsFactors = FALSE, warnings = -1, scipen = FALSE)

# Get the data from a .csv file and read it into a dataframe
df.pringle <-read.csv("E:/R/RLearners/R/data/RM_217_25_Pringle_Falls_UDWC_2016.csv")

# The Date and Time fields show up as Factor datatypes. We need to merge them together (using paste()). Then convert the merged field
# to the POSIXct datetme datatype. Then save the new field into a new column in the dataframe called SampleDate.
df.pringle$SampleDate <- as.POSIXct(paste(df.pringle$Date, df.pringle$Time), format="%m/%d/%Y %H:%M:%S", tz = Sys.timezone())

#remove rows with NA values
df.pringle2 <- df.pringle[!is.na(df.pringle$TempC), ]

# Now we can visualize the data and see how temperature changes over time.
plot(df.pringle$SampleDate, df.pringle$TempC)

# Are any data points above the temperature criteria?
abline(h=18, col="red")

# The same graph using ggplot
ggplot(df.pringle2) + geom_abline(aes(intercept = 18, slope = 0, col = "red"), size=2) + geom_point(aes(x=Date, y = TempC))

###
### Let's convert data to 7DADMs to compare to temperature criteria
### 

# Step 1: create a table representing the maximum daily temperatures 
pringlemax <- aggregate(df.pringle2$TempC, by=list(df.pringle2$Date), max, na.rm = TRUE)

pringlemax <- df.pringle2 %>% 
  group_by(as.Date(Date, '%Y-%m-%d %H:%M:%S')) %>% 
  summarise(maxT = max(TempC, na.rm = TRUE))

date <- c(min(df.pringle2$SampleDate), max(df.pringle2$SampleDate))

ts <- data.frame(Date = seq(date[1], date[2], 3600))

df.pringle2 <- merge(ts, df.pringle2, by.x = 'Date', by.y = 'SampleDate', all.x = TRUE)

pringlemax$maxT[!is.finite(pringlemax$maxT)] <- NA

# Step 2: R converts the aggregate by field into a factor. But it's really a date. 
#         So let's convert the date column to Date type
colnames(pringlemax)[1] <- 'SampleDate'

# pringlemax$SampleDate <- as.POSIXct(pringlemax$SampleDate,format="%m/%d/%Y",tz=Sys.timezone())
# pringlemax$TempC <- pringlemax$x # Fixing the temperature column name
# pringlemax$Group.1 <- NULL # Get rid of old columns
# pringlemax$x <- NULL # Get rid of old columns
# pringlemax <-pringlemax[order(pringlemax$SampleDate),] # Sort the dataframe by date

# Step 3: Calculate the 7DADMs, aka the running average of maximum temperatures
pringlemax$Seven <- stats::filter(pringlemax$maxT,rep(1/7,7), sides=1)

pringlemax$SampleDate <- as.POSIXct(pringlemax$SampleDate, format="%Y-%m-%d", tz = Sys.timezone())

# Step 4: add the 7DADMs as a line on the plot
s <- ggplot(df.pringle2) + geom_abline(aes(intercept = 18, slope = 0, col = "red"), size=2) + geom_point(aes(x=Date, y = TempC)) +
   geom_line(data = pringlemax, mapping = aes(x=SampleDate, y=Seven), col = "blue", size=1.5)

ggsave('7DADM_by_Smita.jpg', plot = s, path = 'E:/Basin_Coordinator/Data/R_Training_and_Tools/Deschutes',
       width = 10, height = 8, units = 'in', dpi = 300)