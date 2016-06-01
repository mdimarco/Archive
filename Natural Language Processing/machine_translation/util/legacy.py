		# for e_word in eng_words:
		# 	for f_word in fre_words:
		# 		if n[(e_word,f_word)] != 0:
		# 			tau[(e_word, f_word)] = n[(e_word,f_word)] / get_n_eo(n, e_word, fre_words)


		# print("Eng, Fre, Tau, N")
		# for key in sorted(tau):
		# 	if tau[key] != 0:
		# 		print(key,tau[key],n[key])
		# 		

sorted(tau_trans[f], key=lambda x:x[1], reverse=True)[0:5]




#Ensure all Tau's sum to one
for word in tau_eng_trans.keys():
	prob_counter = 0
	for val in tau_eng_trans[word]:
		prob_counter += val[1]
	if abs(prob_counter-1) > .005:
		print(word,prob_counter)



# Make english tau translations
tau_eng_trans = {}
for pair in tau:
   f_word = pair[1]
   e_word = pair[0]
   if e_word not in tau_eng_trans:
     tau_eng_trans[e_word] = []
   if tau[pair] > 0.00005:
     tau_eng_trans[e_word].append( (f_word, tau[pair]) )
     


    





# Translates a sentence using noisy channel decoding
# Param tau: { "":[""] } dictionary of french words corresponding to list of possible english translations
# Param french_sentence: [ "" ] list of words in sentence
# Returns:[ "" ] list of words in translated sentence
# def translate_sentence_noisy(tau, bigram_smoothed, french_sentence):
# 	eng_sentence = []
# 	#Start with stop word
# 	prev = "*STOP*"
# 	#For each french word
# 	for f_word in french_sentence:
# 		#If not yet seen, do not translate
# 		if f_word not in tau:
# 			max_candidate = f_word	
# 		else:
# 			candidates = tau[f_word]
# 			max_candidate = ""
# 			max_prob = 0
# 			#Find best english word to translate to
# 			for e_word,tau_prob in candidates:
# 				bigram = (prev,e_word)
# 				if bigram not in bigram_smoothed:
# 					bigram = ("*U*","*U*")
# 				e_prob = bigram_smoothed[bigram] * tau_prob
# 				if e_prob > max_prob:
# 					max_candidate = e_word
# 					max_prob = e_prob
# 		eng_sentence.append(max_candidate)
# 		prev = max_candidate

# 	return " ".join(eng_sentence)


# Wasnt taking into account before not to just do *U*,*U*, better to actually do smoothed versions
# def get_bigram_prob(unigram_freqs, bigram_freqs, bigram):
# 	alpha = 1.59
# 	beta = 110


# 	first = bigram[0]
# 	second = bigram[1]
# 	unigram_smooth = lambda word: float(unigram_freqs[word] + alpha) / ( len(unigrams) + alpha*len(unique_words) 

# 	return float(bigram_freqs[bigram] + beta * unigram_smooth(first) ) / ( unigram_freqs[first] + beta )
