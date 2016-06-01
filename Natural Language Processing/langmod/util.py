from collections import Counter
from math import log

def format_line_bigram(line):
	words = ["*STOP*"] + line.replace("\n","").split(" ") + ["*STOP*"]
	return [ (words[x],words[x+1]) for x in range(len(words)-1) ]


def get_good_bad_lines(filename):
	good_lines = []
	bad_lines = []
	counter = 0
	for line in open(filename):
		if counter % 2 == 0:
			good_lines.append( line )
		else:
			bad_lines.append( line )
		counter += 1
	return good_lines, bad_lines


def get_words(filename):
	words = ["*STOP*"]
	for line in open(filename):
		for word in line.split(" "):
			words.append(word)
		words.append("*STOP*")
	return words


def get_nll_from_bigrams(bigrams, bigram_smooth):
	nll_big_smooth_reg = 0
	for bigram in bigrams:
		if bigram not in bigram_smooth:
			bigram = ("*U*","*U*")
		nll_big_smooth_reg += -log(bigram_smooth[bigram])
	return nll_big_smooth_reg

def get_nll(test_file, bigram_smooth):
	words_test = get_words(test_file)
	bigrams = [ (words_test[x],words_test[x+1]) for x in range(len(words_test)-1) ]
	return get_nll_from_bigrams(bigrams, bigram_smooth) 


def train_bigrams(train_file, alpha, beta):
	words = get_words(train_file)
	unigrams = words
	bigrams = [ (words[x],words[x+1]) for x in range(len(words)-1) ]


	#Note, not incuding *U*
	unigram_freqs = Counter()
	unigram_smooth = Counter()
	bigram_freqs =  Counter()
	bigram_smooth =  Counter()


	#Compute smooth bigram probs
	for word in unigrams:
		unigram_freqs[word] += 1
	unique_words = set(unigrams)
	unique_words.add("*U*")
	unigram_freqs["*U*"] = 0

	for word in unique_words:
		unigram_smooth[word] = float(unigram_freqs[word] + alpha) / ( len(unigrams) + alpha*len(unique_words) )
	for bigram in bigrams:
		bigram_freqs[bigram] += 1

	unique_bigrams = set(bigrams)
	unique_bigrams.add(("*U*","*U*"))
	bigram_freqs[("*U*","*U*")] = 0
	for bigram in unique_bigrams:
		bigram_smooth[bigram] = float( bigram_freqs[bigram] + beta * unigram_smooth[bigram[0]] ) / ( unigram_freqs[bigram[0]] + beta )
	return bigram_smooth
