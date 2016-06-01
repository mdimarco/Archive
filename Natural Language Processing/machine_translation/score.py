import sys
from util import text_util


prog_out_filename = sys.argv[1]
correct_filename = sys.argv[2]

# [ (translated_sentence, correct_sentence) ]
sentence_pairs = zip( text_util.get_sentences(prog_out_filename), text_util.get_sentences(correct_filename) )


# FSCORE ONE
# 
# # Words found in translated sentence and in correct sentence
# correct_translations = 0
# # Words found in translated sentence but not in correct sentence
# incorrect_translations = 0
# # Words found in correct sentence but not in translated sentence
# missed_words = 0
# for trans_sent,correct_sent in sentence_pairs:
# 	trans_sent = trans_sent.split()
# 	correct_sent = correct_sent.split()

# 	if len(correct_sent) <= 10:
# 		# Count correctly/incorrectly translated words
# 		for trans_word in trans_sent:
# 			if trans_word in correct_sent:
# 				correct_translations += 1
# 			else:
# 				incorrect_translations += 1
		
# 		# Count missed words that were not translated to
# 		for correct_word in correct_sent:
# 			if correct_word not in trans_sent:
# 				missed_words += 1

# precision = float(correct_translations) / (correct_translations+incorrect_translations)
# recall = float(correct_translations) / (correct_translations+missed_words)
# f_score = 2 * (precision*recall) / (precision+recall)
# print("F Score, computed through true positive / false positive / false negative calculations is: %.3f" % (f_score))

# FSCORE TWO
# 
# precisions = []
# recalls = []
# for trans_sent,correct_sent in sentence_pairs:
# 	trans_sent = trans_sent.split()
# 	correct_sent = correct_sent.split()
# 	correct_translation = 0.0
# 	if len(correct_sent) <= 10:
# 		for trans_word in trans_sent:
# 			if trans_word in correct_sent:
# 				correct_translation += 1
# 		precisions.append( correct_translation / len(trans_sent) )
# 		recalls.append( correct_translation / len(correct_sent) )
# precision = sum(precisions)/len(precisions) 
# recall = sum(recalls)/len(recalls) 
# f_score = 2*(precision*recall)/(precision+recall)
# print("F Score, computed as the average of individual sentence f-scores is: %.3f" % (f_score))


# FSCORE THREE
correct_translations = 0
num_trans_sentence_words = 0
num_correct_sentence_words = 0
for trans_sent,correct_sent in sentence_pairs:
	trans_sent = trans_sent.split()
	correct_sent = correct_sent.split()
	if len(correct_sent) <= 10:
		num_trans_sentence_words += len(trans_sent)
		num_correct_sentence_words += len(correct_sent)
		for trans_word in trans_sent:
			if trans_word in correct_sent:
				correct_translations += 1

precision = float(correct_translations)/num_trans_sentence_words
recall = float(correct_translations)/num_correct_sentence_words
f_score = 2*(precision*recall)/(precision+recall)

print("F Score, computed via lengths of sentences is: %.3f" % (f_score))

