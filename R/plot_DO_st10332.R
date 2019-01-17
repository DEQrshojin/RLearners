library(AWQMSdata)
library(ggplot2)
library(scales)

#pull DO data from station 10332 in AWQMS- one of our older stations - Brian would like a graph to show what is in AWQMS
dopull<-AWQMS_Data(startdate = '1949-09-15', enddate = '2018-12-03', station = c('10332-ORDEQ'), char = c('Dissolved oxygen (DO)') , media = c('Water') , org = c('OREGONDEQ') )

#make sure all data is in mg/l
unique(dopull$Result_Unit)

# create graph that plots DO over time, add vertical line that indicates year
# clean water act happened change result from character to numeric

ggplot(data=dopull,aes(x=SampleStartDate,y=as.numeric(Result)))+
  geom_point()+
  geom_line()+
  scale_x_date(name="Sample Date",date_breaks="5 years",
               date_minor_breaks="1 year",date_labels="%Y")+
  scale_y_continuous(breaks=seq(0,15,by=1),name="Dissolved Oxygen (mg/L)")+
  #add line for Clean Water Act implementation
  geom_vline(xintercept=1972,color="blue", size=1.5)+
  theme_light()
