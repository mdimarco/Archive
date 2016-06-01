def get_smooth_uni_word(word_freq, alpha, numWords, alphaNot):
	return float(word_freq + alpha) / (numWords + alphaNot)

#Take in a list of word frequencies, return smoothed unigram list
def get_smooth_uni_words( word_freqs, alpha, num_words ):
	unigram_smoothed = []
	for word_freq in word_freqs:
		unigram_smoothed.append( get_smooth_uni_word(word_freq, alpha, num_words, alpha*len(word_freqs)) )
	return unigram_smoothed

