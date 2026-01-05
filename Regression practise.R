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
### in this residuals vs fitted pllot, the residuals appear randomly scattered around zero with no systematic pattern, indicating that the linearity and homoscedasticity assumptions are reasonable.

plot(model.slr, which=2)
###As most point lie on the line, the assumtion of normally distributed residuals hold.


#1.2 Multiple Linear Regression

###We will use the same data, mtcars, but now with two predictors.
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
###The Q-Q plot shows the points are mostly on the line, so the residuals are normally distributed.


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


