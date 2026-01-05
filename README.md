**1. Linear Regression Family**

**1.1 Simple Linear Regression** 

This is the most simple Linear Regression. It only uses one predictor to predict the numeric target variable. Take mtcars dataset for example; if we check the MPG vs Car Weight graph, we can see that there is a negative correlation.

<img width="639" height="540" alt="image" src="https://github.com/user-attachments/assets/fc3c00a5-5be3-4c70-8d19-704ea7ef2cf1" />

*Figure 1: MPG vs Car Weight plot* 

To make this more meaningful and test the significance of the situation, we use regression. 

<img width="521" height="231" alt="image" src="https://github.com/user-attachments/assets/1a27191e-36af-4155-9c93-dec8b0a7f6ba" />

*Figure 2: Fitted regression model summary results

After fitting a regression model, the summary output we got provides us with a lot of valuable information. First and most importantly, we see that there exists a very significant relationship between our two variables as our p-value is much less then 0.05. Also, looking at the R-squared value,
we see that our model explain 75% of the variation in the target variable. On the model summary, we also see some values for coefficients. These help us predict the target variable. To do so, we take the intercept as the initial value, and add it the value we get from (wt)*(-5.34)

After analysing the summary, we draw the regression line on to the inital plot to visualize where our predictions will lie.

<img width="639" height="540" alt="image" src="https://github.com/user-attachments/assets/fe7bd672-57e2-4239-a168-6b6f0e566dd7" />

*Figure 3: MPG vs Car Weight plot with Regression Line*

Finally, for our model to be meaningful, there are a few assumptions that has to be satisfied. First, to check for the Linearity and Constant Variance assumptions, we need to check the Residuals vs Fitted graph.

<img width="639" height="540" alt="image" src="https://github.com/user-attachments/assets/d6e93387-5a5e-485c-b226-b6fa23f4e839" />

*Figure 4: Residuals vs Fitted graph*

In this graph, we see that the residuals are randomly scattered and there is no obvious pattern, thus the linearity assumption holds. 
Also, the vertical spread of residuals are in the same range throughout the plot, this situation indicates the constant variance assumption is satisfied too.

Then, we generate a Q-Q plot to check for the normality of the residuals.

<img width="639" height="540" alt="image" src="https://github.com/user-attachments/assets/3b3196cb-5d50-4286-845a-c9f9ef68a82b" />

*Figure 5: Q-Q plot"

From this graph it can be easily seen that most point lie approximately on the q-q line. This indicates that the assumption of normality of errors is satisfied too.


**1.2 Multiple Linear Regression** 

The next regression practise is about MLR. This type of regression is still very similar to the simple linear regression, but we use multiple predictors for the same single target variable.
The new predictors we add are cyl (categorical) and hp (numerical).

We first do a quick visual check to see how each of these predictors interract with our target variable.

<img width="639" height="540" alt="image" src="https://github.com/user-attachments/assets/3a801861-a26a-41de-abb7-0ac19feeb4df" />

*Figure 6: correlation matrix*

These plots give us a general idea about how the target variable behaves with different values of our predictor variables. We can also see how predictors interract with eachother, this gives us a clue about possible multicollinearity problems in our model.
To interpret the plots, we see that the mpg decreases as wt and hp increases, cyl's interaction with the target variable however differs with each different level.

After checking the initial plots, we then construct the model to see the model summary.

<img width="528" height="285" alt="image" src="https://github.com/user-attachments/assets/21fa8f00-82c5-4409-9a0b-7a0844a59624" />

*Figure 7: MLR model summary*

From the summary above, we see that wt is still highly significant but the others are not. To solve this issue, we drop the highest p-value predictor which is "hp", per the backwards elimination method.

<img width="531" height="268" alt="image" src="https://github.com/user-attachments/assets/1447a3ac-255c-4745-9c91-502962de1d7a" />

*Figure 8: Same MLR model but without "hp"*

After dropping "hp" predictor, we see that our R-squared value did not change "drastically" (0.83 to 0.82), therefore we conclude that it was the right decision to drop this predictor. Also, now all our predictors are significant (p-value<0.05). So to interpret the results, for a unit change in "wt", our mpg decreases by 3.2, and for cyl6 it decreases by 4.2 and cyl8 decreases mpg by 6.1.

When multiple predictors are used, it is important to note how those predictors interact with eachother. If they are also correlated, this might lead to multicollinearity issues.

<img width="267" height="68" alt="image" src="https://github.com/user-attachments/assets/38db094d-d683-4811-8479-99cfa95f0260" />

*VIF values for new MLR model"

As both of the VIF values are less than 5, we conclude that there is no multicollinearity problem existent.

Now, to check assumptions:

<img width="639" height="540" alt="image" src="https://github.com/user-attachments/assets/dda3f7f4-5e41-4e4d-88eb-b1e0fb810aa6" />

*Figure 9: Plots to check assumptions*

The Residuals vs Fitted plot shows no derrivance from the 0 line and a constant variance. So the linearity and homoscedasticity assumtions are on point. The Q-Q plot shows the points are mostly on the line, so the residuals are normally distributed.

Now that we have our model constructed and possible violations checked, we can use the model to predict MPG with cyl and wt variables.

<img width="639" height="540" alt="image" src="https://github.com/user-attachments/assets/8c51474c-067b-4a7d-b737-f99e28572989" />

*Figure 10: MLR prediction plots for different cyl and wt values*

From these graphs, we can see the most probable line the mpg will lie on with different values of predictors and the appropriate confidence intervals.

**1.3 Polynomial Regression** 

This type of regression is for modelling non-linear relationships using polynomial terms, while remaining linear in parameters.

Why this is important? -> as the model is linear in parameters, it can be estimated using ordinary least squares.

First, we generate a plot to check if a curve is appropriate.

<img width="639" height="540" alt="image" src="https://github.com/user-attachments/assets/fd825307-5ca4-4530-a92c-a3712bb52aa4" />

*Figure 11: mpg vs wt*

From the plot it seems like there is a significant negative relationship, and a curve might be a little better then a straight line.

<img width="547" height="304" alt="image" src="https://github.com/user-attachments/assets/4a959ff9-74f8-478e-9525-66ed860cb1db" />

*Figure 12: Polynomial model summary*

From this summary, it is seen that the R-squared value (0.8066) is higher then the base simple linear regression (0.7446). This indicates the polynomial model is slightly better at explaining the variance on the target variable.

We also fit a degree 3 polynomial model for comparision purposes.

<img width="537" height="316" alt="image" src="https://github.com/user-attachments/assets/a1915a83-c4a8-45a4-8ff5-34907842b2e8" />

*Figure 13: Degree 3 polynomial model summary*

Then, we use ANOVA to compare our three different models (Simple Linear Regression, Degree2 polynomial and Degree3 polynomial).

<img width="518" height="194" alt="image" src="https://github.com/user-attachments/assets/0db1ac7c-e129-49f0-af8d-b636221af0f9" />

*Figure 14: Comparision of the three models with ANOVA*

From the graph above, it can be concluded that the best model amongst the three is the Degree2 polynomial model.

Now, to check the model diagnostics:

<img width="639" height="540" alt="image" src="https://github.com/user-attachments/assets/ec493bb5-0389-472a-8e4d-fe1f9cb684b5" />

*Figure 15: Diagnostic Plots for degree2 model*

The Residuals vs Fitted plot shows no derrivance from the 0 line and a constant variance. So the linearity and homoscedasticity assumtions are on point. The Q-Q plot shows the points are mostly on the line, so the residuals are normally distributed.

