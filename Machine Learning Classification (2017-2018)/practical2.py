from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score, r2_score, classification_report
from sklearn.linear_model import LogisticRegression
from sklearn.feature_selection import SelectKBest, f_classif
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import time
import csv



#This function takes in a list and a file to write to, writes list to file as a .csv file
def writeListToFile(list1, filename):
    with open(filename, 'w') as resultFile:
        wr = csv.writer(resultFile, dialect = 'excel')
        wr.writerow(list1)



#Reading in the input files for the multiclass classification task

df_XM = pd.read_csv('multiclass/X.csv', header=None)
df_yM = pd.read_csv('multiclass/y.csv', header=None)
df_WaveM = pd.read_csv('multiclass/Wavelength.csv', header=None);

#Reading in the input files for the binary classification task

df_XB = pd.read_csv('binary/binary/X.csv', header=None)
df_yB = pd.read_csv('binary/binary/y.csv', header=None)
df_WaveB = pd.read_csv('binary/binary/Wavelength.csv', header=None)

#Reading in the input files for the solution classifcation tasks
df_FinalXB = pd.read_csv('binary/binary/XToClassify.csv')
df_FinalXM = pd.read_csv('multiclass/XtoClassify.csv')

print("Shape of y is: ", df_yB.shape)

#Flattening the data recived from the y files in order to a compatiable shape for training

df_y_flatB = df_yB.values.flatten()
df_y_flatM = df_yM.values.flatten()

print("Shape of y ravel is: ", df_y_flatB)




X_trainB, X_testB, y_trainB, y_testB = train_test_split(df_XB, df_y_flatB, test_size = 0.4, random_state = 30)

X_trainM, X_testM, y_trainM, y_testM = train_test_split(df_XM, df_y_flatM, test_size = 0.4, random_state = 30)



#Defining the lists that will be written to file, for each different function

fitTimeListBinaryLog = []
predictTimeListBinaryLog = []
fitTimeListMultiLog = []
predictTimeListMultiLog = []

fitTimeListBinaryNN = []
predictTimeListBinaryNN = []
fitTimeListMultiNN = []
predictTimeListMultiNN = []

fitTimeListMultiNNtanh = []
predictTimeListMultiNNtanh = []
fitTimeListMultiNNlogistic = []
predictTimeListMultiNNlogistic = []
fitTimeListMultiNNidentity = []
predictTimeListMultiNNidentity = []

fitTimeListMultiNNsgd = []
predictTimeListMultiNNsgd = []
fitTimeListMultiNNlbfgs = []
predictTimeListMultiNNlbfgs = []


fitTimeListMultiNNlayers = []
predictTimeListMultiNNlayers = []

fitTimeListMultiNNFinal = []
predictTimeListMultiNNFinal = []

#Defining the lists for printing each of the Scores for each function into a csv file.
binaryLogScore = []
multiLogScore = []
binaryNNScore = []
multiNNScore = []
multiNNtanhScore = []
multiNNlogisticScore = []
multiNNidentityScore = []
multiNNsgdScore = []
multiNNlbfgsScore = []
multiNNlayers = []
multiNNFinal = []

#Defining the variabels to store the average score of each of the functions 
averageBLS = 0
averageMLS = 0
averageBNS = 0
averageMNS = 0
averagetanh = 0
averagelogistic = 0
averageidentity = 0
averagesgd = 0
averagelbfgs = 0
averagelayers = 0
averageFinal = 0



#This function runs logistic regression on the binary data
def binaryLog(X_trainB, X_testB,y_trainB,y_testB,i):
    selectorB  = SelectKBest(f_classif, k=i).fit(X_trainB, y_trainB)
    X_bestB = selectorB.transform(X_trainB)
    X_testBestB = selectorB.transform(X_testB)

    logreg = LogisticRegression()

    fitTime = time.clock()
    logreg.fit(X_bestB, y_trainB)
    fitTimeResult = time.clock() - fitTime
    fitTimeListBinaryLog.append(fitTimeResult)
    print(fitTimeResult)

    predictTime = time.clock()
    result = logreg.predict(X_testBestB)
    predictTimeResult = time.clock() - predictTime
    predictTimeListBinaryLog.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score =  accuracy_score(result,y_testB)
    binaryLogScore.append(score)
    print("SCORE IS: ", score)

    writeListToFile(fitTimeListBinaryLog, "fitTimeBinaryLog.csv")
    writeListToFile(predictTimeListBinaryLog, "predictTimeBinaryLog.csv")
    writeListToFile(binaryLogScore, "binaryLogScore.csv");

    return score;

#This function runs logistic regression on the multiclass data
def multiLog(X_trainM, X_testM, y_trainM, y_testM,i):

    selectorM = SelectKBest(f_classif, k=i).fit(X_trainM, y_trainM)
    X_bestM = selectorM.transform(X_trainM)
    X_testBestM = selectorM.transform(X_testM)

    logregM = LogisticRegression()
    fitTime = time.clock()
    logregM.fit(X_bestM, y_trainM)
    fitTimeResult = time.clock() - fitTime
    fitTimeListMultiLog.append(fitTimeResult)
    print(fitTimeResult)

    predictTime = time.clock()
    resultM = logregM.predict(X_testBestM)
    predictTimeResult = time.clock() - predictTime
    predictTimeListMultiLog.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score = accuracy_score(resultM, y_testM)
    multiLogScore.append(score)
    print("Score is: ", score)

    writeListToFile(fitTimeListMultiLog, "fitTimeMultiLog.csv")
    writeListToFile(predictTimeListMultiLog,  "predictTimeMultiLog.csv")
    writeListToFile(multiLogScore, "multiLogScore.csv")

    return score;

#This functions runs a Neural Network on the binary data
def binaryNN(X_trainB, X_testB,y_trainB,y_testB,i):

    
    selectorB  = SelectKBest(f_classif, k=i).fit(X_trainB, y_trainB)
    X_bestB = selectorB.transform(X_trainB)
    X_testBestB = selectorB.transform(X_testB)

    clf = MLPClassifier(activation='relu', solver='lbfgs', alpha=0.0001, hidden_layer_sizes=(64), random_state = 10)


    fitTime = time.clock()
    clf.fit(X_bestB, y_trainB)
    fitTimeResult = time.clock() - fitTime
    fitTimeListBinaryNN.append(fitTimeResult)
    print(fitTimeResult)
    print()

    predictTime = time.clock()
    resultNNB = clf.predict(X_testBestB)
    predictTimeResult = time.clock() - predictTime
    predictTimeListBinaryNN.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score = accuracy_score(resultNNB, y_testB)
    binaryNNScore.append(score)
    print("Score is: ", score)

    writeListToFile(fitTimeListBinaryNN, "fitTimeBinaryNN.csv")
    writeListToFile(predictTimeListBinaryNN, "predictTimeBinaryNN.csv")
    writeListToFile(binaryNNScore, "binaryNNScore.csv")

    return score;


#This function runs a Nerual Network on the multiclass data
def multiNN(X_trainM, X_testM, y_trainM, y_testM,i):

    selectorM = SelectKBest(f_classif, k=i).fit(X_trainM, y_trainM)
    X_bestM = selectorM.transform(X_trainM)
    X_testBestM = selectorM.transform(X_testM)


    clf = MLPClassifier(activation='relu', solver='adam', alpha=0.0001, hidden_layer_sizes=(64), random_state = 10)

    fitTime = time.clock()
    clf.fit(X_bestM, y_trainM)
    fitTimeResult = time.clock() - fitTime
    fitTimeListMultiNN.append(fitTimeResult)
    print(fitTimeResult)
    print()

    predictTime = time.clock()
    resultNNM = clf.predict(X_testBestM)
    predictTimeResult = time.clock() - predictTime
    predictTimeListMultiNN.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score = accuracy_score(resultNNM, y_testM)
    multiNNScore.append(score)
    print("Score is: ", score)

    writeListToFile(fitTimeListMultiNN, "fitTimeMultiNN.csv");
    writeListToFile(predictTimeListMultiNN, "predictTimeMultiNN.csv")
    writeListToFile(multiNNScore, "multiNNScore.csv");

    return score;


#This function runs a Neural Network on the multiclass data using the tanh activation function
def multitanhNN(X_trainM, X_testM, y_trainM, y_testM,i):
    selectorM = SelectKBest(f_classif, k=i).fit(X_trainM, y_trainM)
    X_bestM = selectorM.transform(X_trainM)
    X_testBestM = selectorM.transform(X_testM)


    clf = MLPClassifier(activation='tanh', solver='adam', alpha=0.0001, hidden_layer_sizes=(64), random_state = 10)

    fitTime = time.clock()
    clf.fit(X_bestM, y_trainM)
    fitTimeResult = time.clock() - fitTime
    fitTimeListMultiNNtanh.append(fitTimeResult)
    print(fitTimeResult)
    print()

    predictTime = time.clock()
    resultNNM = clf.predict(X_testBestM)
    predictTimeResult = time.clock() - predictTime
    predictTimeListMultiNNtanh.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score = accuracy_score(resultNNM, y_testM)
    multiNNtanhScore.append(score)
    print("Score is: ", score)

    writeListToFile(fitTimeListMultiNNtanh, "fitTimeMultiNNtanh.csv");
    writeListToFile(predictTimeListMultiNNtanh, "predictTimeMultiNNtanh.csv")
    writeListToFile(multiNNtanhScore, "multiNNtanhScore.csv");

    return score


#This function runs a Neural Network on the multiclass data using the tanh logistic function
def multilogisticNN(X_trainM, X_testM, y_trainM, y_testM,i):

    selectorM = SelectKBest(f_classif, k=i).fit(X_trainM, y_trainM)
    X_bestM = selectorM.transform(X_trainM)
    X_testBestM = selectorM.transform(X_testM)


    clf = MLPClassifier(activation='logistic', solver='adam', alpha=0.0001, hidden_layer_sizes=(64), random_state = 10)

    fitTime = time.clock()
    clf.fit(X_bestM, y_trainM)
    fitTimeResult = time.clock() - fitTime
    fitTimeListMultiNNlogistic.append(fitTimeResult)
    print(fitTimeResult)
    print()

    predictTime = time.clock()
    resultNNM = clf.predict(X_testBestM)
    predictTimeResult = time.clock() - predictTime
    predictTimeListMultiNNlogistic.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score = accuracy_score(resultNNM, y_testM)
    multiNNlogisticScore.append(score)
    print("Score is: ", score)

    writeListToFile(fitTimeListMultiNNlogistic, "fitTimeMultiNNlogistic.csv");
    writeListToFile(predictTimeListMultiNNlogistic, "predictTimeMultiNNlogistic.csv")
    writeListToFile(multiNNlogisticScore, "multiNNlogisticScore.csv");

    return score


#This function runs a Neural Network on the multiclass data using the identity activation function
def multiidentityNN(X_trainM, X_testM, y_trainM, y_testM,i):
    selectorM = SelectKBest(f_classif, k=i).fit(X_trainM, y_trainM)
    X_bestM = selectorM.transform(X_trainM)
    X_testBestM = selectorM.transform(X_testM)


    clf = MLPClassifier(activation='identity', solver='adam', alpha=0.0001, hidden_layer_sizes=(64), random_state = 10)

    fitTime = time.clock()
    clf.fit(X_bestM, y_trainM)
    fitTimeResult = time.clock() - fitTime
    fitTimeListMultiNNidentity.append(fitTimeResult)
    print(fitTimeResult)
    print()

    predictTime = time.clock()
    resultNNM = clf.predict(X_testBestM)
    predictTimeResult = time.clock() - predictTime
    predictTimeListMultiNNidentity.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score = accuracy_score(resultNNM, y_testM)
    multiNNidentityScore.append(score)
    print("Score is: ", score)

    writeListToFile(fitTimeListMultiNNidentity, "fitTimeMultiNNidentity.csv");
    writeListToFile(predictTimeListMultiNNidentity, "predictTimeMultiNNidentity.csv")
    writeListToFile(multiNNidentityScore, "multiNNidentityScore.csv");


    return score

#This function runs a Neural Network on the multiclass data using the sgd solver 
def multisgdNN(X_trainM, X_testM, y_trainM, y_testM,i):

    selectorM = SelectKBest(f_classif, k=i).fit(X_trainM, y_trainM)
    X_bestM = selectorM.transform(X_trainM)
    X_testBestM = selectorM.transform(X_testM)


    clf = MLPClassifier(activation='relu', solver='sgd', alpha=0.0001, hidden_layer_sizes=(64), random_state = 10)

    fitTime = time.clock()
    clf.fit(X_bestM, y_trainM)
    fitTimeResult = time.clock() - fitTime
    fitTimeListMultiNNsgd.append(fitTimeResult)
    print(fitTimeResult)
    print()

    predictTime = time.clock()
    resultNNM = clf.predict(X_testBestM)
    predictTimeResult = time.clock() - predictTime
    predictTimeListMultiNNsgd.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score = accuracy_score(resultNNM, y_testM)
    multiNNsgdScore.append(score)
    print("Score is: ", score)

    writeListToFile(fitTimeListMultiNNsgd, "fitTimeMultiNNsgd.csv");
    writeListToFile(predictTimeListMultiNNsgd, "predictTimeMultiNNsgd.csv")
    writeListToFile(multiNNsgdScore, "multiNNsgdScore.csv");


    return score

#This function runs a Neural Network on the multiclass data using the lbfgs solver
def multilbfgsNN(X_trainM, X_testM, y_trainM, y_testM,i):
    selectorM = SelectKBest(f_classif, k=i).fit(X_trainM, y_trainM)
    X_bestM = selectorM.transform(X_trainM)
    X_testBestM = selectorM.transform(X_testM)


    clf = MLPClassifier(activation='relu', solver='lbfgs', alpha=0.0001, hidden_layer_sizes=(64), random_state = 10)

    fitTime = time.clock()
    clf.fit(X_bestM, y_trainM)
    fitTimeResult = time.clock() - fitTime
    fitTimeListMultiNNlbfgs.append(fitTimeResult)
    print(fitTimeResult)
    print()

    predictTime = time.clock()
    resultNNM = clf.predict(X_testBestM)
    predictTimeResult = time.clock() - predictTime
    predictTimeListMultiNNlbfgs.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score = accuracy_score(resultNNM, y_testM)
    multiNNlbfgsScore.append(score)
    print("Score is: ", score)

    writeListToFile(fitTimeListMultiNNlbfgs, "fitTimeMultiNNlbfgs.csv");
    writeListToFile(predictTimeListMultiNNlbfgs, "predictTimeMultiNNlbfgs.csv")
    writeListToFile(multiNNlbfgsScore, "multiNNlbfgsScore.csv");

    return score

#This function runs a Neural Network on the multiclass data using a higher amount of layers and dpeth of layers
def nnLayersCompare(X_trainM, X_testM, y_trainM, y_testM,i):

    selectorM = SelectKBest(f_classif, k=i).fit(X_trainM, y_trainM)
    X_bestM = selectorM.transform(X_trainM)
    X_testBestM = selectorM.transform(X_testM)


    clf = MLPClassifier(activation='relu', solver='adam', alpha=0.0001, hidden_layer_sizes=(128,128,128,128), random_state = 10)

    fitTime = time.clock()
    clf.fit(X_bestM, y_trainM)
    fitTimeResult = time.clock() - fitTime
    fitTimeListMultiNNlayers.append(fitTimeResult)
    print(fitTimeResult)
    print()

    predictTime = time.clock()
    resultNNM = clf.predict(X_testBestM)
    predictTimeResult = time.clock() - predictTime
    predictTimeListMultiNNlayers.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score = accuracy_score(resultNNM, y_testM)
    multiNNlayers.append(score)
    print("Score is: ", score)

    writeListToFile(fitTimeListMultiNNlayers, "fitTimeMultiNNlayers.csv");
    writeListToFile(predictTimeListMultiNNlayers, "predictTimeMultiNNlayers.csv")
    writeListToFile(multiNNlayers, "multiNNlayersScore.csv");

    return score


#This function runs a Neural Network on the multiclass data using the best settings, which were chosen through the results of the above functions
def nnFinal(X_trainM, X_testM, y_trainM, y_testM,i):
    selectorM = SelectKBest(f_classif, k=i).fit(X_trainM, y_trainM)
    X_bestM = selectorM.transform(X_trainM)
    X_testBestM = selectorM.transform(X_testM)


    clf = MLPClassifier(activation='tanh', solver='adam', alpha=0.0001, hidden_layer_sizes=(128,128,128,128), random_state = 10)

    fitTime = time.clock()
    clf.fit(X_bestM, y_trainM)
    fitTimeResult = time.clock() - fitTime
    fitTimeListMultiNNFinal.append(fitTimeResult)
    print(fitTimeResult)
    print()

    predictTime = time.clock()
    resultNNM = clf.predict(X_testBestM)
    predictTimeResult = time.clock() - predictTime
    predictTimeListMultiNNFinal.append(predictTimeResult)
    print(predictTimeResult)
    print()

    score = accuracy_score(resultNNM, y_testM)
    multiNNFinal.append(score)
    print("Score is: ", score)

    writeListToFile(fitTimeListMultiNNFinal, "fitTimeMultiNNFinal.csv");
    writeListToFile(predictTimeListMultiNNFinal, "predictTimeMultiNNFinal.csv")
    writeListToFile(multiNNFinal, "multiNNFinalScore.csv");

    return score

#This functions prints out to file the final solution to the data provided for the binary class.
def binarySolution(X_trainB, df_FinalXB ,y_trainB):
    selectorB  = SelectKBest(f_classif, k=1).fit(X_trainB, y_trainB)
    X_bestB = selectorB.transform(X_trainB)
    X_testBestB = selectorB.transform(df_FinalXB)

    logreg = LogisticRegression()

    logreg.fit(X_bestB, y_trainB)
    
    result = logreg.predict(X_testBestB)
    
    print(result)

    writeListToFile(result, "binaryTask/PredictedClasses.csv");

#This function prints out to the file the final solution to the data provided for the multiclass.
def multiSolution(X_trainM, df_FinalXM ,y_trainM):
    selectorM  = SelectKBest(f_classif, k=10).fit(X_trainM, y_trainM)
    X_bestM = selectorM.transform(X_trainM)
    X_testBestM = selectorM.transform(df_FinalXM)

    logreg = LogisticRegression()

    logreg.fit(X_bestM, y_trainM)

    result = logreg.predict(X_testBestM)
    
    print(result)

    writeListToFile(result, "multiClassTask/PredictedClasses.csv");




#Loop running over the main section of the program, i indicates the number of features that function will run on
for i in range(1,921):
    print(i) 
   # averageBLS +=  binaryLog(X_trainB, X_testB,y_trainB,y_testB,i)
   # averageMLS +=  multiLog(X_trainM, X_testM, y_trainM, y_testM,i)
   # averageBNS +=  binaryNN(X_trainB, X_testB,y_trainB,y_testB,i)
   # averageMNS +=  multiNN(X_trainM, X_testM, y_trainM, y_testM,i)
    #averagetanh += multitanhNN(X_trainM, X_testM, y_trainM, y_testM,i)
   # averagelogistic += multilogisticNN(X_trainM, X_testM, y_trainM, y_testM,i)
    #averageidentity += multiidentityNN(X_trainM, X_testM, y_trainM, y_testM,i)
   # averagesgd += multisgdNN(X_trainM, X_testM, y_trainM, y_testM,i)
    # averagelbfgs += multilbfgsNN(X_trainM, X_testM, y_trainM, y_testM,i)
  #  averagelayers += nnLayersCompare(X_trainM, X_testM, y_trainM, y_testM,i)
 #   averageFinal += nnFinal(X_trainM, X_testM, y_trainM, y_testM,i)

binarySolution(X_trainB, df_FinalXB ,y_trainB)
multiSolution(X_trainM, df_FinalXM ,y_trainM)



#Printing out the average score for each of the functions.
print("The average score for binaryLog was: ", averageBLS/921)
print("The average score for multiLog was: ", averageMLS/921)
print("The average score for the binaryNN was: ", averageBNS/921)
print("The average score for the multiNN was: ", averageMNS/921)
print("The average score for the multitanhNN was: ", averagetanh/921)
print("The average score for the multilogisticNN was: ", averagelogistic/921)
print("The average score for the multiidentityNN was: ", averageidentity/921)
print("The average score for the multisgdNN was: ", averagesgd/921)
print("The average score for the multilbfgsNN was: ", averagelbfgs/921)
print("The average score for the multiLayers was: ", averagelayers/921)
print("The average score for the Final NN was: ", averageFinal/921)



#Plotting of training data visulising the data to show cross overs in validation categories



fig, ax = plt.subplots()




#for i in range(len(X_trainM)):
 #   if y_trainM[i] == 0:
  #      ax.scatter(df_WaveM,X_trainM.iloc[i,:], s=1, c='b')
  #  elif y_trainM[i] == 1:
   #     ax.scatter(df_WaveM,X_trainM.iloc[i,:], s=1, c='g')
   # elif y_trainM[i] == 2:
    #    ax.scatter(df_WaveM,X_trainM.iloc[i,:], s=1, c='m')
   # elif y_trainM[i] == 3:
   #     ax.scatter(df_WaveM,X_trainM.iloc[i,:], s=1, c='r')
   # elif y_trainM[i] == 4:
    #    ax.scatter(df_WaveM,X_trainM.iloc[i,:], s=1, c='y')


for i in range(len(X_trainB)):
    if y_trainB[i] == 0:
        ax.scatter(df_WaveB,X_trainB.iloc[i,:], s=1, c='g')
    elif y_trainB[i] == 1:
        ax.scatter(df_WaveM,X_trainB.iloc[i,:], s=1, c='r')







plt.show()




