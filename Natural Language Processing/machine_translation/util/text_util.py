

#Get sentences from file
def get_sentences(filename):
	sentences = []
	lines = open(filename).readlines()
	for line in lines:
		sentences.append(line.strip("\n"))
	return sentences


# Split sentences into list of words
def get_split_sentences(filename):
	return [sentence.split() for sentence in open(filename)]
