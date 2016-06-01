#############################################
#############################################
#		BASIC FREQUENCIES
#############################################
#############################################

def basic_freqs(train_file):
	#Key = word, Val = numerical association of word
	word_map = {}
	#Tracks counts of words
	freqs = []
	#Tracks number of words total
	num_words = 0


	#Populate frequency table of words in corpus
	for line in open(train_file,"r"):
		for word in line.split(" "):
			if word not in word_map:
				word_map[word] = len(freqs)
				freqs.append(0)
			freqs[ word_map[word] ] += 1
			num_words += 1

	#Unseen Words
	word_map["*U*"] = len(freqs)
	freqs.append(0)

	return word_map, freqs, num_words