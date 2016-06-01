
from collections import Counter

def counts(data):
	count_state_state = {}
	count_state_word = {}
	all_words = set({})
	
	for sentence in data:
		prev_pos = "*STOP*"
		for pair in sentence:
			word = pair[0]
			pos = pair[1]

			#Numbers to be used for sigma
			if prev_pos not in count_state_state:
				count_state_state[prev_pos] = Counter()
			count_state_state[prev_pos][pos] += 1

			#Numbers to be used for tau
			if pos not in count_state_word:
				count_state_word[pos] = Counter()
			count_state_word[pos][word] += 1
			
			prev_pos = pos
			all_words.add(word)
	
	return count_state_state, count_state_word, all_words


def get_sigma(count_state_state):
	sigma = {}
	for prev_state in count_state_state:
		sigma[prev_state] = {}
		states = count_state_state[prev_state]
		state_count = float(sum(states.values()))
		for state in states:
			sigma[prev_state][state] = count_state_state[prev_state][state] / state_count
	return sigma

def get_tau(count_state_word, smooth_denom):
	tau = {}
	for state in count_state_word:
		tau[state] = Counter()
		words = count_state_word[state]
		words["*UNK*"] = 1
		word_count = float(sum(words.values()))
		for word in words:
			tau[state][word] = (count_state_word[state][word] ) / ( word_count )
	return tau

def get_tau_no_smooth(count_state_word):
	tau = {}
	for state in count_state_word:
		tau[state] = Counter()
		words = count_state_word[state]
		word_count = float(sum(words.values()))
		for word in words:
			tau[state][word] = count_state_word[state][word] / word_count 
	return tau

def mle(data):
	""" Take in [[(word,pos)]] and compute maximum likelihood estimade for tau and sigma """
	""" return (tau, sigma ) """
	count_state_state,count_state_word,all_words = counts(data)
	smooth_denom = len(all_words)
	sigma = get_sigma(count_state_state)
	tau = get_tau(count_state_word, smooth_denom)
	return (tau,sigma)

def mle_better_unk(data_unk_conv):
	count_state_state,count_state_word,all_words = counts(data_unk_conv)
	sigma = get_sigma(count_state_state)
	tau = get_tau_no_smooth(count_state_word)
	return (tau,sigma)



