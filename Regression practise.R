#1 Linear Regression family
#1.1 Simple Linear Regression


data(mtcars)
head(mtcars)
str(mtcars)


##Modelling should be one of the first things to do to get an idea about the relationship.

plot(mtcars$wt,mtcars$mpg, xlab="Weight",ylab="Miles Per Gallon",main="MPG vs Car Weight")
###There exists a clear negative relationship, possibly linear.
###Heavier cars result in lower MPG

##Fitting Simple Linear Regression:

model.slr <- lm(mpg ~ wt, data=mtcars)

summary(model.slr)
###lower p-value means significant relationship.
###R-squared value shows us what percentage of the variation can be explained with the model
###Coefficient actually gives us the formula for predicting different values. ie. each +1 unit of wt reduced MPG by 5.3. (Intercept is the starting/initial point)

abline(model.slr,col="red",lwd=2)
###This regression line gives us an idea about where the most probable values will lie.


##To Predict an MPG for a car that has wt=3:
pred_car <- data.frame(wt=3)
predict(model.slr, pred_car,interval="confidence")



plot(model.slr, which = 1)
### in this residuals vs fitted plot, the residuals appear randomly scattered around zero with no systematic pattern, indicating that the linearity and homoscedasticity assumptions are reasonable.

plot(model.slr, which=2)
###As most point lie on the line, the assumption of normally distributed residuals hold.


#1.2 Multiple Linear Regression

###We will use the same data, mtcars, but now with three predictors.
###First, we have to decide whether each predictor is numeric or factor.
###the first new predictor we will use (cyl) is a factor and the second new predictor (hp) is numeric, also the old predictor we will keep is numeric

##conversion of numeric value to factor
mtcars$cyl <- factor(mtcars$cyl)

##now a quick visual check

pairs(mpg ~ wt + hp + cyl, data = mtcars)
###from the graphs we can see that the mpg decreases as wt and hp increases.
###cyl's interaction with the target variable however differs with each different level.

##Fitting the model
model.mlr <- lm(mpg ~ wt + hp + cyl, data = mtcars)
###This model predicts mpg using all three variables.

#model summary:
summary(model.mlr)
###Each coefficient here shows us how the mpg is effected with a unit change of each of the predictors when the other predictors are held constant.
###Therefore, a unit change in wt decreases mpg by 3.2 and a unit increase in hp reduces the mpg by 0.023
### cyl6 and cyl8 coefficients are added to the mpg depending on which cyl is used. if it is cyl4, then no additions are necessary.

###The R-squared tells us that 83% of the variation in the target variable can be explained with our model. Which is higher than the Simple Linear Regression model earlier.

###As the p-values are not all significant and because of the possible multicollinearity issues causing redundancy, the hp predictor is dropped and the new mlr model is constructed.

new.model.mlr <- lm(mpg ~ wt + cyl, data = mtcars)
summary(new.model.mlr)

###This model only has significant p-values and almost the same R-squared indicating a correct decision.


###When multiple predictors are used, it is important to note how those predictors interact with eachother. If they are also correlated, this might lead to multicollinearity issues.
##To check for multicollinearity
install.packages("car")
library(car)
vif(new.model.mlr)
###VIF values of 1-2 are fine, 5+ are concerning and 10+ indicates serious multicollinearity.
###As our values are between 1 and 2, we conclude that there is no multicollinearity problem.


##to check assumptions:
par(mfrow = c(2,2))
plot(new.model.mlr)
par(mfrow = c(1,1))
###The Residuals vs Fitted plot shows no derrivance from the 0 line and a constant variance. So the linearity and homoscedasticity assumtions are on point.
###T


##To Predict and make appropriate graphs:
wt_grid <- seq(
  from = min(mtcars$wt),
  to   = max(mtcars$wt),
  length.out = 200
)

newdata <- expand.grid(
  wt  = wt_grid,
  cyl = levels(mtcars$cyl)
)


pred <- predict(
  new.model.mlr,
  newdata = newdata,
  interval = "confidence",
  level = 0.95
)

newdata$fit <- pred[, "fit"]
newdata$lwr <- pred[, "lwr"]
newdata$upr <- pred[, "upr"]



library(ggplot2)

ggplot() +
  # Confidence interval band
  geom_ribbon(
    data = newdata,
    aes(x = wt, ymin = lwr, ymax = upr),
    alpha = 0.20
  ) +
  # Prediction line
  geom_line(
    data = newdata,
    aes(x = wt, y = fit),
    linewidth = 1.2
  ) +
  # Observed data
  geom_point(
    data = mtcars,
    aes(x = wt, y = mpg),
    size = 2,
    alpha = 0.75
  ) +
  facet_wrap(~ cyl, nrow = 1) +
  labs(
    title = "Multiple Linear Regression: MPG vs Weight",
    subtitle = "Model: mpg ~ wt + cyl (95% confidence intervals)",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon (MPG)",
    caption = "Shaded area shows 95% confidence interval for the mean prediction"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title.position = "plot",
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold")
  )



#1.3 Polynomial Regression
###This type of regression is for modelling non-linear relationships using polynomial terms, while remaining linear in parameters.
###Why this is important? -> as the model is linear in parameters, it can be estimated using ordinary least squares.

##To check whether a curve is appropriate:
plot(mpg ~ wt, data = mtcars,
     main = "MPG vs Weight (mtcars)",
     xlab = "Weight (1000 lbs)",
     ylab = "Miles per gallon")

##Simple Linear Regression:
m1 <- lm(mpg ~ wt, data = mtcars)
summary(m1)

##Polynomial Regression (x^2):
m2 <- lm(mpg ~ poly(wt, 2, raw = TRUE), data = mtcars)
summary(m2)

##More flexible curve with x^3:
m3 <- lm(mpg ~ poly(wt, 3, raw = TRUE), data = mtcars)
summary(m3)
###is worse

anova(m1, m2, m3)

##plots to check diagnostics:
par(mfrow = c(2, 2))
plot(m2)  
par(mfrow = c(1, 1))


##Visualizing the model with 95% CI:
wt_grid <- seq(min(mtcars$wt), max(mtcars$wt), length.out = 200)
pred <- predict(
  m2,
  newdata = data.frame(wt = wt_grid),
  interval = "confidence",
  level = 0.95
)
plot(mpg ~ wt, data = mtcars,
     main = "Polynomial Regression (Quadratic) with 95% CI",
     xlab = "Weight (1000 lbs)",
     ylab = "MPG")
lines(wt_grid, pred[, "fit"], lwd = 2)
lines(wt_grid, pred[, "lwr"], lty = 2)
lines(wt_grid, pred[, "upr"], lty = 2)


##K-fold method:
set.seed(42)   
K <- 5                   
max_degree <- (10 )

cv_rmse_degree <- function(d, data, K = 5) {
  n <- nrow(data)
  folds <- sample(rep(1:K, length.out = n)) 
  
  rmse_each_fold <- numeric(K)
  for (k in 1:K) {
    train <- data[folds != k, ]
    test  <- data[folds == k, ]
    fit <- lm(mpg ~ poly(wt, d, raw = TRUE), data = train)
    pred <- predict(fit, newdata = test)
    rmse_each_fold[k] <- sqrt(mean((test$mpg - pred)^2))
  }
  mean(rmse_each_fold)
}
degrees <- 1:max_degree
cv_rmse <- sapply(degrees, cv_rmse_degree, data = mtcars, K = K)
results <- data.frame(degree = degrees, cv_rmse = cv_rmse)
results
best_degree <- results$degree[which.min(results$cv_rmse)]
best_degree



#1.4 Multivariate Linear Regression 

data(iris)

str(iris)
summary(iris)
head(iris)

m_mv <- lm(cbind(Sepal.Length, Sepal.Width) ~ Petal.Length + Petal.Width + Species,
           data = iris)

class(m_mv)

summary(m_mv)



anova(m_mv)
manova_mv <- manova(m_mv)
summary(manova_mv, test = "Pillai")
summary(manova_mv, test = "Wilks")


res <- residuals(m_mv)
cor(res)

##For diagnostic check (seperately for each response):
m_len <- lm(Sepal.Length ~ Petal.Length + Petal.Width + Species, data = iris)
m_wid <- lm(Sepal.Width  ~ Petal.Length + Petal.Width + Species, data = iris)

par(mfrow = c(2, 2))
plot(m_len)   # diagnostics for Sepal.Length model

par(mfrow = c(2, 2))
plot(m_wid)   # diagnostics for Sepal.Width model

par(mfrow = c(1, 1))

##Prediction:
newdata <- data.frame(
  Petal.Length = seq(min(iris$Petal.Length),
                     max(iris$Petal.Length),
                     length.out = 100),
  Petal.Width  = mean(iris$Petal.Width),
  Species      = factor("versicolor", levels = levels(iris$Species))
)
m_len <- lm(Sepal.Length ~ Petal.Length + Petal.Width + Species, data = iris)
m_wid <- lm(Sepal.Width  ~ Petal.Length + Petal.Width + Species, data = iris)

pred_len <- predict(m_len, newdata, interval = "confidence")
pred_wid <- predict(m_wid, newdata, interval = "confidence")
plot(
  iris$Petal.Length, iris$Sepal.Length,
  pch = 16, col = "grey70",
  xlab = "Petal.Length",
  ylab = "Sepal.Length",
  main = "Predicted Sepal.Length (with 95% CI)"
)

lines(newdata$Petal.Length, pred_len[, "fit"], lwd = 2)
lines(newdata$Petal.Length, pred_len[, "lwr"], lty = 2)
lines(newdata$Petal.Length, pred_len[, "upr"], lty = 2)
plot(
  iris$Petal.Length, iris$Sepal.Width,
  pch = 16, col = "grey70",
  xlab = "Petal.Length",
  ylab = "Sepal.Width",
  main = "Predicted Sepal.Width (with 95% CI)"
)

lines(newdata$Petal.Length, pred_wid[, "fit"], lwd = 2)
lines(newdata$Petal.Length, pred_wid[, "lwr"], lty = 2)
lines(newdata$Petal.Length, pred_wid[, "upr"], lty = 2)

