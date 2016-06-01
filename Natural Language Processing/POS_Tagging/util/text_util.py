from collections import Counter



def process_file(filename):
	""" Takes in a filename and returns list (lines) of lists (pair) of (word,pos) pairs"""
	data = []
	for line in open(filename):
		data.append([])
		line_clean = line.strip("\n").split()
		for x in range(0,len(line_clean),2):
			word = line_clean[x]
			pos = line_clean[x+1]
			data[-1].append( (word,pos) )
	return data

def score(pred_data, test_data):
	correct = 0
	total = 0
	for pred_sent,test_sent in zip(pred_data,test_data):
		for pred_pair,test_pair in zip(pred_sent,test_sent):
			if pred_pair[1] == test_pair[1]:
				correct += 1
			total += 1
	return float(correct)/total

def conv_unk(data):
	# First, count all words
	word_counts = Counter()
	for sentence in data:
		for pair in sentence:
			word_counts[pair[0]] += 1

	conv_data = []
	for sentence in data:
		conv_data.append([])
		for pair in sentence:
			if word_counts[pair[0]] == 1:
				conv_data[-1].append(("*UNK*",pair[1]))
			else:
				conv_data[-1].append(pair)			
	return conv_data