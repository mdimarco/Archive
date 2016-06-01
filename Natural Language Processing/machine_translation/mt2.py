import sys
from util import text_util, em_util, decode_util, bigram_util

if len(sys.argv) != 4:
	print("Usage: python mt1.py frenchtrain englishtrain frenchtest")

# Train / Test files containing text
fre_train = sys.argv[1]
eng_train = sys.argv[2]
fre_test = sys.argv[3]


# "filename" --> ["sentence"]
fre_train_sentences = text_util.get_sentences( fre_train )
eng_train_sentences = text_util.get_sentences( eng_train )


# Train reverse translation model according to IBM Model 1
tau = em_util.train(eng_train_sentences, fre_train_sentences, 10)

# Train bigram model based on sentences
alpha = 1.59
print("Training bigram model")

bigramModel = bigram_util.LangMod(eng_train)

# Get / Format sentences to translate
fre_test_sentences = text_util.get_split_sentences(fre_test)


#Better format for tau_trans, with key as the french word, and value as the list of possible translations
tau_trans = {}
for pair in tau:
	f_word = pair[1]
	e_word = pair[0]
	if f_word not in tau_trans:
		tau_trans[f_word] = []
	if tau[pair] > 0.00005:
		tau_trans[f_word].append( (e_word,tau[pair]) )

print("Translating sentences")
translated_sentences = []
with open('./data/translated-french-senate-noisy.txt', 'w') as trans_file:
	for fre_sentence in fre_test_sentences:
		translated_sentences.append(decode_util.translate_sentence_noisy(tau_trans, bigramModel, fre_sentence))
	print("Sentences Translated, writing to file")
	trans_file.write("\n".join(translated_sentences))