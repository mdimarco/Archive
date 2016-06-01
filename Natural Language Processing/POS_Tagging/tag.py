import sys
sys.path.append("./util")

import text_util, count_util
from viterbi_util import ViterbiRunner

train_file = sys.argv[1]
test_file = sys.argv[2]
output_file = sys.argv[3]


# [ [(word,pos)] ]
train_data = text_util.process_file(train_file)
tau, sigma = count_util.mle(train_data)

test_data = text_util.process_file(test_file)
vr = ViterbiRunner(test_data,tau,sigma)
pred_tags = vr.run()

with open(output_file,'w') as out:
	for sentence in pred_tags:
		for pair in sentence:
			out.write(pair[0]+" "+pair[1]+" ")
		out.write("\n")
