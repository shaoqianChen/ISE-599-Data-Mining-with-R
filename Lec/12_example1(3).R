# example1.r

# install ggmap library
# devtools::install_github('dkahle/ggmap')

library(ggmap)
ggmap::register_google(key = "AIzaSyBCTRLhjpC0qjz5JG3UCKVtjXS1zdjo_iU")

library(dplyr)
library(readr)
#
# quick map
# 
qmap("Montana",zoom=6)
#
# get a map
#
myMap = get_map(location="California",zoom=6)
ggmap(myMap)
#
# qmap does both (get_map, ggmap)
#
# record map for ggplot
#
p = ggmap(myMap)
#
# read a dataframe
#
dfWildfires = read_csv("StudyArea_SmallFile.csv")
names(dfWildfires)
#
# select columns
#
df = select(dfWildfires,STATE,YEAR_,TOTALACRES,DLATITUDE,DLONGITUDE)
head(df,12)
#
# filter for fires greater than 1000 acres in CA
df = filter(df,TOTALACRES >= 1000 & STATE == "California")
# 
# plot fires on the map
#
p + geom_point(data=df,aes(x=DLONGITUDE,y=DLATITUDE),size = 1.5)
#
# group fires by decade
df = mutate(df,DECADE=ifelse(YEAR_%in% 1980:1989,"1980-1989",
                             ifelse(YEAR_%in% 1990:1999,"1990-1999",
                                    ifelse(YEAR_%in% 2000:2009,"2000-2009",
                                           ifelse(YEAR_%in% 2010:2016,"2010-2016","-99")))))
# 
# show fires (TOTALACRES by size)
p + geom_point(data=df,aes(x=DLONGITUDE,y=DLATITUDE,colour = 'red',
                           size = TOTALACRES,alpha = 0.7)) +
  theme(legend.position = 'none')
#
# show fires (DECADE by color, TOTALACRES by size)
p + geom_point(data=df,aes(x=DLONGITUDE,y=DLATITUDE,colour = DECADE,
                           size = TOTALACRES,alpha = 0.7))
#
SanDiego.map = get_map(location = "San Diego, California",zoom = 9) 
s = ggmap(SanDiego.map)
s + geom_point(data=df,aes(x=DLONGITUDE,y=DLATITUDE,colour = DECADE,size = TOTALACRES))
#
# contour map for California
# 
p + geom_density2d(data=df,aes(x=DLONGITUDE,y=DLATITUDE),size = 0.3)
#
# heat map for California
p + stat_density2d(data=df,aes(x=DLONGITUDE,y=DLATITUDE,fill=..level..,alpha=..level..),
                   size = 0.01,bins = 16,geom = "polygon") +
  scale_fill_gradient(low = "green", high = "red") +
  scale_alpha(range = c(0,0.3), guide = FALSE)
#
# heat map with contour lines for California
p + stat_density2d(data=df,aes(x=DLONGITUDE,y=DLATITUDE,fill=..level..,alpha=..level..),
                   size = 0.01,bins = 16,geom = "polygon") +
  geom_density2d(data=df,aes(x=DLONGITUDE,y=DLATITUDE),size = 0.3) +
  scale_fill_gradient(low = "green", high = "red") +
  scale_alpha(range = c(0,0.3), guide = FALSE)
#
# CA facet heatmap by year
#
df = filter(dfWildfires,STATE == 'California')
df = filter(df,YEAR_ %in% c(2011,2012,2013,2014,2015,2016))
#
p + stat_density2d(data=df,aes(x=DLONGITUDE,y=DLATITUDE,fill=..level..,alpha=..level..),
                   size = 0.01,bins = 16,geom = "polygon") +
  scale_fill_gradient(low = "green", high = "red") +
  scale_alpha(range = c(0,0.3), guide = FALSE) +
  facet_wrap(~YEAR_)












