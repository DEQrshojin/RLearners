# General notes:
# To execute an individual line in the script the keyboard stroke is Ctrl-Enter
# To execute the source script the keyboard stroke is Ctrl-Shft-Enter

# LIBRARIES????
library(lubridate)
library(reshape2)
library(ggplot2)

# 1) Data types -- instances of data types are called objects
#   a) A basic object
someWords <- 'some words'

#   b) How to view the data
someWords           # You can also type this into the console

print(someWords)

View(someWords)     # You can also type this into the console
                    # --OR-- If it's an object with more complex dimensional properties =====>>
                    # you can click on it in the Environment pane to the right          =====>>

#   c) Here are some more objects
aNumber <- 12345

aTrueOrFalseThing <- TRUE

anOrderedVector <- 1 : 100

aRandomVector <- runif(100, 0.0, 1.0)

roundedRandomVector <- round(aRandomVector, digits = 2)

someMatrix = as.matrix(cbind(roundedRandomVector, round(runif(100, 0.0, 1.0), 2)))

matrix2DataFrame = data.frame(someMatrix)

someList = list(someWords,
                aNumber,
                aTrueOrFalseThing,
                aRandomVector,
                roundedRandomVector,
                someMatrix,
                matrix2DataFrame)

# 2) GO GIT SOME DATA
#   c) You can also type this into the same line
data <- read.csv('E:/R/RLearners/R/data/flow_data.csv')

#   a) Specify the location of the data
data <- 'E:/R/RLearners/R/data/flow_data.csv'

#   b) Tell R to go retrieve the data
data <- read.csv(data)

# 3) Do some things to the data
#   a) subsets of the data
View(data)

str(data)

View(data$DATE)

data[849, 3]

View(data[1 : 10, ])

#   b) coerce data into correct formats
data$date.date <- as.Date(data$DATE, format = "%m/%d/%Y")

str(data)

data$PosixDate <- as.POSIXct(data$DATE, format = "%Y-%m-%d", tz = 'America/Los_Angeles')

data$Posix <- as.POSIXct(data$DATE, format = "%m/%d/%Y", tz = 'America/Los_Angeles')

data$strptime <- strptime(data$DATE, format = "%m/%d/%Y", tz = 'America/Los_Angeles')

# POSIXct stores seconds since UNIX epoch (plus some other data)
# POSIXlt stores a list of day, month, year, hour, minute, second, etc.

data$DATE <- data$DATE + hours(7)

data$DATE <- ifelse(hour(data$DATE) == 23, data$DATE + hours(1), data$DATE)

data$DATE <- as.POSIXct(data$DATE, origin = '1970-01-01')

# 4) Plot the data
#   a) base
plot(data)

#   b) ggplot
flowPlot1 <- ggplot(data, aes(x = DATE, y = Gage)) + geom_point()

plot(flowPlot1)

flowPlot1 <- ggplot(data) + geom_point(aes(x = DATE, y = Gage)) +
             geom_line(aes(x = DATE, y = Model), color = 'Blue')

plot(flowPlot1)

flowPlot1 <- ggplot(data) + geom_point(aes(x = DATE, y = Gage)) +
             geom_line(aes(x = DATE, y = Model), color = 'Blue') +
             scale_y_log10(limits = c(10, 40000))

plot(flowPlot1)

sameData = melt(data, id.vars = "DATE")

flowPlot2 <- ggplot(sameDate,
                    aes(x = DATE, y = value, group = variable, color = variable)) +
             geom_line() + scale_y_log10(limits = c(10, 40000))

plot(flowPlot2)

ggsave(filename, plot = last_plot(), device = NULL, path = NULL,
       scale = 1, width = NA, height = NA, units = c("in", "cm", "mm"),
       dpi = 300, limitsize = TRUE, ...)

# 5) Analyze the data
#   a) Rename the columns of the 'sameData' data frame
names(sameData) = c('date', 'srce', 'q_cfs')

#   a) Calculate annual runoff volumes, i.e, daily flow in cfs to daily volume in acre-feet
sameData$v_af <- sameData$q_cfs * 86400 / 43560

sameData$year <- year(sameData$date)

annVol <- dcast(sameData, year ~ srce, value.var = 'v_af', fun.aggregate = sum) # cast ~ pivot table in excel

meanAnnVol <- list('model' = mean(unlist(annVol[, 2])),
                   'gage' = mean(unlist(annVol[, 3])))

annVol = melt(annVol, id.vars = "year")

annVolPlot <- ggplot(data = annVol, aes(x = year, y = value, group = variable, color = variable)) + geom_col()

plot(annVolPlot)

