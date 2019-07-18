# R USERS GROUP
# DATA VISUALIZATION
#
# Ryan Shojinaga, Water Quality Analyst, 
#
# 2020 Democratic Presidential Nominee Endorsements
# From Fivethirtyeight.com:
# https://projects.fivethirtyeight.com/2020-endorsements/democratic-primary/?ex_cid=rrpromo
#
# I selected this graph because I wanted to show Dan Sobota that stacked bar charts
# are fun AND informative, man! Neither I nor DEQ endorses Democrats, any of the
# candidates, or the content of this website. It's just that Fivethirtyeight
# remains a favorite place to look at cool graphics, regardless of the what they're
# saying. I think they blend simplicity and complexity well. Let's dig a deeper...

# LIBRARIES ----
library(ggplot2); library(dplyr); library(forcats)

# DATA IMPORT AND ORGANIZATION ----
data <- read.csv('C:/Users/rshojin/Desktop/006_scripts/github/RLearners/R/endorsements.csv')

# The data explicitly say the number of points that candidate for each endorsement,
# but the bar chart wants a total count to the number of points, so each endorsement
# line needs to be expanded to the number of points that endorsement garners.
# Is there a better way to do this? And if not, is there a better way to do it than
# The way I do it here?
# 
# Expand the data out for each line so that the bar graph reads each entry
dat2 <- data[which(data$Candidate == 'Ryan Shojinaga'), ]

for (i in 1 : nrow(data)) {
  
  if (!is.na(data[i, 5])) {
    
    for (j in 1 : data[i, 5]) {dat2 <- rbind(dat2, data[i, ])
    
    }
  }
}

# REORDER THE CANDIDATES ----
for (i in 1) {
  
  reOrdr <- data.frame(cand = sort(unique(dat2$Candidate)))
  
  reOrdr <- reOrdr %>% mutate(oOrd = as.numeric(rownames(reOrdr)))
  
  endCnt <- dat2 %>% count(Candidate); endCnt <- endCnt[order(endCnt$n, decreasing = F), ]
  
  endCnt$nOrd <- rownames(endCnt)
  
  reOrdr <- merge(reOrdr, endCnt, by.x = 'cand', by.y = 'Candidate')
  
  reOrdr$nOrd <- as.numeric(reOrdr$nOrd)
  
  reOrdr <- reOrdr[order(reOrdr$nOrd), ]
  
  dat2$Candidate <- factor(dat2$Candidate,
                           levels(factor(dat2$Candidate))[unlist(reOrdr$oOrd)])
  
}

# GRAPH IT! ----
windows(12, 12)

# Create the base graph ----
endr <- ggplot(data = dat2, aes(Candidate)) + geom_bar(); endr

# Shade different endorsement points  ----
# - Doesn't work!! 
endr <- ggplot(data = dat2, aes(Candidate, fill = Point.value)) + geom_bar(); endr

# Shade different endorsement points ----
# - Oh yeah, duh.
endr <- ggplot(data = dat2, aes(Candidate, fill = as.factor(Point.value))) +
  geom_bar(); endr

# Shade in blue ----
endr <- endr + scale_fill_brewer(palette = "Blues"); endr

# Flip the coordinates ----
endr <- endr + coord_flip(); endr

# Reverse the order of the endorsement points ----
endr <- ggplot(data = dat2,
               aes(Candidate,fill = forcats::fct_rev(as.factor(Point.value)))) +
  geom_bar() + coord_flip() +
  scale_fill_brewer(palette = "Blues", direction = -1); endr

# Need to make the labels for legend ----
lblsAdd <- c('- Former POTUS & VPOTUS\n- Current part-eh leaders',
             '- Gubnahs',
             '- U.S. Senators',
             '- Former prez & VP nominees\n- Former part-eh leaders\n- 2020 prez drop-outs',
             '- U.S Reps\n- Mayors (e.g., LA or NY)',
             '- State elected officials & leg folk',
             '- DNC members')

lbls <- paste0(unique(dat2$Point.value)[order(unique(dat2$Point.value), decreasing = T)],
               ' points\n', lblsAdd)

lblsAdd <- c('- Former POTUS & VPOTUS\n- Current part-eh leaders\n',
             '- Gubnahs\n',
             '- U.S. Senators\n',
             '- Former prez & VP nominees\n- Former part-eh leaders\n- 2020 prez drop-outs\n',
             '- U.S Reps\n- Mayors (e.g., LA or NY)\n',
             '- State elected officials & leg folk\n',
             '- DNC members\n')

lbls <- paste0('\n', unique(dat2$Point.value)[order(unique(dat2$Point.value), decreasing = T)],
               ' points\n', lblsAdd)

# Reverse the order of the endorsement points ----
endr <- ggplot(data = dat2,
               aes(Candidate,fill = forcats::fct_rev(as.factor(Point.value)))) +
        geom_bar() + coord_flip() +
        scale_fill_brewer(palette = "Blues", direction = -1, labels = lbls); endr

# Clean up style ----
endr <- endr + theme_minimal() +
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank(), axis.title.y = element_blank(),
              axis.title.x = element_blank(), axis.text.x = element_blank(),
              axis.text.y = element_text(hjust = 0, size = 12)); endr

# Add the labels -- Use the reOrdr data frame ----
endr <- endr + annotate('text', reOrdr$nOrd[nrow(reOrdr)], reOrdr$n[nrow(reOrdr)] + 10,
                        label = paste0(reOrdr$n[nrow(reOrdr)], ' points')); endr

endr <- endr + annotate('text', reOrdr$nOrd[1 : (nrow(reOrdr) - 1)],
                        reOrdr$n[1 : (nrow(reOrdr) - 1)] + 5,
                        label = reOrdr$n[1 : (nrow(reOrdr) - 1)]); endr

endr <- endr + scale_y_continuous(limits = c(0, 115)); endr

# Legend ----
endr <- endr + theme(legend.title = element_blank(),
                     legend.text = element_text(size = 11)); endr

ggsave(filename = 'awesome_bar_chart_example.png', plot = endr,
       path = 'C:/Users/rshojin/Desktop/006_scripts/github/RLearners/R',
       width = 10, height = 8, dpi = 300, units = "in")

