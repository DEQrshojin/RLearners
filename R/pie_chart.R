# PIE CHARTS
#
# 'There is a tool for every job and a job for every tool.' - Tywin Lannister
#
# This example isn't here to pick a bone (not mostly). It is a real figure I'm creating
# For the Siletz River DO TMDL. It is a tongue and cheek demonstration of an alternative
# to facet_wrap(), which is applicable in 95 percent of all cases, but for the few...
#
# Bar chart criticisms:
# - Don't show trends                    - Not everything is a trend
# - Brain’s not good at comparing angles - Disagree, it's to get a visual relative sense
# - Reading accurate values is difficult - Not meant for providing precise values again,
#                                          but for visual relative
# - Lots of categories = complicated     - Then aggregate and keep it simple
#
# Provide a table of values to accompany the figure. Multiple displays provide
# Multiple means of consumption and target as many learning styles as practical.
#
# Basically, I think all of these arguments apply to any kind of visual display

# But also, I do think there are useful functions for the pie chart, as I'd like
# to make a case for...

# LIBRARIES ----
library(ggplot2); library(dplyr); library(forcats); library(reshape2)
library(grid); library(cowplot); library(ggpubr); library(gridExtra)

# DATA IMPORT AND ORGANIZATION ----
data <- read.csv('C:/Users/rshojin/Desktop/006_scripts/github/RLearners/R/siletz_loads.csv')

data <- melt(data = data,
             id.vars = 'HRU',
             measure.vars = c('A_sqkm', 'Q_GG', 'TN_t', 'TP_t', 'TOC_t'),
             variable.name = 'PAR',
             value.name = 'VAL')

# Remove NAs (to stop getting the warning message when plotting)
data <- data[complete.cases(data), ]

# PLOT THE DATA ----
windows(12, 12)

# Using polar coordinates
pieCht <- ggplot(data = data, aes(x = 1, y = VAL, fill = factor(HRU))) +
          geom_bar(width = 1, stat = 'identity') +
          facet_wrap(facets =. ~ PAR, nrow = 1); pieCht

pieCht <- ggplot(data = data, aes(x = 1, y = VAL, fill = factor(HRU))) +
          geom_bar(width = 1, stat = 'identity') +
          facet_wrap(facets =. ~ PAR, nrow = 1, scales = 'free'); pieCht

pieCht <- ggplot(data = data, aes(x = 1, y = VAL, fill = factor(HRU))) +
          geom_bar(width = 1, stat = 'identity') +
          facet_wrap(facets =. ~ PAR, ncol = 1); pieCht

pieCht <- ggplot(data = data, aes(x = 1, y = VAL, fill = factor(HRU))) +
          geom_bar(width = 1, stat = 'identity') +
          facet_wrap(facets =. ~ PAR, ncol = 1, scales = 'free'); pieCht

pieCht <- pieCht + coord_polar('y', start = 0); pieCht # BAH! Can't get this to work!

# TRY GRID.ARRANGE ----
data <- read.csv('C:/Users/rshojin/Desktop/006_scripts/github/RLearners/R/siletz_loads.csv')

data$LGD <- 0

# LABELS AND TITLES ----
# HRU legend labels 
srcs <- c('Agriculture', 'Forested', 'Grassland', 'Impervious', 'Septic', 'NPDES', 'Urban')

# Panel titles
ttls <- c('', 'Area', 'Discharge', 'Nitrogen', 'Phosphorus', 'Carbon', '')

# label units
lbls <- c('', 'ha', 'Ggal/yr', 'kg/yr', 'kg/yr', 'kg/yr', '')

# MAKE GGPLOT OBJECTS ----
pCht <- list()

for (i in 2 : length(data)) {
  
  temp <- data[, c(1, i)]; names(temp)[2] <- 'VAL'
  
  temp[which(is.na(temp$VAL)), 2] <- 0
  
  # Create the object
  pCht[[i]] <- ggplot(temp,
                  aes(x = 1,
                      y = VAL,
                      fill = HRU)) +
             geom_bar(width = 1, stat = 'identity')
  
  # Set the color scale
  pCht[[i]] <- pCht[[i]] + scale_fill_brewer(name = 'Hydrologic\nResponse Unit',
                                             palette = 'Set2', labels = srcs)
  
  # Plot to polar
  pCht[[i]] <- pCht[[i]] + coord_polar('y', start = 0); pCht[[i]]
  
  # Remove axes
  pCht[[i]] <- pCht[[i]] + theme(panel.grid.major = element_blank(),
                                 panel.grid.minor = element_blank(),
                                 panel.background = element_blank(),
                                 axis.title.y = element_blank(),
                                 axis.title.x = element_blank(),
                                 axis.text.x = element_blank(),
                                 axis.text.y = element_blank(),
                                 axis.ticks = element_blank(),
                                 plot.title = element_text(size = 16, hjust = 0.5))
  
  # Add legend as the last panel in the figure 
  if (i == length(data)) {pCht[[i]] <- pCht[[i]] +
                                       theme(legend.position = c(0.5, 0.7),
                                             legend.text = element_text(size = 11),
                                             legend.title = element_text(size = 12))}
  
  if (i != length(data)) {pCht[[i]] <- pCht[[i]] + theme(legend.position = 'none')}

  # Add the title
  pCht[[i]] <- pCht[[i]] + ggtitle(label = ttls[i])
  
  # For labeling the wedges, but couldn't get it to work in time for the preso...
  # pCht[[i]] <- pCht[[i]] + annotate('text', x = 2, y = temp$VAL, size = 2,
  #                                   label = paste0(round(temp$VAL, 0), ' ', lbls[i]))

}

pCht[[1]] <- NULL

# ARRANGE IN A GRID ----
awesum <- grid.arrange(pCht[[1]], pCht[[2]], pCht[[3]], pCht[[4]], pCht[[5]],
                       pCht[[6]], nrow = 2, ncol = 3)

ggsave(filename = 'awesome_pie_chart_example.png', plot = awesum,
       path = 'C:/Users/rshojin/Desktop/006_scripts/github/RLearners/R',
       width = 6, height = 4, dpi = 300, units = "in")

# PUT A TITLE ON IT ----
ttl <- text_grob('Nutrient Source Assessment', just = c(0.5, 1), color = "black",
                 face = "plain", size = 21)

# Must be a matrix
layout <- rbind(c(1, 1, 1),
                c(2, 3, 4),
                c(5, 6, 7))

awesum_Ttl <- grid.arrange(ttl, pCht[[1]], pCht[[2]], pCht[[3]], pCht[[4]], pCht[[5]],
                           pCht[[6]], nrow = 3, ncol = 3, layout_matrix = layout,
                           heights = c(0.8, 3, 3), widths = c(3, 3, 3))

ggsave(filename = 'awesomer_pie_chart_example.png', plot = awesum_Ttl,
       path = 'C:/Users/rshojin/Desktop/006_scripts/github/RLearners/R',
       width = 9, height = 6.8, dpi = 300, units = "in")


