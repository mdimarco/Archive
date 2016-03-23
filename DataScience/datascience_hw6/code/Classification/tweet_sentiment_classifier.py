from __future__ import division
import sys
import csv
import argparse
from collections import defaultdict

import util

import numpy
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics import classification_report, confusion_matrix
from sklearn import cross_validation
from sklearn.naive_bayes import BernoulliNB
from sklearn.linear_model import LogisticRegression
from sklearn.svm import LinearSVC
from tokenizer import Tokenizer

import matplotlib.pyplot as plt

def main():
	##### DO NOT MODIFY THESE OPTIONS ##########################
	parser = argparse.ArgumentParser()
	parser.add_argument('-training', required=True, help='Path to training data')
	parser.add_argument('-test', help='Path to test data')
	parser.add_argument('-c', '--classifier', default='nb', help='nb | log | svm')
	parser.add_argument('-top', type=int, help='Number of top features to show')
	opts = parser.parse_args()
	############################################################

	##### BUILD TRAINING SET ###################################
	# Initialize CountVectorizer
	# You will need to implement functions in tokenizer.py
	tokenizer = Tokenizer()
	vectorizer = CountVectorizer(binary=True, lowercase=True, decode_error='replace', tokenizer=tokenizer)

	# Load training text and training labels
	# (make sure to convert labels to integers (0 or 1, not '0' or '1') 
	#  so that we can enforce the condition that label data is binary)

	count = 0
	with open(opts.training, 'rb') as f:
		reader = csv.reader(f)
		train_data = list(reader)

	train_labels = numpy.arange(len(train_data))
	train_text = []


	i = 0
	for tweet in train_data:
		label = tweet[0]
		text = tweet[-1]

		train_text.append(text)
		train_labels[i] = int(label)
		i+=1

	print("ready to vectorize training data")
	# Get training features using vectorizer
	train_features = vectorizer.fit_transform(train_text)
	# Transform training labels to numpy array (numpy.array)
	print("done vectorizing")
	############################################################


	##### TRAIN THE MODEL ######################################
	# Initialize the corresponding type of the classifier and train it (using 'fit')
	if opts.classifier == 'nb':
		classifier = BernoulliNB(binarize=None)
		print("Naive Bayes")
	elif opts.classifier == 'log':
		classifier = LogisticRegression()
		print("Log")
	elif opts.classifier == 'svm':
		classifier = LinearSVC()
		print("Support Vector Machine")
	else:
		raise Exception('Unrecognized classifier!')
	classifier.fit(train_features,train_labels)
	############################################################


	###### VALIDATE THE MODEL ##################################
	# Print training mean accuracy using 'score'
	print(classifier.score(train_features,train_labels))
	# Perform 10 fold cross validation (cross_validation.cross_val_score) with scoring='accuracy'
	# and print the mean score and std deviation
	scores = cross_validation.cross_val_score(classifier,train_features,train_labels,cv=10,scoring='accuracy')
	print("Cross Validation Scores Calculated")
	print(scores)
	print("Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() ** 2))
	############################################################


	##### EXAMINE THE MODEL ####################################
	if opts.top is not None:
		print("Got "+str(opts.top)+" tops")

		# print top n most informative features for positive and negative classes
		util.print_most_informative_features(opts.classifier, vectorizer, classifier, opts.top)
	############################################################


	##### TEST THE MODEL #######################################
	if opts.test is None:
		test_tweet = 'Water dripping from 3rd to 1st floor while the firealarm makes it hard to hear anything. BTW this is the 2nd leakage.  Love our new house'

		# Test the classifier on one sample test tweet
		# Tim Kraska 10:43 AM - 5 Feb 13


		# Print the predicted label of the test tweet
		features = vectorizer.transform([test_tweet])
		print("Prediction: ")
		print(classifier.predict(features))
		# Print the predicted probability of each label.
		if opts.classifier != 'svm':
			# Use predict_proba
			print("User predict prob ")
			print(classifier.predict_proba(features))
			
		else:
			# Use decision_function
			print("use decision ")
			print(classifier.decision_function(features))
			
	else:
		with open(opts.test, 'rb') as f:
			reader = csv.reader(f)
			test_data = list(reader)

		test_labels = numpy.arange(len(test_data))
		test_text = []


		i = 0
		for tweet in test_data:
			label = tweet[0]
			text = tweet[-1]

			test_text.append(text)
			test_labels[i] = int(label)
			i+=1

		print("ready to vectorize testing data")
		# Get training features using vectorizer
		test_features = vectorizer.transform(test_text)

		print("Score")
		print(classifier.score(test_features,test_labels))

		# Test the classifier on the given test set
		# Extract features from the test set and transform it using vectorizer

		# Print test mean accuracy

		# Predict labels for the test set
		predictions = classifier.predict(test_features)

		# Print the classification report
		print("Classification report")
		print(classification_report(test_labels,predictions))
		# Print the confusion matrix
		print("Classifier uses: Confusion!")
		print(confusion_matrix(test_labels,predictions))
		print("It's super effective!")

		# Get predicted label of the test set
		if opts.classifier != 'svm':
			print("Predicted Probability")
			test_predicted_proba = classifier.predict_proba(test_features)


			tweets = zip(test_labels,predictions,test_predicted_proba,test_text)
			num = len(tweets)
			counter = 0
			for tup in reversed(sorted(tweets,key=lambda x:x[2][1])):
				
				if tup[0] != tup[1]:
					if counter < 5:
						print(tup)
					counter+=1
			counter = 0
			for tup in reversed(sorted(tweets,key=lambda x:x[2][0])):
				if tup[0] != tup[1]:
					if counter < 5:
						print(tup)
					counter+=1

			util.plot_roc_curve(test_labels, test_predicted_proba)

			
		else:
			print("Decision Function")
			decisions = classifier.decision_function(test_features)
			#import matplotlib.pyplot as plt
			x = numpy.arange(0,len(decisions),1)
			plt.plot(x,decisions)
			plt.show()

			
	############################################################

 		
if __name__ == '__main__':
	main()
