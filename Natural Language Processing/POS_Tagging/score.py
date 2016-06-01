import sys
from util import text_util
correct_filename = sys.argv[1]
my_out_filename  = sys.argv[2]


correct_data = text_util.process_file(correct_filename)
my_output = text_util.process_file(my_out_filename)

print(text_util.score(my_output, correct_data))