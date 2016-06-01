#Returns best matched english word for provided french word
def best_eng_match(tau, f_word):
	#Only consider Tau pairs that contain the french word
	if f_word not in tau:
		return f_word
	else:
		candidates = tau[f_word]
		return max(candidates, key=lambda x:x[1])[0]

# Translate a sentence using very dumb decoding strategy
# Param tau: { "":[""] } dictionary of french words corresponding to list of possible english translations
# Param french_sentence: [ "" ] list of words in sentence
# Returns:[ "" ] list of words in translated sentence
def translate_sentence_dumb(tau, french_sentence):
	return " ".join( [ best_eng_match(tau, f_word) for f_word in french_sentence ] )


def translate_sentence_noisy(tau, bigramModel, french_sentence):
	#Create a Do not translate system for the f-score, so sentences of length 11 or greater are ignored
	if len(french_sentence) > 10:
		return "* * * * * Not Translated * * * * *"

	eng_sentence = []
	#Start with stop word
	prev = "*STOP*"
	#For each french word
	for f_word in french_sentence:
		#If not yet seen, do not translate
		if f_word not in tau:
			best_candidate = f_word	
		else:
			candidates = tau[f_word]
			best_candidate = ""
			best_prob = 0
			#Find best english word to translate to
			for e_word,tau_prob in candidates:
				bigram = (prev,e_word)
				bigram_prob = bigramModel.get_smooth_bigram(bigram)
				e_prob =  bigram_prob * tau_prob
				if e_prob > best_prob:
					best_candidate = e_word
					best_prob = e_prob
		eng_sentence.append(best_candidate)
		prev = best_candidate

	return " ".join(eng_sentence)
