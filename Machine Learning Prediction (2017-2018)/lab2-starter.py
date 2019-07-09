import time
from datetime import datetime
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import PolynomialFeatures
from sklearn import linear_model
from sklearn.metrics import mean_squared_error
from sklearn.linear_model import LinearRegression
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, r2_score
from sklearn.model_selection import train_test_split
# Load the data from the comma-separated csv file. 
df = pd.read_csv('energydata_complete (3).csv')

#Function to convert the time stamp from H:M:S into seconds
def get_sec(time_str):
    h, m, s = time_str.split(':')
    return int(h) * 3600 + int(m) * 60 + int(s)

#Defining list for creating Nmuber of Seconds past Midnight (nsm)
list1 = list();


#Removing the date leaving timestamp only and creating a new column called nsm for it.
df['date'] = pd.to_datetime(df['date'])
without_date = df['date'].apply(lambda d : d.time())
df['date'] = without_date
df['nsm'] = df['date']

#Converting timestamp in nsm column to number of seconds past midnight
for timeStamp in  df['nsm']:
    list1.append(get_sec(timeStamp.strftime("%H:%M:%S")))
    
df['nsm'] = list1

#Calculating and printing out the different correlations between Appliances and the other features.

print("Correlation between Appliances and lights: ", df['Appliances'].corr(df['lights']))
print("Correlation between Appliances and T1: ", df['Appliances'].corr(df['T1']))
print("Correlation between Appliances and RH_1: ", df['Appliances'].corr(df['RH_1']))
print("Correlation between Appliances and T2: ", df['Appliances'].corr(df['T2']))
print("Correlation between Appliances and RH_2: ", df['Appliances'].corr(df['RH_2']))
print("Correlation between Appliances and T3: ", df['Appliances'].corr(df['T3']))
print("Correlation between Appliances and RH_3: ", df['Appliances'].corr(df['RH_3']))
print("Correlation between Appliances and T4: ", df['Appliances'].corr(df['T4']))
print("Correlation between Appliances and RH_4: ", df['Appliances'].corr(df['RH_4']))
print("Correlation between Appliances and T5: ", df['Appliances'].corr(df['T5']))
print("Correlation between Appliances and Rh_5: ", df['Appliances'].corr(df['RH_5']))
print("Correlation between Appliances and T6: ", df['Appliances'].corr(df['T6']))
print("Correlation between Appliances and RH_6: ", df['Appliances'].corr(df['RH_6']))
print("Correlation between Appliances and T7: ", df['Appliances'].corr(df['T7']))
print("Correlation between Appliances and RH_7: ", df['Appliances'].corr(df['RH_7']))
print("Correlation between Appliances and T8: ", df['Appliances'].corr(df['T8']))
print("Correlation between Appliances and RH_8: ", df['Appliances'].corr(df['RH_8']))
print("Correlation between Appliances and T9: ", df['Appliances'].corr(df['T9']))
print("Correlation between Appliances and RH_9: ", df['Appliances'].corr(df['RH_9']))
print("Correlation between Appliances and T_out: ", df['Appliances'].corr(df['T_out']))
print("Correlation between Appliances and Press_mm_hg: ", df['Appliances'].corr(df['Press_mm_hg']))
print("Correlation between Appliances and RH_out: ", df['Appliances'].corr(df['RH_out']))
print("Correlation between Appliances and Windspeed: ", df['Appliances'].corr(df['Windspeed']))
print("Correlation between Appliances and Visibility: ", df['Appliances'].corr(df['Visibility']))
print("Correlation between Appliances and Tdewpoint: ", df['Appliances'].corr(df['Tdewpoint']))
print("Correlation between Appliances and rv1: ", df['Appliances'].corr(df['rv1']))
print("Correlation between Appliances and rv2: ", df['Appliances'].corr(df['rv2']))
print("Corrrlation between Appliances and nsm: ", df['Appliances'].corr(df['nsm']))
print()
print("Corr between T1 and T2: ", df['T1'].corr(df['T2']))
print("Corr between Lights and Visibilty", df['lights'].corr(df['Visibility']))


#Setting up X and Y for regression models

X = df.loc[0:,['lights','T1','RH_1','T2','RH_2','T3','T4','T5','T6','RH_6','RH_7', 'RH_8','RH_9', 'T_out', 'Press_mm_hg','RH_out','Windspeed','nsm']]

#X = df.loc[0:,['lights','T1','RH_1','T2','RH_2','T3','RH_3','T4','RH_4','T5','RH_5','T6','RH_6','T7','RH_7','T8', 'RH_8', 'T9','RH_9', 'T_out', 'Press_mm_hg','RH_out','Windspeed','Visibility','Tdewpoint','rv1','rv2','nsm']]

y = df.loc[0:,'Appliances']

X_train, X_test, y_train, y_test = train_test_split(X,y, test_size=0.2, random_state = 50)

print("shape of X2", X.shape)

#REGRESSION MODELS - defining the model, fitting the model, predticting then taking R2 Score of Prediction

#Lasso Regression
laso = linear_model.Lasso(alpha=0.2)
laso.fit(X_train, y_train)
y_predict_laso = laso.predict(X_test)

print("R2 Score for Laso Regression: ", r2_score(y_test,y_predict_laso))

#Ridge Regression
ridge = linear_model.Ridge (alpha = .5)
ridge.fit(X_train, y_train)
y_predict_ridge = ridge.predict(X_test)

print("R2 Score for Ridge Regression: ", r2_score(y_test, y_predict_ridge))

#LassoLars Regression
lassoLars = linear_model.LassoLars(alpha=.1)
lassoLars.fit(X_train, y_train)
y_predict_lassoLars = lassoLars.predict(X_test)

print("R2 Score for the lassLars Regression: ", r2_score(y_test,y_predict_lassoLars))

#BayesianRidge Regression
bays = linear_model.BayesianRidge()
bays.fit(X_train, y_train)
y_predict_bays = bays.predict(X_test)

print("R2 Score for the BayesianRidge: ", r2_score(y_test, y_predict_bays))

#Linear Regression
linreg = LinearRegression()
linreg.fit(X_train, y_train)
y_predict_linear = linreg.predict(X_test)

print("R2 Score for the Linear Regression: ", r2_score(y_test, y_predict_linear))


#Creating the Polynomial features for the Regressions to use.
poly = PolynomialFeatures(degree=3)
X2_train = poly.fit_transform(X_train)
print("shape of X2", X2_train.shape)
X2_test = poly.fit_transform(X_test)


#Linear Regression with Polynomial
linreg.fit(X2_train, y_train)
y_predict_linPoly = linreg.predict(X2_test)

print("R2 Score for the PolyNomial Linear Regression: ", r2_score(y_test, y_predict_linPoly))
print("MSE" , mean_squared_error(y_test,y_predict_linPoly))

#Lasso regression with Polynomial
laso.fit(X2_train, y_train)
y_predict_lasoPoly = laso.predict(X2_test)

print("R2 Score for the PolyNomial Lasso Regression: ", r2_score(y_test, y_predict_lasoPoly))
print("MSE" , mean_squared_error(y_test,y_predict_lasoPoly))

#Ridge regression with Polynomial
ridge.fit(X2_train, y_train)
y_predict_ridgePoly = ridge.predict(X2_test)

print("R2 Score for the PolyNomial ridge Regression: ", r2_score(y_test, y_predict_ridgePoly))
print("MSE" , mean_squared_error(y_test,y_predict_ridgePoly))

#LassoLars regression with Polynomial
lassoLars.fit(X2_train, y_train)
y_predict_lassoLarsPoly = lassoLars.predict(X2_test)

print("R2 Score for the PolyNomial lassoLars Regression: ", r2_score(y_test, y_predict_lassoLarsPoly))
print("MSE" , mean_squared_error(y_test,y_predict_lassoLarsPoly))

#Bayesian regression with Polynomial
bays.fit(X2_train, y_train)
y_predict_baysPoly = bays.predict(X2_test)

print("R2 Score for the PolyNomial bays  Regression: ", r2_score(y_test, y_predict_baysPoly))
print("MSE" , mean_squared_error(y_test,y_predict_baysPoly))





df.plot(kind='scatter', x='nsm', y='T_out');
plt.show()

