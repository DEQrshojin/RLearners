# EXAMPLES OF THREE-DIMENSIONAL PLOTS

# USING PLOTLY ----
# Limitations:
# - Need to figure out how to better plot surfaces with shading -- see below
# 

install.packages("plotly")

library(plotly); library(ggplot2)

data <- read.csv('C:/Users/rshojin/Desktop/006_scripts/github/RLearners/R/datVis_examples/hdi.csv',
                 stringsAsFactors = F)

data$GNI <- data$GNI / 1000

threeDPlot <- plot_ly(data,
                      x = ~LEX,
                      y = ~SCH,
                      z = ~GNI,
                      color = ~HDI) %>% add_markers() %>%
  layout(scene = list(xaxis = list(title = 'Life expectancy (yr)'),
                      yaxis = list(title = 'Mean years of school (yr)'),
                      zaxis = list(title = 'Gross National Income (PPP; $1,000)')));

threeDPlot

# USING RAYSHADER ----
# Limitations:
# - Not 'transparent'
# - Psuedo z axis
# - Can zoom in to examine microfeatures
#

library(rayshader); library(ggplot2) # library(rgl)

source("C:/Users/rshojin/Desktop/006_scripts/github/RLearners/R/create_dataframe.R")

df <- create_dataframe(min = -2, max = 2, step = 0.01)

fun3 <- function(x, y) -x * y * exp(-x^2 - y^2) 

df <- create_dataframe(min = -2 * pi, max = 2 * pi, step = pi / 72)

fun5 <- function(x, y) cos(abs(x) + abs(y))

df$z <- fun3(df$x, df$y)

for (i in 1) {

  a <- Sys.time()
  
  surfce <- ggplot() + geom_raster(aes(x = df$x, y = df$y, fill = df$z))

  plot_gg(surfce, multicore = TRUE, height = 5, width = 6, scale = 500)

  cat(paste0('That took ', round((as.numeric(Sys.time() - a)) / 60, 2),
             ' minutes\n')) # time in minutes
  
}

# DO THE SAME RAYSHADER IN PLOTLY ----
threeDPlot <- plot_ly(df, x = ~x, y = ~y, z = ~z) %>% add_markers()
