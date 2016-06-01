from util import format_line_bigram, get_words, train_bigrams, get_nll, get_nll_from_bigrams,get_good_bad_lines
import sys

#Incorrect Arguments
if len(sys.argv) != 5:
	print("Incorrect Arguments")
	sys.exit(0)
train_file = sys.argv[1]
held_out_file = sys.argv[2]
test_file = sys.argv[3]
good_bad_file = sys.argv[4]

# Files
# train_file = 	"data/english-senate-0.txt"
# held_out_file = "data/english-senate-1.txt"
# test_file = 	"data/english-senate-2.txt"
# good_bad_file = "data/good-bad.txt"

words = get_words(train_file)
alpha = 1.61
beta = 1

bigram_smooth = train_bigrams(train_file, alpha, beta)


#Find log likelihoods of test
nll_big_smooth_reg = get_nll(test_file, bigram_smooth)

#print("Negative Log Likelihoods for senate-2 beta = 1 regular: %.2f" % (nll_big_smooth_reg))
print(nll_big_smooth_reg)



# Tuning Beta
min_nll = 1000000000000
beta = .00001

for i in range(8):
	bigram_smooth = train_bigrams(train_file, alpha, beta)
	nll = get_nll(held_out_file, bigram_smooth)
	beta *= 10


beta_opt = .1 # from testing ^
bigram_smooth = train_bigrams(train_file, alpha, beta_opt)
nll_opt = get_nll(test_file, bigram_smooth)
#Print Neg Log Like of Optimized on Held Out
print(nll_opt)


# Good Bad Guesses
correct_guesses = 0
guesses = 0 

good_lines,bad_lines = get_good_bad_lines(good_bad_file)
for x in range(len(good_lines)):
	good = format_line_bigram(good_lines[x])
	bad = format_line_bigram(bad_lines[x])
	if get_nll_from_bigrams(good, bigram_smooth) < get_nll_from_bigrams(bad, bigram_smooth):
		correct_guesses += 1
	guesses += 1	
	
#print("Correct Guesses %.2f"%(float(correct_guesses)/guesses))
print(float(correct_guesses)/guesses)

print(alpha)
print(beta_opt)
