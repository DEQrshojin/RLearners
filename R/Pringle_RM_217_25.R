library(ggplot2)
library(plyr)

## Get the data from a csv file
pringle <-read.csv("E:/R/RLearners/R/data/RM_217_25_Pringle_Falls_UDWC_2016.csv",
                   stringsAsFactors = FALSE)

# Convert to dates
pringle$Date <- as.Date(pringle$Date, '%m/%d/%Y')

pringle$datetime <- paste0(pringle$Date, ' ', pringle$Time)

pringle$datetime <- as.POSIXct(pringle$datetime, '%Y-%m-%d %H:%M:%S',
                               tz = 'America/Los_Angeles')

# You have an NA in there somewhere, so remove with complete.cases()
pringle <- pringle[complete.cases(pringle), ]

# Use the aggregate function based on the Date column to calculate the daily Max
pringleTMax <- aggregate(pringle, by = list(pringle$Date), FUN = 'max')

pringleTMax$datetime <- as.POSIXct(pringleTMax$Date, '%Y-%m-%d',
                                   tz = 'America/Los_Angeles')

# Keep only the necessary columns and rename 1 column for housekeeping's sake
pringleTMax <- pringleTMax[, c(1, 4)]

names(pringleTMax) <- c('Date', 'TempC')

# Initialize the 7DADM column ()
pringleTMax$Flag <- pringleTMax$T_7DADM <- 0

# Identify the starting date
strDate <- pringleTMax[1, 1]

# Create table of 7Day Average Daily Max. This block loops through each day and
# calculates the 7-day average of the daily maxes for the previous seven days.
# If the date is with that first week (i.e., there are fewer than seven days on
# which to calculate a full 7DADM, then just use the days up to that point.
# Hence the 7DADM within the first week are not true 7DADM. I've added a flag
# in the code to single those days out. and we'll graph those differently.

for (i in 1 : nrow(pringleTMax)) {
  
  if (pringleTMax[i, 1] < strDate + 7) {
    
    pringleTMax[i, 3] <- mean(pringleTMax[1 : i, 2])
    
    pringleTMax[i, 4] <- 0 # 0 = not a true 7DADM

  }
  
  else {
  
    pringleTMax[i, 3] <- mean(pringleTMax[(i - 6) : i, 2])
    
    pringleTMax[i, 4] <- 1 # 1 = is a true 7DADM 
    
  }
}

pringleTMax$Flag <- as.factor(pringleTMax$Flag)

# 
p <- ggplot(data = pringleTMax, aes(x = datetime, y = T_7DADM, group = Flag)) + 
     geom_line(aes(linetype = Flag, color = Flag), size = 1.3) + theme_bw() +
     geom_point(data = pringle, aes(x = datetime, y = TempC), shape = 7) +
     geom_hline(yintercept = 16, color="red") + 
     scale_linetype_manual(values = c("longdash", "solid"),
                           labels = c('Estimated 7DAMD', 'Calculated 7DAMD')) + 
     scale_color_manual(values = c("darkgray", "black"),
                        labels = c('Estimated 7DAMD', 'Calculated 7DAMD')) + 
     scale_x_date(breaks = c('2 weeks'), date_labels = "%m/%d") + 
     ylab("Temperature (deg C), 7-Day Average Daily Maximum") +
     theme(axis.title.x = element_blank())

p

ggsave('7DADM_for_Smita.jpg', plot = p, path = 'E:/R/RLearners/R',
       width = 10, height = 8, units = 'in', dpi = 300)
