install.packages("MASS")
library(MASS)
library(help=MASS)
d1 = Cars93
dim(d1)
str(d1)
n = nrow(d1)
n

# SUBSETTING

d2 = d1[c(1:10),c(2,4,9)]
d2

d2 = data.frame(manufacturer = d1$Manufacturer, price = d1$Price)
head(d2)

d2 = subset(d1,select=c(Manufacturer,Price))
head(d2)

# Ford cars
d2 = subset(d1,subset = Manufacturer == "Ford")
dim(d2)
head(d2,8)

# cars weighting > 4000 
d2 = d1[d1$Weight>4000,]
d2
# there are four cars

# COUNTING

# number of cars by DriveTrain
names(d1)
# categories of DriveTrain
unique(d1$DriveTrain)
# number of cars
table(d1$DriveTrain)
# proportions
prop.table(table(d1$DriveTrain))

# count by two factors
table(d1$AirBags,d1$DriveTrain)

# MEASURING

# median weight per DriveTrain
tapply(d1$Weight,d1$DriveTrain,median)
# sorted
aux1 = tapply(d1$Weight,d1$DriveTrain,median)
sort1 = aux1[order(aux1)]
sort1

# SORTING

d2 = subset(d1,select=c(Manufacturer,Price,Weight,Width))
head(d2)

# sort by Width
d3 = d2[order(d2$Width),]
head(d3)









