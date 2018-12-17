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

# LIBRARIES ----
library(lubridate)

options(stringsAsFactors = FALSE)
# 1) Data types -- instances of data types are called objects ----

#     a) A basic object
someWords <- 'some words' # Assigns the character value of 'some words' to someWords

#     b) How to view the data

someWords # This command will output the value associated with someWords to the Console.
# You can also type this into the console

print(someWords)

View(someWords)     # You can also type this into the console
# --OR-- If it's an object with more complex dimensional properties
#  you can click on it in the Environment pane

#     c) Here are some more objects
aNumber <- 12345 # a double (float) value

aTrueOrFalseThing <- TRUE # Boolean (Logical)

anOrderedVector <- 1 : 100 # an ordered sequence of integers from 1 to 100

aRandomVector <- runif(100, 0.0, 1.0) # a vector of 100 randomly generate numbers from 0 to 1

roundedRandomVector <- round(aRandomVector, digits = 2) # Round aRandomVector to 2 digits

someMatrix = as.matrix(cbind(roundedRandomVector, round(runif(100, 0.0, 1.0), 2)))

matrix2DataFrame = data.frame(someMatrix)

someList = list(someWords,
                aNumber,
                aTrueOrFalseThing,
                aRandomVector,
                roundedRandomVector,
                someMatrix,
                matrix2DataFrame)

# In reference to the list above, you can create a line break in the code with a hard return after a
# comma, math operator (+-*/, etc.) or logical operator (&|). Here we've used the comma separating
# arguments in we're passing to a function that creates lists.

# 2) Go get some data! ----
data <- read.csv('E:/R/RLearners/R/data/flow_data.csv') # Reads from a local directory.
# Remember to use the forward slash '/' rather than the back slash '\' because the '\' is a special
# operator called an escape. Here is a mnemonic to help remember the difference between back and
# forward slashes: https://twitter.com/reverentgeek/status/789135336437800960

data <- 'https://raw.githubusercontent.com/shojiwan/RLearners/master/R/data/flow_data.csv'
# You can also read the data straight from the GitHub repo. You must access the 'raw' data, howeve
# rather than the html representation.

data <- read.csv(data)

View(data) # Look at the data in the 'Source' pane

str(data) # Examine the structure of the data

View(data$DATE) # View a specific variable (column) of the data

data[849, 3] # View a specific value within the data

View(data[data$Model >= 100, ]) # View data that meet a specific condition

head(data, nl = 10) # Head looks at the first 6 lines of the data. We tried 'nl' but it didn't do
# anything. The correct syntax is from ?head: head(x, n = 6L), where 6L is  a single integer.
# If positive or zero, size for the resulting object: number of elements for a vector
# (including lists), rows for a matrix or data frame or lines for a function. If negative, all but
# the n last/first number of elements of x.

tail(data) # Looks at the last 6 lines of data

# 3) Do some things to the data ----

#     a) Subsetting data
x <- data[data$Model <= 100, ]       # Fastest RMS to benchmark
y <- subset(data, data[, 2] < 100)
z <- filter(data, data[, 2] < 100)
# My benchmarking indicates that filter (0.13 seconds) is the fastest, and subset (0.28 seconds)
# is the slowest.

#     b) Coercing data
data$date.date <- as.Date(data$DATE, format = "%m/%d/%Y")

data$PosixDate <- as.POSIXct(data$DATE, format = "%m/%d/%Y", tz = 'America/Los_Angeles')

seconds <- 754378954

dateofSeconds <- as.POSIXct(seconds, origin = "1970-01-01", tz = 'GMT')

data$Posix <- as.POSIXct(data$DATE, format = "%m/%d/%Y", tz = 'America/Los_Angeles')

data$strptime <- strptime(data$DATE, format = "%m/%d/%Y", tz = 'America/Los_Angeles') 

dateofSeconds <- dateofSeconds + hours(7) # Need to load the package lubridate: library(lubridate)
# What is the difference between require() and library()? From R-bloggers:
# Both functions update the list of attached packages without reloading the loaded packages
# library() returns an error if the requested package does not exist.
# require() is designed for use in functions and gives a warning message and returns a
# logical (FALSE) if the package is not found.

dateofSeconds <- dateofSeconds + 7 * 3600 # does the same thing as preceeding line

# Is awqms in PST (yearround) or PDT? LASAR data was imported into AWQMS under PST.
# tz = 'America/Los_Angeles' = PST/PDT

# POSIXct is datetime in seconds (float) since a specified origin time (default = 1970-01-01) 
# POSIXlt is list of YEAR, MOTHN, DAY, HOUR, ss.sss, 

# 4) Plot the data ----

#     a) Base graphing

#     b) ggplot

# 5) Analyze the data ----

#     a) Rename the columns

#     a) Calculate annual runoff volumes
