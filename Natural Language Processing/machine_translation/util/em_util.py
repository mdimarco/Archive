from collections import Counter



#eng_sentences = ["She eats bread", "He eats beef"]
#fre_sentences = ["Elle mange du pain", "Il mange du boef"]


#Gets the probability of f_word aligning with any word in eng_sent
def get_p(tau, eng_sent, f_word):
	p = 0.0
	for e_word in eng_sent:
		p += tau[(e_word, f_word)]
	return p

#Sums partial counts for e_word across all possible fre_words
# def get_n_eo(n, e_word, fre_words):
# 	n_eo = 0
# 	for f_word in fre_words:
# 		n_eo += n[(e_word, f_word)]
# 	return n_eo

#List of string sentence into list of pair of list of words
#Turns [""],[""] --> [ ([""],[""]) ]
 
def split_and_pair_sentences(eng_sentences, fre_sentences):
	return [ (e_sent.split(), f_sent.split()) for e_sent, f_sent in zip(eng_sentences, fre_sentences) ]

#Run expectation maximization algorithm on provided sentences
def train(eng_sentences, fre_sentences, num_iter=10):
	eng_words = set({})
	fre_words = set({})

	print("Beginning Training")
	#Add to set of english/french words and initialize Tau's
	tau = {}

	text = split_and_pair_sentences(eng_sentences, fre_sentences)
	for eng_sent, fre_sent in text:
		#Add english words to set
		for e_word in eng_sent:
			eng_words.add( e_word )
		#Add french words to set
		for f_word in fre_sent:
			fre_words.add( f_word )
		#Initialize Taus
		for e_word in eng_sent:
			for f_word in fre_sent:
				tau[(e_word, f_word)] = 1
	
	#Until Convergence
	for x in range(num_iter):
		print("Iteration %d, beginning expectation" % (x))
		#initialize n_ef's to 0
		n = Counter()
		n_eo_cache = Counter()

		#For each english and french sentence pair
		# sent_count = 0
		for eng_sent,fre_sent in text:
			#For each french word
			for f_word in fre_sent:
				#Get the probability of alignment with a word in the english sentence
				p_fre = get_p(tau, eng_sent, f_word)
				#For each english word
				for e_word in eng_sent:
					#Increment by the partial count of alignment for this eng word with a fre word
					n[(e_word,f_word)] += tau[(e_word,f_word)] / p_fre
					n_eo_cache[e_word] += tau[(e_word,f_word)] / p_fre
			
			# sent_count += 1.0
			# if sent_count % 1000 == 0:
			# 	print("Iteration progress: %.2f" % (100*sent_count/len(eng_sentences)))

		#Maximization step, recompute tau's
		print("Expectation complete, maximizing tau")
		for pair in tau:
			eng = pair[0]
			tau[pair] = n[pair] / n_eo_cache[eng]


	return tau
