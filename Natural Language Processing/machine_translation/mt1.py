import sys
from util import text_util, em_util, decode_util

if len(sys.argv) != 4:
	print("Usage: python mt1.py frenchtrain englishtrain frenchtest")

# Train / Test files containing text
fre_train = sys.argv[1]
eng_train = sys.argv[2]
fre_test = sys.argv[3]


# "filename" --> ["sentence"]
fre_train_sentences = text_util.get_sentences( fre_train )
eng_train_sentences = text_util.get_sentences( eng_train )

# Train translation model according to IBM Model 1
# tau = em_util.train(eng_train_sentences, fre_train_sentences, 10)


# examples = [ ("of","de"), ("the", "la"), ("36","36"), (",",",") ]
# for ex in examples:
# 	print(ex,tau[ex])


# Train translation model according to IBM Model 1
tau = em_util.train(fre_train_sentences, eng_train_sentences, 10)


# [ ["word"] ]
fre_test_sentences = text_util.get_split_sentences( fre_test )


#Better format for tau_trans, with key as the french word, and value as the list of possible translations
tau_trans = {}
for pair in tau:
	f_word = pair[0]
	e_word = pair[1]
	if f_word not in tau_trans:
		tau_trans[f_word] = []
	if tau[pair] > 0.00005:
		tau_trans[f_word].append( (e_word,tau[pair]) )


with open('./data/translated-french-senate-dumb.txt', 'w') as trans_file:
	for fre_sentence in fre_test_sentences:
		trans_file.write(decode_util.translate_sentence_dumb(tau_trans, fre_sentence)+"\n")
