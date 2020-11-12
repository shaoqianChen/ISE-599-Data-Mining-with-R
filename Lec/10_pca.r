# pca.r    James p401

d1=USArrests
dim(d1)             # [1] 50  4
head(d1)                            
#
# a) Original data -no scaling-
#
# covariance matrix
var(d1)
apply(d1,2,var)
#
# column variances appear on main diagonal of cov matrix
#
# eigenvalues
#
eigen(var(d1))
#
sum(eigen(var(d1))$values)  
sum(apply(d1,2,var))
#
# sum of eigenvalues = sum variances
#
# b) SCALED DATA
#
m1=prcomp(d1, scale=T)
names(m1) 
#
# "sdev": square-root of eigenvalues of columns of transformed data (of PCs)
# "rotation": matrix of eigenvectors
# "center"   "scale": # mean and sd of original data -unscaled-
# "x": transformed data set 
#
# means -unscaled data
#
m1$center
#
# standard deviations -unscaled data
#
m1$scale
apply(d1,2,sd)
#
# rotation matrix has the eigenvectors
#
m1$rotation
eigen(var(scale(d1)))
#
# squared-root of eigenvalues of scaled data
m1$sdev
#
# transformed data on PC axes
d2 = m1$x
dim(d2)
head(d2)
apply(d2,2,mean)
#
# PCs are centered (their means are zero)
#
# eigenvalues of scaled data
#
m1$sdev^2
apply(d2,2,var)
#
# eigenvalues of cov matrix (of scaled data) = variances of Principal components
#
# eigen() function
#
cova=var(scale(d1))

m2 = eigen(cova)

# covariance matrix of transformed data
var(d2)

round(var(d2),5)
#
# This is Big lambda diagonal matrix (eigenvalues on main diagonal)
sum(diag(var(d2)))      # 4

# covariances (off diagonal) all equal to 0  (PCs uncorrelated)
# PC1 with largest variance across states

# Use eigenvectors to define the PC variables.

m1$rotation
#
# Score vectors are PC1, PC2, defined as follows

# PC1 = 0.536 Murder + 0.58Assault + 0.28 UrbanPop + 0.543 Rape
# A weighted average of crime rates (almost exclude UrbanPop)

# PC2 = 0.4 Murder - 0.87 UrbanPop
# Weighted average of Urban Pop and Murder


# transformed variables in the principal components space.
#==============================================================
# eigenvectors span a new p-dimensional space
# score vectors are the transformed data in this new space
d2 = m1$x
head(d2)
tail(m1$x)
#
# Variance of the PCs are the eigenvalues 
#================================================================

apply(d2,2,var)
m2$values
#
# proportion of variance explained (PVE) by each PC
#============================================================

# variance of PCs
aux=m1$sdev^2

sum(aux)   # 4
pve=aux/sum(aux)
pve
m2$values/4
# each eigenvalue divided by 4
#
cumsum(pve) 
#
#  87% variability in the dataset explained by PC1 and PC2

# plots
plot(pve, xlab="PC", ylab="% of Variance Explained", ylim=c(0,1),type='l')
grid()

plot(cumsum(pve), xlab="PC", ylab="Cumulative % of Variance Explained", ylim=c(0,1),type='l')
grid()
#
# biplots
#
biplot(m1, scale=0,cex=0.6)
grid()
#
head(d2)
#
# rowname is State name, located at (PC1,PC2) coordinates
#
# Rotate original axes (red colored)
#
# mirror image
#
m1$rotation=-m1$rotation
m1$x=-m1$x
biplot(m1, scale=0,cex=0.6)
grid()
#
rot=m1$rotation
#
# Murder axis identified
#
slope1=rot[1,2]/rot[1,1]
slope1   # -0.7803345
abline(0,slope1)

# interpret the PCs
#=================================================================
m1$rotation
# states with large values in PC1 have high crime rates 
#       (PC1 weights -col1- in rotation are 0.5359, 0.5831, 0.5434)
# California, Nevada, Florida   vs   North Dakota, Vermont                                    

# states with large values in PC2 have large urban areas
#       (PC2 largest weight -col2- in rotation is 0.8728)
# California  vs   Mississippi 

# original vs transformed values
#============================================================
d3=data.frame(d1,d2)
head(d3)
tail(d3)



