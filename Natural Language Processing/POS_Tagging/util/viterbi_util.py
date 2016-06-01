
class ViterbiRunner():
	# seen_words: set of words seen in training
	def __init__(self, data, tau, sigma):
		self.data = data
		self.tau = tau
		self.sigma = sigma
		self.possible_tags = set({"*STOP*"})
		self.seen_words = set({})
		for sentence in self.data:
			for pair in sentence:
				self.possible_tags.add(pair[1])
		for state in tau:
			for word in tau[state]:
				self.seen_words.add(word)
	def run(self):
		all_tags = []
		for sentence in self.data:
			sentence_tags = []
			prev_tag = "*STOP*"
			for pair in sentence:
				word = pair[0]
				pred_tag = self.guess_tag(prev_tag, word)
				sentence_tags.append( (word,pred_tag) )
				prev_tag = pred_tag
			all_tags.append(sentence_tags)
		return all_tags
	def get_tau(self, tag, word):
		return self.tau[tag][word]
	def guess_tag(self, prev_tag, word):
		if word not in self.seen_words:
			word = "*UNK*"
		max_prob = 0
		max_tag = "INITIAL"
		for tag in self.sigma[prev_tag].keys():	
			prob = self.sigma[prev_tag][tag] * self.get_tau(tag,word) 
			if prob >= max_prob:
				max_prob = prob
				max_tag = tag
		return max_tag
