from porter_stemmer import PorterStemmer
import re, string


class Tokenizer(object):
	def __init__(self):
		self.stemmer = PorterStemmer()

		self.regex = re.compile('[%s]' % re.escape(string.punctuation))



		self.stop_words = open("stop_words.txt","r").read()
		self.stop_words = self.regex.sub("",self.stop_words)

		self.stop_words = self.stop_words.replace("\n"," ").split()

	def __call__(self, tweet):
		# TODO: This function takes in a single tweet (just the text part)
		# then it will process/clean the tweet and return a list of tokens (words).
		# For example, if tweet was 'I eat', the function returns ['i', 'eat']

		# You will not need to call this function explictly. 
		# Once you initialize your vectorizer with this tokenizer, 
		# then 'vectorizer.fit_transform()' will implictly call this function to 
		# extract features from the training set, which is a list of tweet texts.
		# So once you call 'fit_transform()', the '__call__' function will be applied 
		# on each tweet text in the training set (a list of tweet texts),

		clean = []
		tweet = tweet.lower()
		tweet = tweet.replace("#","")

		tweet = re.sub("@[^\s]+","ANY_USER",tweet)
		tweet = self.regex.sub("",tweet)
		tweet = re.sub("www.[^\s]+","URL",tweet)
		tweet = self.regex.sub("",tweet)
		tweet = re.sub("http://[^\s]+","URL",tweet)
		tweet = self.regex.sub("",tweet)
		tweet = re.sub("https://[^\s]+","URL",tweet)
		tweet = self.regex.sub("",tweet)


		for word in tweet.split():

			if word[0].isalpha() and word not in self.stop_words:	
				word = self.stemmer.stem(word,0,len(word)-1)

				no_dups = []
				prev = word[0]
				counter = 0
				for char in word:

					if prev == char:
						counter += 1

					if prev != char:
						counter = 1

					if counter <= 2:
						no_dups.append(char)

					prev = char

				if prev != no_dups[-1]:
					no_dups.append(prev)

				clean.append("".join(no_dups))


		return clean

