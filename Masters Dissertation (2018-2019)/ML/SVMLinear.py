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


#Store arguments passed into the program. i.e text of post to be classified.
arguments = sys.argv[1:]

#Read in combined file.
df = pd.read_csv('combined_data.csv')

#Cast data to Unicode variant
temp = df['text'].values.astype('U')

#Convert the description and category type into lists.
description_list = temp.tolist()
category_list = df['category'].tolist()

#Appends data to be classified to description list to be tokenized.
description_list.append(arguments[0])
category_list.append("sport")

#Converts text into a matrix of token counts
count = CountVectorizer()
xCounts = count.fit_transform(description_list)

#Transforms matrix into a tf-idf representation
tfidf = TfidfTransformer()
trainTfidf = tfidf.fit_transform(xCounts)

#Train on everypost in the test set, removing the previously added input text
xTrain = trainTfidf[:- 1]
yTrain = category_list[:- 1]


clf = svm.SVC(kernel='linear').fit(xTrain, yTrain)
print(clf.predict(trainTfidf[-1]))
