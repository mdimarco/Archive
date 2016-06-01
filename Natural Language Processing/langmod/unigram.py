

from basic_frequencies import basic_freqs
from smooth_uni import get_smooth_uni_words
import math
import sys

#Incorrect Arguments
if len(sys.argv) != 5:
	print("Incorrect Arguments")
	sys.exit(0)
train_file = sys.argv[1]
held_out_name = sys.argv[2]
test_filename = sys.argv[3]
good_bad_filename = sys.argv[4]


# train_file = "data/english-senate-0.txt"
# test_filename = "data/english-senate-2.txt"
# held_out_name = "data/english-senate-1.txt"
# good_bad_filename = "data/good-bad.txt"


word_map, freqs, num_words = basic_freqs(train_file)


#############################################
#############################################
#		UNIGRAM SMOOTHED ALPHA 1
#############################################
#############################################



alpha = 1
unigram_smoothed = get_smooth_uni_words(freqs, alpha, num_words)
assert round( sum(unigram_smoothed), 3 ) == 1.0


def find_log_prob(filename, unigram_smoothed, word_map):
	#Finding log probability of different text with alpha 1
	log_prob = 0
	for line in open(filename,"r"):
		for word in line.split(" "):
			if word not in word_map:
				word = "*U*"
			log_prob += -1*math.log(unigram_smoothed[word_map[word]])
	return log_prob

test_log_prob_alpha1 = find_log_prob( test_filename, unigram_smoothed, word_map )

#print("Log Probability of senate-2 with alpha = 1 is %.2f " % (test_log_prob_alpha1))
print(test_log_prob_alpha1)


#############################################
#############################################
#		UNIGRAM SMOOTHED OPTIMIZED ALPHA
#############################################
#############################################



min_logprob = 10000000000
best_alpha = 1

for alpha in range(1,500,10):
	alpha = alpha * .01 

	unigram_smoothed = get_smooth_uni_words(freqs, alpha, num_words)
	log_prob = find_log_prob(held_out_name, unigram_smoothed, word_map)
	if( log_prob < min_logprob):
		min_logprob = log_prob
		best_alpha = alpha
	else:
		break
	assert round( sum(unigram_smoothed), 3 ) == 1.0



# Now test data with best alpha
unigram_smoothed = get_smooth_uni_words(freqs, alpha, num_words)
test_log_prob_alphaOpt = find_log_prob(test_filename, unigram_smoothed, word_map)
#print("Test Data Log Prob with best alpha: %.2f is %d." % (best_alpha,test_log_prob_alphaOpt))
print(test_log_prob_alphaOpt)

# #############################################
# #############################################
# #		GOOD VS BAD LANGUAGE GUESSING
# #############################################
# #############################################

def log_prob_sentence(word_list, unigram_smoothed, word_map):
	#Filter unknown words
	word_list = map( lambda word: word if word in word_map else "*U*", word_list)
	return sum( [ -1*math.log(unigram_smoothed[word_map[word]]) for word in word_list ] )

good_bad = open(good_bad_filename).readlines()
correct_guess = 0
guesses = 0.0

#For each pair of sentences
for x in range(0,len(good_bad),2):
	good_sent = good_bad[x].split(" ")
	bad_sent = good_bad[x+1].split(" ")

	good_prob = log_prob_sentence(good_sent, unigram_smoothed, word_map)
	bad_prob = log_prob_sentence(bad_sent, unigram_smoothed, word_map)

	#Log Likelihood Guess Correct
	if good_prob < bad_prob:
		correct_guess += 1
	guesses += 1

#print("Fraction of correct guesses for good/bad text: %.2f" % (correct_guess/guesses))
print( float(correct_guess/guesses) )
print(best_alpha)


