# Baranchikova Daria
library(ggplot2)
library(scales)

# read data
red <- read.csv("../data/winequality-red.csv", sep = ";")
white <- read.csv("../data/winequality-white.csv", sep = ";")

# genetral data overview by colors
summary(red)
summary(white)

# adding color in data set
red$color <- factor("red", levels = c("red", "white"))
white$color <- factor("white", levels = c("red", "white"))

# union of red and white wines into one set
wine_data <- rbind(red, white)
str(wine_data)
summary(wine_data)

# normalized difference of means ((mu1 + mu2)/pooledSD)
norm_difference <- sapply(names(wine_data)[-ncol(wine_data)], function(var) {
  x1 <- red[, var]
  x2 <- white[, var]
  
  n1 <- length(x1)
  n2 <- length(x2)
  
  m1 <- mean(x1)
  m2 <- mean(x2)
  
  s1 <- sd(x1)
  s2 <- sd(x2)
  
  pooled_sd <- sqrt(((n1 - 1)*s1^2 + (n2 - 1)*s2^2) / (n1 + n2 - 2))
  
  d <- (m2 - m1) / pooled_sd  # white - red
  return(d)
})
norm_difference

# Matrix of scatter plots of every possible combination of two variables in a data set
pdf("combinations_scatter_plots.pdf", width = 21, height = 15)
pairs(wine_data, col = c("blue", "red")[wine_data[, "color"]])
dev.off()

# Red vs White wines histograms across different quality ratings
df <- as.data.frame(table(wine_data$color, wine_data$quality))
colnames(df) <- c("color", "quality", "count")
df$percent <- ave(df$count, df$color, FUN = function(x) x / sum(x))

ggplot(df, aes(x = as.factor(quality), y = percent, fill = color)) +
	geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  	scale_y_continuous(labels = percent_format(accuracy = 1)) +
	labs(x = "Quality (0-10)", y = "Proportion of wines (%)", fill = "Wine Type") +
	scale_fill_manual(values = c("red" = "#D73027", "white" = "#4575B4"), labels = c("Red", "White")) +
     theme_minimal(base_size = 13) +
     theme(axis.text = element_text(size = 10, color = "black"), axis.title.x = element_text(face = "bold"),
     axis.title.y = element_text(face = "bold"), legend.position = "top", legend.title = element_text(size = 10, face = "bold")) 
ggsave("quality_share_by_type.png", width = 5, height = 4, dpi = 300)

# Boxplot + geom_jitter of quality across wine types
ggplot(wine_data, aes(x = color, y = quality, fill = color)) +
	geom_boxplot(fatten = 3, lwd = 0.5, color = "black") +
	stat_boxplot(geom = "errorbar", width = 0.2, size = 0.5) +
	geom_jitter(aes(color = color), width = 0.2, alpha = 0.2, size = 1) +
	scale_fill_manual(values = c("red" = alpha("#D73027", 0.6), "white" = alpha("#4575B4", 0.6))) +
	scale_y_continuous(breaks = 3:9) +
	scale_color_manual(values = c("red" = "#7F0000", "white" = "#084081")) +
	labs(x = "Wine type", y = "Quality (0-10)") +
	theme_minimal(base_size = 13) +
	theme(axis.text = element_text(size = 10, color = "black"), legend.position = "none", axis.title.x = element_text(face = "bold"), axis.title.y = element_text(face = "bold"))
ggsave("quality_boxplot_by_type.png", width = 5, height = 4, dpi = 300)
  
