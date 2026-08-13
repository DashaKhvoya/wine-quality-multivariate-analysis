# Baranchikova Daria

#==========================PCA==========================
# read data
red <- read.csv("../data/winequality-red.csv", sep = ";")
white <- read.csv("../data/winequality-white.csv", sep = ";")

# structure of data set
str(red)
str(white)

# adding color in data set
red$color <- factor("red", levels = c("red", "white"))
white$color <- factor("white", levels = c("red", "white"))

# union of red and white wines into one set
wine_data <- rbind(red, white)
str(wine_data)
summary(wine_data)
                  
# PCA excluding target quality column
wine_features <- subset(wine_data, select = -c(quality, color))
summary(wine_features)
pca.wine <- prcomp(wine_features, center = TRUE, scale. = TRUE)
pca.wine

# Variance explained by each principal component
lambda <- pca.wine$sdev^2
tau <- cumsum(lambda) / sum(lambda) # cumulative proportion
scree <- lambda / sum(lambda) # proportion

# Selecting the number of components
pdf("pca_selection_plots.pdf", width = 13, height = 6)
par(mfrow=c(1,2),
	cex.lab = 1.3,
	cex.axis = 1.2,
	font.lab = 2,
	mar = c(5, 5, 2, 5))
## Graphical representation of cumulated proportion of variance explained
plot(tau,
	 type = "b",
	 pch = 19,
	 col = "blue",
	 xlab = "Principal Components",
	 ylab = "Cumulative variance")
abline(h = 0.85, col = "darkgreen", lty = 2)
text(x = 1,
	 y = 0.87,
	 labels = "85%",
	 col = "darkgreen",
	 pos = 4,
	 cex = 1.2)
## Scree plot of variance explained by the q-th PC
plot(scree,
	 type = "b",
	 pch = 19,
	 col = "blue",
	 xlab = "Principal Components",
	 ylab = "Proportion of Variance")
abline(h = 0.05, col = "darkgreen", lty = 2)
text(x = 1,
	 y = 0.06,
	 labels = "5%",
	 col = "darkgreen",
	 pos = 4,
	 cex = 1.2)
dev.off()

# The correlation between original variables Xi and PCs.
r.pc.x <- cor(wine_features, pca.wine$x)
r.pc.x

# Plot correlation within PCs coordination system
pdf("pca_vars_PC1vsPC2.pdf", width = 10, height = 10)
par(cex.lab = 1.3,
	cex.axis = 1.2,
	font.lab = 2)
plot(cos((0:360)/180*pi),
	 sin((0:360)/180*pi),
	 type = "l",
	 lty = "dashed",
	 lwd = 3, col = "red",
	 xlab = "First PC",
	 ylab = "Second PC",
	 asp = 1)
abline(h = 0, v = 0, col = "gray40", lty = "solid", lwd = 0.5)
text(r.pc.x[,1:2],
	 labels = colnames(wine_features),
	 cex = 1.2,
	 col = "blue",
	 font = 1)
dev.off()

# Projection of observations with division by wine type
pdf("pca_observations_by_type_PC1vsPC2.pdf", width = 10, height = 10)
par(cex.lab = 1.3, cex.axis = 1.2, font.lab = 2)
plot(pca.wine$x[,c(1,2)],
	 pch = 19,
	 col = adjustcolor(c("red", "blue")[wine_data$color], alpha.f = 0.2),
	 xlab = "First PC",
	 ylab = "Second PC",
	 cex = 0.7,
	 xlim = c(-5, 5),
	 ylim = c(-8, 5))
legend("topright",
	   legend = levels(wine_data$color),
	   col = c("red", "blue"),
	   pch = 19)
dev.off()

# Projection of observations with division by quality (3-4 = bad, 5-6 = medium, 7-8-9 = good)
wine_data$quality_type <- cut(wine_data$quality,
						      breaks = c(2, 4, 6, 9),
						      labels = c("bad", "medium", "good"),
						      right = TRUE)
table(wine_data$quality_type)
levels(wine_data[,14])
pdf("pca_observations_by_quality_PC1vsPC2.pdf", width = 10, height = 10)
par(cex.lab = 1.3,
	cex.axis = 1.2,
	font.lab = 2)
plot(pca.wine$x[,1:2],
	 pch = c(1,2,3)[wine_data$quality_type],
	 col = c("blue", "darkgreen", "red")[wine_data$quality_type],
	 xlab = "First PC",
	 ylab = "Second PC",
	 cex = 0.7,
	 xlim = c(-5, 5),
	 ylim = c(-8, 5))
legend("topright",
	   legend = levels(wine_data$quality_type),
	   col = c("blue", "darkgreen", "red"),
	   pch = c(1,2,3))
dev.off()

# Projection of observations with division by quality for every pair of PCs
pdf("pca_pairs_quality_PC1vsPC2.pdf", width = 10, height = 10)
par(mfrow = c(5, 5), cex.lab = 1.3, cex.axis = 1.2)
for (i in 1:5) {
  for (j in 2:6) {
    if (j > i) {
      plot(pca.wine$x[, i],
      	   pca.wine$x[, j],
           col = c("blue", "darkgreen", "red")[wine_data$quality_type],
           pch = c(1,2,3)[wine_data$quality_type],
           xlab = paste0("PC", i),
           ylab = paste0("PC", j),
           cex = 0.7)
      legend("topright",
      	     legend = levels(wine_data$quality_type),
      	     col = c("blue", "darkgreen", "red"),
      	     pch = c(1,2,3),
      	     cex = 0.8)
    } else {
      plot.new()
    }
  }
}
dev.off()

#==========================FA==========================
# union of red and white wines into one set
wine_data <- rbind(red, white)
str(wine_data)
summary(wine_data)

# union of red and white wines into one set
options(digits=3)
wine_features <- subset(wine_data, select = -c(quality, color))
str(wine_features)

n <- nrow(wine_features) 
p <- ncol(wine_features) 
k <- 6
d <- 0.5*(p-k)^2 - 0.5*(p+k)
d
 
# Maximum likelihood method
# Without rotation
fa.wine <- factanal(~.,
					factors=k,
					rotation="none",
					scores="regression",
					data=data.frame(wine_features))
fa.wine   

# With rotation
fa.wine_rot <- factanal(~.,
						factors=k,
						rotation="varimax",
						scores="regression",
						data=data.frame(wine_features))
fa.wine_rot                 

# Plot both FA
pdf("fa_unrotated_vs_varimax.pdf", width = 13, height = 7)
par(mfrow=c(1,2))
plot(cbind(cos((0:360)/180*pi), sin((0:360)/180*pi)),
	 type="l",
	 lty="dotted",
	 xlab = "Factor 1",
	 ylab = "Factor 2",
	 main="Unrotated")
abline(h = 0)
abline(v = 0)
text(fa.wine$loadings[,1:2],
	 labels=colnames(wine_features),
	 col="black")
plot(cbind(cos((0:360)/180*pi),sin((0:360)/180*pi)),
	 type="l",
	 lty="dotted",
	 xlab = "Factor 1",
	 ylab = "Factor 2",
	 main="Varimax")
abline(h = 0)
abline(v = 0)
text(fa.wine_rot$loadings[,1:2],
	 labels=colnames(wine_features),
	 col="black")
dev.off()
        
cbind(fa.wine$loadings[,1], fa.wine_rot$loadings[,1])

# Stability analysis   
set.seed(42)
n <- nrow(wine_features)
idx <- sample(1:n, n/2)
wine_half1 <- wine_features[idx, ]
wine_half2 <- wine_features[-idx, ]

fa1 <- factanal(wine_half1, factors = k, rotation = "varimax", scores = "regression")
fa2 <- factanal(wine_half2, factors = k, rotation = "varimax", scores = "regression")
fa1
fa2  
        
round(fa1$loadings[,1:3], 2)
round(fa2$loadings[,1:3], 2)        

# With oblimin rotation        
library(psych)
fa.parallel(scale(wine_features), fa = "fa")
fa.wine_oblimin <- fa(scale(wine_features),
				      nfactors = 4,
				      rotate = "oblimin",
				      scores = "regression")

pdf("fa_oblimin.pdf", width = 10, height = 10)
plot(cbind(cos((0:360)/180*pi),sin((0:360)/180*pi)),
	 type="l",
	 lty="dotted",
	 xlab = "Factor 1",
	 ylab = "Factor 2",
	 main="Oblimin")
abline(h = 0)
abline(v = 0)
text(fa.wine_oblimin$loadings[,1:2],
	 labels=colnames(wine_features),
	 col="black")
dev.off()

#==========================CCA==========================
library(CCA)

x <- wine_data[,c("fixed.acidity",
				 "volatile.acidity",
				 "citric.acid",
				 "residual.sugar",
				 "chlorides",
				 "free.sulfur.dioxide",
				 "total.sulfur.dioxide")]
y <- wine_data[,c("density",
				 "pH",
				 "sulphates",
				 "alcohol")]
x <- scale(x)
y <- scale(y)

#CCA
cc.wine <- cc(x, y)
cc.wine

pdf("cca_production_vs_properties.pdf", width = 10, height = 10)
par(cex.lab = 1.3, cex.axis = 1.2, font.lab = 2)
plot(cc.wine$scores$xscores[,1],
	 cc.wine$scores$yscores[,1],
	 xlab = expression(eta[1]),
	 ylab = expression(phi[1]),
	 pch = 19,
	 col = adjustcolor(c("red", "blue")[wine_data$color], alpha.f = 0.2))
legend("topleft",
	   legend = levels(wine_data$color),
	   col = c("red", "blue"),
	   pch = 19)
dev.off()

