datPnts <- 10000000

data <- data.frame(cbind(set1 = runif(datPnts, 0.0, 10.0),
                         set2 = runif(datPnts, 0.0, 100.0),
                         set3 = runif(datPnts, 0.0, 1000.0)))

testResults <- c(rep(0, 4))

for (i in 1 : length(testResults)) {
  
  a = Sys.time()
  
  if (i == 1) {
    subset <- data[data[, 1] <= 5.0, ]
  } else if (i == 2) {
    subset <- data[which(data[, 1] <= 5.0), ]  
  } else if (i == 3) {
    subset <- subset(data, data[, 1] <= 5.0)  
  } else if (i == 4) {
    subset <- filter(data, data[, 1] <= 5.0)  
  }

  b = Sys.time()

  testResults[i] <- b - a
  
}

testResults
