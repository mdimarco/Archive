from collections import Counter

class LangMod:
	def __init__(self,filename):
		#Parameters
		self.alpha = 1.59
		self.beta = 110

		#Get words/bigrams
		self.unigrams = self._get_words(filename)
		self.bigrams = [ (self.unigrams[x],self.unigrams[x+1]) for x in range(len(self.unigrams)-1) ]
		self.unique_words = set(self.unigrams)
		self.num_words = len(self.unigrams)
		self.num_unique_words = len(self.unique_words)

		#Initialize Unigram Frequencies
		self.unigram_freqs = Counter()
		for word in self.unigrams:
			self.unigram_freqs[word] += 1

		#Initialize Bigram Frequencies
		self.bigram_freqs = Counter()
		for bigram in self.bigrams:
			self.bigram_freqs[bigram] += 1

	def _get_words(self,filename):
		words = ["*STOP*"]
		lines = open(filename).readlines()
		for line in lines:
			for word in line.strip("\n").split():
				words.append(word)
			words.append("*STOP*")
		return words

	def get_smooth_unigram(self,word):
		return float(self.unigram_freqs[word] + self.alpha) / ( self.num_words + self.alpha*self.num_unique_words )

	def get_smooth_bigram(self,bigram):
		return float(self.bigram_freqs[bigram] + self.beta * self.get_smooth_unigram(bigram[1]) ) / ( self.unigram_freqs[bigram[0]] + self.beta )


# Produces bigram probabilities
# Param: ["sentence"] eng_train_sentences
# Return: {(word1,word2):prob}
# def bigram_info(filename, alpha):
# 	words = get_words(filename)

# 	unigrams = words
# 	bigrams = [ (words[x],words[x+1]) for x in range(len(words)-1) ]
	

# 	unigram_freqs = Counter()
# 	unigram_smooth = Counter()
# 	bigram_freqs =  Counter()

# 	# Calculate unigram frequencies
# 	for word in unigrams:
# 		unigram_freqs[word] += 1
# 	unique_words = set(unigrams)


# 	# Calculate unigram smoothed probabilities
# 	for word in unique_words:
# 		unigram_smooth[word] = float(unigram_freqs[word] + alpha) / ( len(unigrams) + alpha*len(unique_words) )

# 	# Calculate bigram frequencies
# 	for bigram in bigrams:
# 		bigram_freqs[bigram] += 1

# 	return unigram_freqs, unigram_smooth, bigram_freqs