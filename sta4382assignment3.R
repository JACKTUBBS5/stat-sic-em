#we want to draw a interactive plot to see different bandwidths.

if (!require("manipulate")) install.packages("manipulate", dep=TRUE)
if (!require("ggplot2")) install.packages("ggplot2", dep=TRUE)
library(manipulate)
library(ggplot2)

set.seed(123)

#number of data points is 500 (biomdal)
bi_n <- 500  

#we create two normal datasets to simulate two clusters, in order to show its bimodality.
x1 <- rnorm(bi_n / 2, mean = -2, sd = 0.5)  
x2 <- rnorm(bi_n / 2, mean = 2, sd = 0.5)
bimodal_data<- c(x1, x2) 

#create a function to show the kde plot
kde_bimodalplot <- function(bandwidth) {
  density_estimate <- density(bimodal_data, bw = bandwidth)
  df <- data.frame(x = density_estimate$x, density = density_estimate$y)
  p <- ggplot(df, aes(x, density)) +
    geom_line() +
    geom_point(data = data.frame(x = bimodal_data, density = 0), aes(x, density), shape = 1, size = 2, color = "red") +
    labs(title = paste("KDE with Bandwidth =", bandwidth)) +
    theme_minimal()
  
  truedensity <- 1/2 * dnorm(df$x, mean = -2, sd = 0.5) +
                 1/2 * dnorm(df$x, mean = 2, sd = 0.5) 
  p <- p + geom_line(data = df, aes(x =x, y = truedensity), linetype = "dashed", color = "red")
  
  print(p)
  
}

#you can change the bandwidth from 0.1-2 and the unit is 0.1, the default if 0.5
manipulate(
  kde_bimodalplot(bandwidth),
  bandwidth = slider(0.01, 2, step = 0.01, initial = 0.5)
)


par(mfrow=c(1,2))

hist(bimodal_data, breaks = 30, main = "Histogram of bimodal Dataset")

plot(density(bimodal_data), main = "Density Plot of bimodal Dataset")



bi_x <- 1:bi_n
mod1 = lm(bimodal_data ~ bi_x)
summary(mod1)



covb = vcov(mod1)
coeff.mod1 = coef(mod1)
covb = vcov(mod1)
covb


pred.per_fat = predict(mod1)
res.per_fat = residuals(mod1)
summary(res.per_fat)


par(mfrow=c(1,1))
plot(bimodal_data,bi_x)

par(mfrow=c(1,2))
plot(mod1, which=c(1,2))

##Box Cox transformation

library(MASS)
#error:  since some values may near 0,we should use abs function to aviod errors
bimodal_df <- data.frame(Value = bimodal_data)

bimodal_df$Value <- abs(bimodal_df$Value)
boxcox(Value ~ bi_x, data = bimodal_df, lambda = seq(0, 2.0, length = 200))

##ROC Curves



library(ROCR)
cut_point=( bimodal_df$Value> 3)
pred = prediction(bi_x,cut_point)
perf=performance(pred, "tpr", "fpr")
plot(perf)


library(ROCR)
cut_point=(bimodal_df$Value > 4.2)
pred = prediction(bi_x,cut_point)
perf=performance(pred, "tpr", "fpr")
plot(perf)





#number of data points is 600 (multiomdal)
multi_n <- 600

y1 <- rnorm(multi_n / 3, mean = -4, sd = 1)  
y2 <- rnorm(multi_n / 3, mean = 0, sd = 1)
y3 <- rnorm(multi_n / 3, mean = 4, sd = 2)

multimodal_data <- c(y1,y2,y3)

#create a function to show the kde plot
kde_multimodalplot <- function(bandwidth) {
  density_estimate <- density(multimodal_data, bw = bandwidth)
  df <- data.frame(x = density_estimate$x, density = density_estimate$y)
  p <- ggplot(df, aes(x, density)) +
    geom_line() +
    geom_point(data = data.frame(x = multimodal_data, density = 0), 
               aes(x, density), shape = 3, size = 2, color = "blue") +
    labs(title = paste("KDE with Bandwidth =", bandwidth)) +
    theme_minimal()
  
  truedensity <- 1/3 * dnorm(df$x, mean = -4, sd = 1) +
                 1/3 * dnorm(df$x, mean = 0, sd = 1) +
                 1/3 * dnorm(df$x, mean = 4, sd = 2)
  p <- p + geom_line(data = df, aes(x =x, y = truedensity), linetype = "dashed", color = "red")
  
  print(p)
}

manipulate(
  kde_multimodalplot(bandwidth),
  bandwidth = slider(0.01, 1.5, step = 0.01, initial = 0.5)
)



par(mfrow=c(1,2))

hist(multimodal_data, breaks = 30, main = "Histogram of Multimodal Dataset")

plot(density(multimodal_data), main = "Density Plot of Multimodal Dataset")



multi_x <- 1:multi_n
mod2 = lm(multimodal_data ~ multi_x)
summary(mod2)



covb = vcov(mod2)
coeff.mod2 = coef(mod2)
covb = vcov(mod2)
covb


pred.per_fat = predict(mod2)
res.per_fat = residuals(mod2)
summary(res.per_fat)



par(mfrow=c(1,1))
plot(multimodal_data,multi_x)

par(mfrow=c(1,2))
plot(mod2, which=c(1,2))



##Box Cox transformation

library(MASS)
#error:  since some values may near 0,we should use abs function to aviod errors
multimodal_df <- data.frame(Value = multimodal_data)

multimodal_df$Value <- abs(multimodal_df$Value)
boxcox(Value ~ multi_x, data = multimodal_df, lambda = seq(0, 2.0, length = 200))

##ROC Curves



library(ROCR)
cut_point=( multimodal_df$Value> 3)
pred = prediction(multi_x,cut_point)
perf=performance(pred, "tpr", "fpr")
plot(perf)




library(ROCR)
cut_point=(multimodal_df$Value > 4.2)
pred = prediction(multi_x,cut_point)
perf=performance(pred, "tpr", "fpr")
plot(perf)


