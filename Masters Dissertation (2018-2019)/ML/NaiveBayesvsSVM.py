import numpy as np
from sklearn.naive_bayes import MultinomialNB
from sklearn.feature_extraction.text import CountVectorizer
import pandas as pd
from collections import Counter
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfTransformer
import nltk
from nltk import ProbDistI
import sys
from sklearn import svm

#Read in combined file.
df = pd.read_csv('combined_data.csv')

#Cast data to Unicode variant
temp = df['text'].values.astype('U')

#Convert the description and category type into lists.
description_list = temp.tolist()
category_list = df['category'].tolist()

#Converts text into a matrix of token counts
count = CountVectorizer()
xCounts = count.fit_transform(description_list)

#Transforms matrix into a tf-idf representation
tfidf = TfidfTransformer()
trainTfidf = tfidf.fit_transform(xCounts)


#Split data into test and training sets
xTrain, xTest, yTrain, yTest = train_test_split(trainTfidf, category_list, test_size=0.2)

#Train Naive Bayes classifier
clf1 = MultinomialNB().fit(xTrain, yTrain)

#Train Support Vector Machine classifier with linear kernel
clf2 =  svm.SVC(kernel='linear').fit(xTrain, yTrain)

#Train Support Vector Machine classifier with rbf kernel
clf3 = svm.SVC(kernel='rbf').fit(xTrain, yTrain)

#Set of predictions for test set X for Naive Bayes classifier
predicitedNB = clf1.predict(xTest)

#Set of predictions for test set X for  Support Vector Machine classifier with linear kernel
predicitedSVM = clf2.predict(xTest)

#Set of predictions for test set X for Support Vector Machine classifier with rbf kernel
predicitedSVMRBF = clf3.predict(xTest)


#Calculates accuracy of predictions by comparing set of predicitons with correct predictions in y test set.
#Accuracy test performed for each classifier, with results printed to the terminal.

currentCounterNB = 0
for i in range(len(predicitedNB)):
    if predicitedNB[i] == yTest[i]:
        currentCounterNB += 1

currentCounterSVM = 0
for i in range(len(predicitedSVM)):
    if predicitedSVM[i] == yTest[i]:
        currentCounterSVM += 1

currentCounterSVMRBF = 0
for i in range(len(predicitedSVMRBF)):
    if predicitedSVMRBF[i] == yTest[i]:
        currentCounterSVMRBF += 1

precentageNB = currentCounterNB/len(predicitedNB)*100
precentageSVM = currentCounterSVM/len(predicitedSVM)*100
precentageSVMRBF = currentCounterSVMRBF/len(predicitedSVMRBF)*100

print("NB: ", precentageNB)
print("SVM: ", precentageSVM)
print("SVMRBF: ", precentageSVMRBF)
