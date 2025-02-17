#IS4861 Group Project - Airline Customer Satisfaction Dataset using R code
#Necessary library to be run first
library(dplyr)
library(tidyverse)
library(mlbench)     # Contains the Boston Housing Dataset
library(rpart)       # direct engine for decision tree application
library(rpart.plot)  # for plotting decision trees
library(caret)       # meta engine for decision tree application
library(ipred)       # bagging model
library(randomForest) # random forest
library(gbm)         # gradient boost
library(Metrics)   # use read.dta
library(ISLR)
library(ROSE) # various sampling functions
library(MASS)


#read csv
air <- read.csv('Airline.csv')


#2. DATA EXPLORATION: We decide to ignore the modification of age since it should be no special case affecting satisfaction
#Now check the distribution of the other three variables among satisfied and dissatisfied
# Load the ggplot2 library
library(ggplot2)

##Distribution of Y
satisfaction_counts <- air %>%
  +     group_by(satisfaction) %>%
  +     summarise(count = n())

#Plot of Y variable
ggplot(satisfaction_counts, aes(x = satisfaction, y = count, fill = satisfaction)) +
  +     geom_bar(stat = "identity") +
  +     labs(title = "Distribution of Passenger Satisfaction",
             +          x = "Satisfaction Level",
             +          y = "Number of Passengers") +
#Plot: Distribution of Class:
  ggplot(Airline, aes(x = Class, fill = Class)) +
  +     geom_bar(color = "black") +
  +     scale_fill_manual(values = c("Business" = "red", 
                                     +                                  "Eco" = "yellow", 
                                     +                                  "Eco Plus" = "green")) +
  +     labs(title = "Distribution of Class", x = "Class", y = "Count") +
  +     theme_minimal()

#Plot: Percentage of satisfaction rate in each class:
ggplot(Airline, aes(x = Class, fill = satisfaction)) 
+         geom_bar(position = "fill") 
+         labs(title = "Customer Satisfaction by Class", x = "Class", y = "Proportion") 
+         scale_y_continuous(labels = scales::percent) 
+         theme_minimal()

# Boxplot for Departure Delay
ggplot(air, aes(x = satisfaction, y = Departure.Delay.in.Minutes)) +
  geom_boxplot() +
  labs(title = "Departure Delay by Satisfaction", x = "Satisfaction", y = "Departure Delay (Minutes)") +
  theme_bw()

# Boxplot for Arrival Delay
ggplot(air, aes(x = satisfaction, y = Arrival.Delay.in.Minutes)) +
  geom_boxplot() +
  labs(title = "Arrival Delay by Satisfaction", x = "Satisfaction", y = "Arrival Delay (Minutes)") +
  theme_bw()


# Boxplot for Flight Distance
ggplot(air, aes(x = satisfaction, y = Flight.Distance)) +
  geom_boxplot() +
  labs(title = "Flight Distance by Satisfaction", x = "Satisfaction", y = "Flight Distance") +
  theme_bw()



# Flight Distance vs. Log-odds
ggplot(air, aes(x = Flight.Distance, y = log_odds)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Flight Distance vs. Log-odds of Satisfaction",
       x = "Flight Distance",
       y = "Log-odds of Satisfaction")


# Arrival Delay vs. Log-odds
ggplot(air, aes(x = Arrival.Delay.in.Minutes, y = log_odds)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Arrival Delay vs. Log-odds of Satisfaction",
       x = "Arrival Delay (minutes)",
       y = "Log-odds of Satisfaction")

# Departure Delay vs. Log-odds
ggplot(air, aes(x = Departure.Delay.in.Minutes, y = log_odds)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Departure Delay vs. Log-odds of Satisfaction",
                       x = "Departure Delay (minutes)",
                       y = "Log-odds of Satisfaction")


#3. DATA PROCESSING: Now we will clear rows with missing values, transform outliers variables, and other variables

air <- read.csv('Airline.csv')
air <- na.omit(air)
air <- air %>% mutate(satisfaction = ifelse(satisfaction == "dissatisfied",0,1)) #change Y variable as factor
air <- air %>% mutate_if(is.character,as.factor) #change variable that are characters as factor

air$log_DepartureDelay <- log(air$Departure.Delay.in.Minutes + 1)#For Departure.Delay.in.Minutes
air$log_ArrivalDelay <- log(air$Arrival.Delay.in.Minutes + 1)#For Arrival.Delay.in.Minutes 
air$log_FlightDistance <- log(air$Flight.Distance + 1)#For Flight.Distance 
air <- subset(air, select = -c(Departure.Delay.in.Minutes, Arrival.Delay.in.Minutes, Flight.Distance)) # Drop the variables that has been changed

#Split dataset into training and testing
smp_size <- floor(0.8 * nrow(air))
set.seed(123)
train_ind <- sample(seq_len(nrow(air)), size = smp_size)
train <- air[train_ind, ]
test <- air[-train_ind, ]


#4 RUN  MODEL 
#4A)Logistic Regression model : after transforming all variables
lm_logistic <- glm(satisfaction ~ ., family = 'binomial', data = train)

summary(lm_logistic)


prob1 <- predict(lm_logistic, test, type = 'response')
predict_class1 <- ifelse(prob1 > 0.5, 1, 0)

# create confusion matrix to check the performance
confusionMatrix(data = as.factor(predict_class1), 
                reference = as.factor(test$satisfaction))

#4B)pruned tree
air$satisfaction <- as.factor(air$satisfaction)
smp_size <- floor(0.8 * nrow(air))
set.seed(123)
train_ind <- sample(seq_len(nrow(air)), size = smp_size)
train <- air[train_ind, ]
test <- air[-train_ind, ]

dt_train <- rpart(satisfaction ~ ., data = train, cp = 0.01)



## plot the tree
rpart.plot(dt_train)

predict_dt <- predict(dt_train, test, type = 'class')

## create confusion matrix to check the performance
confusionMatrix(data = predict_dt, 
                reference = as.factor(test$satisfaction))


######
# 4C)bagging
######

# let's try a bagging model with 200 independent trees
set.seed(123)

# how many trees are optimal?
for (n in c(50,100,150,200)) {
  set.seed(123)
  dt_bag_n <- bagging(satisfaction ~ ., data = train, nbagg = n, coob = TRUE, control = rpart.control(cp=0))
  print(dt_bag_n)
}



# try again using optimal # of independent trees
dt_bag <- bagging(satisfaction ~ ., data = train, nbagg = 200, coob = FALSE,
                  control = rpart.control(cp = 0))

predict_bag <- predict(dt_bag, test, type = 'class')

confusionMatrix(data = predict_bag, 
                reference = test$satisfaction)


###########
# 4C)random forest
###########

# a random forest model with 200 independent trees
set.seed(123)
for (m in c(1,2,3,4)) {
  set.seed(123)
  dt_rf_m <- randomForest(satisfaction ~ ., data = train, ntree = 200, mtry = m)
  print(dt_rf_m)
}

# Use the optimal # of variables randomly selected to run random forest
dt_rf1 <- randomForest(satisfaction ~ ., data = train, ntree = 200, mtry = 4)

predict_rf1 <- predict(dt_rf1, test, type = 'class')


confusionMatrix(data = predict_rf1, 
                reference = test$satisfaction)


importance_rf <- importance(dt_rf1)

# Convert to a data frame for easier manipulation
importance_rf_df <- data.frame(Variable = rownames(importance_rf), 
                               Importance = importance_rf[, 1])  # using the first column (Mean Decrease in Accuracy)

# Sort the variables by importance
importance_rf_sorted <- importance_rf_df %>%
  arrange(desc(Importance))

# Display the top 3 most important variables
top_rf_variables <- head(importance_rf_sorted, 5)
print(top_rf_variables)

confusionMatrix(data = predict_rf1, 
                reference = test$satisfaction)


#4D) Variable Importance for Models
# Logistic Regression model
lm_logistic <- glm(satisfaction ~ ., family = 'binomial', data = train)
summary(lm_logistic)

# Extract coefficients and calculate odds ratios
coefficients <- summary(lm_logistic)$coefficients
odds_ratios <- exp(coefficients[, "Estimate"])

# Create a data frame for easier manipulation
importance_lr <- data.frame(Variable = rownames(coefficients), 
                            Odds_Ratio = odds_ratios,
                            P_Value = coefficients[, "Pr(>|z|)"])

# Filter out intercept and sort by odds ratio
importance_lr <- importance_lr[-1, ]  # Remove intercept
importance_lr <- importance_lr[order(-importance_lr$Odds_Ratio), ]
top3_lr <- head(importance_lr, 3)

cat("Top 3 important variables from Logistic Regression:\n")
print(top3_lr)

# Pruned Tree
dt_train <- rpart(satisfaction ~ ., data = train, cp = 0.01)

# Get variable importance
importance_dt <- dt_train$variable.importance
importance_dt <- sort(importance_dt, decreasing = TRUE)
top3_dt <- head(importance_dt, 3)

cat("Top 3 important variables from Pruned Decision Tree:\n")
print(top3_dt)





