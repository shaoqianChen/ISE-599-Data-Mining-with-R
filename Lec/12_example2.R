# example2.r

library(lubridate)    # mdy_hms()
library(dplyr)
library(ggmap)
ggmap::register_google(key="AIzaSyBCTRLhjpC0qjz5JG3UCKVtjXS1zdjo_iU")
#
# https://www.data.gov
#
# search seattle 911 calls, choosing call data City of Seattle
#
# this file is quite big, instead we will work with a smaller data set
# 
d0 = read.csv("i2Sample.csv")
dim(d0)
names(d0)
#
# subset by year using column 9
names(d0)[9]
d0$Event.Clearance.Date[1]
#
d0$ymd = mdy_hms(d0$Event.Clearance.Date)
d0$year = year(d0$ymd)
unique(d0$year)
#
# select 2017, 2018
d2 = d0 %>% filter(year %in% c(2017,2018))
dim(d2)
#
n =read.csv("n.csv")
n
n$label = paste(n$Rank,n$Location,sep="-")
n
#
geocode("Seattle")
Seattle.map = get_googlemap(center = c(lon = -122.335,lat = 47.608),
                            zoom = 11, scale = 2)
p = ggmap(Seattle.map)
p + geom_point(data = d2,aes(x = Longitude, y = Latitude),size = 0.5, alpha=0.3)
#
# include cities
#
p + geom_point(data = d2,aes(x = Longitude, y = Latitude),size = 0.5, alpha=0.3) +
  geom_point(data = n, aes(x = x, y = y),colour = 'red',size = 3) +
  geom_label(data = n, aes(x,y,label = label),family = 'Times', size = 4)
# 
# avoid overlapping
#
library(ggrepel)
p + geom_point(data = d2,aes(x = Longitude, y = Latitude),size = 0.5, alpha=0.3) +
  geom_point(data = n, aes(x = x, y = y),colour = 'red',size = 3) +
  geom_label_repel(data = n, aes(x,y,label = label),family = 'Times', size = 4)
# 
# density chart
#
# subset d2 even further
#
unique(d2$Event.Clearance.Group)

i2Sub = filter(d2, Event.Clearance.Group %in% c('TRAFFIC RELATED CALLS','DISTURBANCES','SUSPICIOUS CIRCUMSTANCES',
                                                'MOTOR VEHICLE COLLISION INVESTIGATION'))
#
p + stat_density2d(data = i2Sub,aes(x = Longitude, y = Latitude,alpha = ..level..),
                   size = 0.2,bins = 30, geom = 'polygon')
#
# facet wrap
#
p + stat_density2d(data = i2Sub,aes(x = Longitude, y = Latitude,alpha = ..level..),
                   size = 0.2,bins = 30, geom = 'polygon') +
  facet_wrap(~Event.Clearance.Group,nrow = 2)
# 
# facet wrap on geom_point
#
p + geom_point(data = i2Sub,aes(x = Longitude, y = Latitude),alpha = 0.2,size = 1) +
  facet_wrap(~Event.Clearance.Group,nrow = 2)























