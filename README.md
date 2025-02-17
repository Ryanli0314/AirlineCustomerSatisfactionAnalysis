# AirlineCustomerSatisfactionAnalysis
We use dataset from Kaggle which is about airline customer satisfaction, to perform machine learning using method such as logistic regression, decision tree, bagging and boosting to solve classification problem: Predicting what factors will lead to satisfaction or dissatisfaction of customers.

Introduction
With the rapid expansion of the global airline business, most travelers choose their favorite airlines for a comfortable flight and plan their itineraries based on the level and quality of service provided by each airline. In order to increase customer satisfaction, improve service quality, and attract more potential customers, it is necessary to have a comprehensive understanding of consumer preferences. The objective of this project is to analyze the passenger satisfaction in the airline industry. Since consumer satisfaction is a key indicator for the success of airlines, our main objective is to develop a predictive model to accurately determine the key variables that affect consumer satisfaction.
 
Problem Statement 
Business Problem: Which factors are the most important factors that affect Airline Customer’s Preferences?

Problem Motivation
A low level of customer satisfaction may diminish an airline's reputation and lead to customer attrition, ultimately reducing revenue. Conversely , high customer satisfaction not only increases brand loyalty, but also attracts new customers and reduces customer complaints.

Therefore, we hope to answer the following questions:    
What variables affect customer satisfaction the most?
Based on the above analysis, what suggestions can we make to the airlines?

Problem Type and Model
We will use logistic regression modeling to forecast the association between a different factor (X) and customer satisfaction (Y) 

X (independent variable) represents different factors.
We will consider a variety of independent variables including online support, online booking and infotainment. We will use these variables to predict consumer satisfaction.

Y (dependent variable) Customer satisfaction..
In the data, customer satisfaction is denoted as “Satisfied” and “Dissatisfied” and we will use 0 for “Dissatisfied” and 1 for “Satisfied”. 

Data Description
We will use the Airline Customer’s Preferences & Satisfaction dataset which is from Kaggle. There are 129880 observations and 23 columns. There are 6 categorical variables and 17 numerical variables (Appendix 2). Our plan is taking 22 X variables which includes Departure / Arrival time convenient, Inflight entertainment, On-board service etc. Satisfaction will be the Y variables. 


Data exploration
Distribution of Y variable
The evaluation of customer satisfaction in the airline dataset indicates a slight difference between happy and unsatisfied passengers. In particular, 71,087 travellers said they were satisfied, whilst 58,793 travellers said they weren't. This shows that a sizable majority of passengers are happy with their airline experience. To increase total customer happiness and loyalty, the airline should still focus on a number of crucial areas, as indicated by the significant percentage of disgruntled passengers. (Appendix 1.1)

Comparison of mean scores of customer preference
We compared the mean scores of Airline customer preference, found out that Cleanliness and Baggage handling have higher means among customer preferences. On the other hand, Food and drinks, and seat comfort receive relatively bad ratings from customers. 

The data gave us insight into which services the companies in the  airline industry have to improve. Lower scores may indicate possible sources of discontent that can result in client attrition.Companies may improve quality of food and drinks and seat comfort to gain better customer loyalty. (Appendix 1.2)

Explore the data by Age
We then looked into the data more thoroughly by age. The age distribution shows that the most counts in the dataset are 25, 40, and 45. (Appendix 1.3) Regarding the satisfaction rate by age group, the 40–60 age group has the highest rate at 66.7%, while the 80–90 age group has the lowest percentage at just 27.4%. The age group ranging from 25-35 also have a relatively high count. But surprisingly, their satisfaction rate is low. (Appendix 1.4)Therefore, given that they have a relatively large count but a poor satisfaction percentage, it would suggest that the 25–35 age group should receive special attention.

Explore the data by Class
Subsequently, we conduct a more in-depth analysis of the dataset categorised by class. Business class has the highest count within the distribution, followed by eco and eco plus, but the number of counts for business is comparable to eco and eco plus together. (Appendix 1.5) In terms of satisfaction rates, the business class has the highest at 70.9%, followed by the other two classes at 39.4 and 42.7%, respectively. (Appendix 1.6) Based on these graphs, airlines may want to focus on improving the eco and eco plus passenger satisfaction rates.
