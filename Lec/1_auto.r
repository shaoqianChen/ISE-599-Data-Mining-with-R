# auto.r

library(ISLR)
d1=Auto



str(d1)
d2 = d1[,-9]               # remove factor last col

# cylinders, year are also factors

# basic stats - make window wide
summary(d2)

apply(d2,2,mean)

summary(d2$mpg)

# PLOTTING
#=======================================================
# plot(cylinders, mpg)        # gives Error 

plot(d2$cylinders, d2$mpg)  # scatterplot

d2$cylinders=factor(d2$cylinders)

plot(mpg~cylinders,d2)      # boxplot

# histogram
mpg = d2$mpg
hist(mpg)
hist(mpg,freq=F)  # not relative freqs 
h1=hist(mpg,freq=F)
h1$breaks         # [1] 5 10 15 20 25 30 35 40 45 50
# not relative freq since bars width is not equal to 1

hh <-hist(mpg)
hh$counts = hh$counts/sum(hh$counts)
plot(hh)
plot(hh,xlim=c(0,60),ylim=c(0,0.25))

# add normal density
width1 = hh$breaks[2]-hh$breaks[1]
mu = mean(mpg)
stdev = sd(mpg)
plot(hh,xlim=c(0,60),ylim=c(0,0.3),main="")
curve(dnorm(x,mu,stdev)*width1,col="red",add=T)
grid()

# or use
# install.packages("HistogramTools")
library(HistogramTools)
PlotRelativeFrequency(hist(mpg))

# scatterplot
plot(d2$weight,d2$horsepower)
plot(horsepower~weight,d2,pch=19,cex=0.5)
grid()

unique(d2$origin)      # [1] 1 3 2
plot(horsepower~weight,d2,pch=19,cex=0.5,col=origin)
grid()

# legend
label = c("American","European","Japanese")
color = c(1,2,3)
char = c(19,19,19)
legend("bottomright",label,pch=char,cex=0.6,col=color)
legend(4500,75,label,pch=char,cex=0.6,col=color) 

# fitted line
plot(horsepower~weight,d2,pch=19,cex=0.5)
m1=lm(horsepower~weight,d2)
coefficients(m1)
abline(m1)
abline(m1,col="red")
abline(m1,col="red",lwd=2)
grid()

# predict mileage 
head(d2,3)

newval = data.frame(weight=3000)
predict(m1,newval)   # 105.34
                              
# outliers
res=resid(m1)
idx=which(res==max(res))   # 14

# locator
identify(d2$weight,d2$horsepower,rownames(d2),cex=0.5)  # rownames is default id
identify(d2$weight,d2$horsepower,d2$horsepower,cex=0.5)

d2[14,]

# label all points
text(horsepower~weight,data=d2,labels=rownames(d2),pos=1,offset=0.25,cex=0.5)

# just label the outlier
label = rep("",392)
res   = resid(m1)
idx   = which(res==min(res))
label[idx]=idx
text(horsepower~weight,d2,labels=label,pos=1,offset=0.5,cex=0.6,col=2)

# pairs
pairs(d2)
pairs(~ mpg + displacement + horsepower + weight + acceleration,d2,pch=19,cex=0.5)
pairs(~ mpg + displacement + horsepower + weight + acceleration,d1,pch=19,cex=0.5,col=d1$origin)

# load panel.hist() function
d3=d2[,-c(2,7:9)]
#pairs(d3,panel = panel.smooth,cex = 0.6,pch = 19,diag.panel = panel.hist,cex.labels = 0.8,font.labels = 1)


library(car)
scatterplotMatrix(~ mpg + displacement + horsepower + weight + acceleration,d2,pch=19,cex=0.5)

scatterplotMatrix(~ mpg + displacement + horsepower + weight + acceleration,d2,pch=19,cex=0.5,diagonal="histogram")

# mpg, displacement, hp, weight, acceleration seem correlated

# correlations
d3=d2[,-c(2,7,8)]
cov(d3)
cor(d3)

# boxplot
d3=d2
d3$origin=as.factor(d3$origin)
d3$year  =as.factor(d3$year)
d3$cylinders=as.factor(d3$cylinders)
plot(mpg~year,d3)
plot(mpg~cylinders,d3)


# outliers
plot(mpg~origin,d3)        # same as
boxplot(mpg~origin,d3)
Boxplot(mpg~origin,d3)     # library(car) required
a=Boxplot(mpg~origin,d3)
d3[a,]

# normality
qqnorm(d2$mpg)
qqline(d2$mpg)
grid()
hist(d2$mpg)

par(mfrow=c(2,1))
hist(d2$mpg,xlab="",main="mpg distribution")
boxplot(d2$mpg,horizontal=T,axes=F)
par(mfrow=c(1,1))

# compare sample vs theoretical quantiles
x = scale(d2$mpg)
mean(x)   # 0
qqnorm(x)

qqnorm(x,ylim=c(-3,3))
qqline(x)
grid()

a = seq(0,1,0.1)
a

quantile(x,a)
qnorm(a)

