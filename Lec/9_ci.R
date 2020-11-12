# ci.r

library(ggplot2)

headlines= c('A','B','C')
clicks = c(405,380,490)
visits = c(900,950,1000)
d0 = rbind(clicks,visits)
d0 = data.frame(d0)
names(d0) = headlines
d0
#
# observed frequencies table
#
noclicks = visits - clicks
noclicks
observed = data.frame(rbind(clicks,noclicks))
names(observed) = headlines
observed
#
# expected freqs
#
pooled = sum(clicks)/sum(visits)
pooled

expected_clicks = pooled*visits
expected_noclicks = (1-pooled)*visits
expected = data.frame(rbind(expected_clicks,expected_noclicks))
names(expected) = headlines
expected
#
# Chi-square test
#
chisquare = 0
for(i in 1:2)
{
  for(j in 1:3)
  {
    value = ((observed[i,j]-expected[i,j])^2)/expected[i,j]
    chisquare = chisquare + value
  }
}
#
# the OTS is
#
chisquare
# 
# p-value
pvalue = 1 - pchisq(chisquare,2)
pvalue
#
# reject Ho
#
# R function
# 
prop.test(clicks,visits)
#
# conclude Ha: not all headline click-rates are equal
# 
# to find best headline use CIs
# 
d0
#
# will do
#
test = binom.test(405,900)
test
test = binom.test(380,950)
test = binom.test(490,1000)
# 
props = NULL
lls = NULL
uls = NULL

test = binom.test(405,900)
test
props = c(props,test$estimate)
int = test$conf.int
int
lls = c(lls,int[1])
uls = c(uls,int[2])

test = binom.test(380,950)
test
props = c(props,test$estimate)
int = test$conf.int
int
lls = c(lls,int[1])
uls = c(uls,int[2])

test = binom.test(490,1000)
test
props = c(props,test$estimate)
int = test$conf.int
int
lls = c(lls,int[1])
uls = c(uls,int[2])

d = data.frame(headlines,props,lls,uls)
d
# plot
ggplot(data=d) +
  geom_errorbar(mapping = aes(x=headlines,ymin=lls,ymax=uls),width=0.1) +
  geom_point(mapping = aes(x=headlines,y=props),size = 3)
#
# R function mapply
# 
# the following command gives an error
#
# tests = mapply(binom.test(clicks,visits))
#
test = function(x,n){binom.test(x,n)}
out = mapply(test,clicks,visits)
out
class(out)
class(out[1,1])
# using mapply this way is a matrix of lists
#
out[4,1]
out[4,1]$conf.int[1]
out[4,1]$conf.int[2]
#
# collect all CIs lower limits
for(i in 1:3) lls[i] = out[4,i]$conf.int[1]
# collect all CIs upper limits
for(i in 1:3) uls[i] = out[4,i]$conf.int[2]
#
d = data.frame(headlines,props,lls,uls)
d
# 
# Suppose that we obtained larger samples
#
clicks = 10*clicks
visits = 10*visits

d0 = rbind(clicks,visits)
d0 = data.frame(d0)
names(d0) = headlines
d0
out = mapply(test,clicks,visits)
# collect all CIs limits
for(i in 1:3) lls[i] = out[4,i]$conf.int[1]
for(i in 1:3) uls[i] = out[4,i]$conf.int[2]
#
d = data.frame(headlines,props,lls,uls)
d

ggplot(data=d) +
  geom_errorbar(mapping = aes(x=headlines,ymin=lls,ymax=uls),width=0.1) +
  geom_point(mapping = aes(x=headlines,y=props),size = 3)
#






