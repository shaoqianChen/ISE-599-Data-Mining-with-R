# exercise1.r

set.seed(1)
# create the population
p = 0.30
N = 1000
population = rbinom(N,1,p)
table(population)

# collect a sample
n = 50
# row numbers
id = sample(1:N,n)
# row values (0 or 1)
obs = population[id]

# CI from the sample
alpha = 0.05
z_alpha = qnorm(1-alpha/2)
z_alpha

# find phat and its standard deviation
table(obs)
phat = 20/50

sdev = sqrt(phat*(1-phat)/n)
sdev

# the confidence interval
lb = phat - z_alpha*sdev
ub = phat + z_alpha*sdev
c(lb,ub)
# 0.2642097 0.5357903
# this CI covers p = 0.30

# using binom.test 
binom.test(20,50,0.30)
binom.test(20,50,0.30)$conf.int
# 0.2640784 0.5482060

# confidence intervals found by hand and by using binom.test agree

# Many confidence intervals
M = 100
lb = rep(0,M)
ub = rep(0,M)
phat = rep(0,M)

for(i in 1:M)
{
  id = sample(1:N,n)
  obs = population[id]
  ob_successes = table(obs)[2]
  phat[i] = ob_successes/n
  sdev = sqrt(phat[i]*(1-phat[i])/n)
  lb[i] = phat[i] - z_alpha*sdev
  ub[i] = phat[i] + z_alpha*sdev
}

i = 1:M
d1 = data.frame(i,lb,ub)
head(d1)

# plot CIs
plot(ub~i,xlim=c(0,M),ylim=c(0,1),ylab='',xlab='sample',type = 'n')
segments(i,lb,i,ub)
abline(h=0.30,col='red',lty=2)

# show CIs that fail to cover p=0.3
color = rep('black',M)
# rows of CIs that fail to cover p
idx = NULL

for(i in 1:M)
{
  if(0.3 < lb[i] | 0.3 > ub[i])
  {
    color[i] = 'red'
    idx = c(idx,i)
  }
}

table(color)
# there are 8 red colored CIs

# CIs that failed are in rows
idx
# see the CIs that failed
d1[idx,]


# plot CIs with those that failed
i = 1:M
plot(ub~i,xlim=c(0,M),ylim=c(0,1),ylab='',xlab='sample',type = 'n')
segments(i,lb,i,ub,col=color)
abline(h=0.30,col='red',lty=2)

# histogram of phat values
hist(phat,main='')
# to center the histogram
h1 = hist(phat)
h1$breaks
# change the breaks
aux = seq(0.075,0.525,0.05)
aux
hist(phat,breaks = aux, col='lightblue', xlim = c(0,0.6),main='')
abline(v=0.3,col='red',lty=2)

summary(phat)

















