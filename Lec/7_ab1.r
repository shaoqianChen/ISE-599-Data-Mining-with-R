# ab1.r

library(ggplot2)
#
# Session times for websites A and B
times1 <- read.csv('web_page_data.csv')
times1[,2] <- times1[,2] * 100
str(times1)
head(times1)
# number of session times for each website
table(times1$Page)
# average session time for each website
aux = tapply(times1$Time,times1$Page,mean)
aux
obs_diff = aux[2]-aux[1]
#
# how likely is this difference to be observed if average session times are equal?
#
# boxplot comparing the distribution of session times
ggplot(times1, aes(x=Page, y=Time)) + 
  geom_boxplot() +
  labs(y='Time (in seconds)') + 
  theme_bw()
#
# PERMUTATION TEST
#
# randomly group 21 and 15 times, then find difference of their average times
# repeat many times finding the distribution of differences of average times
# if obs_diff is out of the range of the distribution 
# then conclude that the true difference of average session times is not zero
# and therefore one webpage results in longer session times, on average.
#
# note: setdiff(x,y) collects those elements in x but not in y
#
# x: vector of numeric values
# n1: group A
# n2: group B
# 
# find difference (mean of group B values - mean of group A values) 
#
function1 <- function(x, n1, n2)
{
  n <- n1 + n2
  idx_b <- sample(1:n, n1)
  idx_a <- setdiff(1:n, idx_b)
  mean_diff <- mean(x[idx_b]) - mean(x[idx_a])
  return(mean_diff)
}

# dist of 1000 differences between session times of two groups randomly chosen
set.seed(1)
differences <- rep(0, 1000)
times = times1$Time
for(i in 1:1000) differences[i] = function1(times, 21, 15)
hist(differences, xlab='Difference of average session times (seconds)', main='')
abline(v = obs_diff, col='red')

# proportion of TRUE in a sequence of logical obs 
aux = c(TRUE,TRUE,TRUE,FALSE,TRUE,TRUE)
aux
sum(aux)
mean(aux)

# proportion of session times beyond redline (p-value approximation)
mean(differences > obs_diff) 
#
# t-test (p-value)
t.test(Time ~ Page, data=times1, alternative='less' )
#
# p-value agrees with that of permutation test
# 
test1 = t.test(Time ~ Page, data=times1, alternative='less' )
str(test1)
test1$p.value
#
#
# PROPORTIONS
#
# p1, p2 population proportion of bath soap sales with designs 1 and 2
# First design is better if p1 > p2

d0 = read.csv("Xm13-09.csv",header=T)
head(d0)
#
# table shows scanner codes for different brands
# focus on 9077
tail(d0)
# number of sales in the Supermarkets is different

# rename cols
names(d0) = c("s1","s2")
dim(d0)

# soap brands purchased at Supermarket 1
table(d0$s1)
# 180 bath soaps sold in Supermarket 1
#
# soap brands purchased at Supermarket 2
table(d0$s2)
# 155 bath soaps sold in Supermarket 2
#
x = c(180,155)

# number of purchases at each Supermarket
sum(table(d0$s1))
sum(table(d0$s2))

# number of soaps from all brands sold in 1-week
n1 = sum(table(d0$s1))
n2 = sum(table(d0$s2))
n = c(n1,n2)

# number of bath soaps sold from other brands
others = n-x

# table of counts
d2 = rbind(x,others,n)
rownames(d2) = c("brand","others","total")
colnames(d2) = c("Super1","Super2")
d2

# sample proportions
p1 = 180/904
p1
p2 = 155/1038
p2
obs_diff = p1 - p2
obs_diff
# 
# Is this difference due to different designs or to random chance?

# ignore total sales row
d1 = d2[1:2,]
d1
# sum by row
apply(d1,1,sum)
# total soaps sold
sum(apply(d1,1,sum))
#
# create a vector of 335 ones, 1607 zeros
vector1 <- c(rep(0, 1607), rep(1, 335))
#
# one to represent a transaction from our brand
# zero for a transaction from other brand
#
# total number of sales by SuperMarket
d2[3,]
#
# PERMUTATION TEST
#
# For Supermarket 1, select sample of 904 sales, 
# record number of ones in this sample
# find proportion of ones in this sample
# For Supermarket 2, 
# count number of ones in the remaining 1038 rows
# find proportion of ones in these remaining rows
#
# find difference between the 2 proportions
# repeat 1000 times
#
differences <- rep(0, 1000)
#
set.seed(1)
for(i in 1:1000) differences[i] = function1(vector1,904,1038)
hist(differences, xlab='Differences in proportions', main='')
abline(v = obs_diff, lty=2, lwd=1.5,col='red')
text("0.04978", x=0.03,y=200,adj=0,col='red')

# fraction beyond redline (approx p-value)
mean(differences > obs_diff)
#
# test on two (or more) proportions
#
x
n
prop.test(x,n, alternative="greater")
#
# p-values from random sampling and test on proportions agree
#
# p-value is smaller than alpha
# reject Ho: p1 = p2
# conclude p1 > p2
# Company should use design 1
#
# get p-value alone
#
prop.test(x,n, alternative="greater")$p.value
