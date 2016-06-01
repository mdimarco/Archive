import sys
from parse import Parser

rules_filename = sys.argv[1]
sentences_filename = sys.argv[2]
output_filename = sys.argv[3]

parser = Parser(rules_filename, sentences_filename, output_filename)

