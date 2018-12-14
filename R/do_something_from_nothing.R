# WELCOME TO THE R LEARNERS GROUP MEETING, NOVEMBER 29, 2018 ----

# There are only two hard things in Computer Science: cache invalidation and naming things.
# -- Phil Karlton

# Introduction
# In this script we will step through some basic elements of scripting in R and
# using the RStudio Integrated Development Environment (IDE). Orientation of the RStudio will
# happen implicitly through this demonstration

# General notes:
# To execute an individual line in the script the keyboard stroke is Ctrl-Enter
# To execute the source script the keyboard stroke is Ctrl-Shft-Enter

# LIBRARIES? Wait for it... ----
library(lubridate)

options(stringsAsFactors = FALSE)
# 1) Data types -- instances of data types are called objects ----

#     a) A basic object
someWords <- 'some words'

#     b) How to view the data

someWords           # You can also type this into the console

print(someWords)

View(someWords)     # You can also type this into the console
# --OR-- If it's an object with more complex dimensional properties =====>>
#  you can click on it in the Environment pane to the right         =====>>

#     c) Here are some more objects
aNumber <- 12345

aTrueOrFalseThing <- "TRUE"

anOrderedVector <- 1 : 100

aRandomVector <- runif(100, 0.0, 1.0)

roundedRandomVector <- round(0.432432432, digits = 2)

someMatrix = as.matrix(cbind(roundedRandomVector, round(runif(100, 0.0, 1.0), 2)))

matrix2DataFrame = data.frame(someMatrix)

someList = list(someWords, aNumber, aTrueOrFalseThing, aRandomVector, roundedRandomVector, someMatrix, matrix2DataFrame)


# 2) Go get some data! ----
View(data)

str(data)

View(data$DATE)

data[849, 3]

View(data[data$Model == 100, ])

head(data, nl = 10)

tail(data)

#   c) You can also type this into the same line
data <- read.csv('E:/R/RLearners/R/data/flow_data.csv')

# 3) Do some things to the data ----

#     a) Subsetting data
x <- data[data$Model <= 100, ]       # Fastest RMS to benchmark
y <- subset(data, data[, 2] < 100)
z <- filter(data, data[, 2] < 100)

#     b) Coercing data
data$date.date <- as.Date(data$DATE, format = "%m/%d/%Y")

str(data)

data$PosixDate <- as.POSIXct(data$DATE, format = "%m/%d/%Y", tz = 'America/Los_Angeles')

seconds <- 754378954

dateofSeconds <- as.POSIXct(seconds, origin = "1970-01-01", tz = 'GMT')

data$Posix <- as.POSIXct(data$DATE, format = "%m/%d/%Y", tz = 'America/Los_Angeles')

data$strptime <- strptime(data$DATE, format = "%m/%d/%Y", tz = 'America/Los_Angeles') 

dateofSeconds <- dateofSeconds + 7 * 3600

# Is awqms in PST (yearround) or PDTASAR data was imported into AWQMS under Pacific Standard Time
# tz = 'America/Los_Angeles' = PST/PDT

# POSIXct is datetime in seconds since a specified origin time (defult = 1970-01-01) 
# POSIXlt is list of YEAR, MOTHN, DAY, HOUR, ss.sss, 

# 4) Plot the data ----

#     a) Base graphing

#     b) ggplot

# 5) Analyze the data ----

#     a) Rename the columns

#     a) Calculate annual runoff volumes
