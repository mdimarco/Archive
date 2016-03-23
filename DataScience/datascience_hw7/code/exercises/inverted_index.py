

import json
import MapReduce
import sys






mr = MapReduce.MapReduce()


def mapper(book_input):
	doc_id = book_input[0]
	text = book_input[1]
	for word in text.split():
		mr.emit_intermediate(word,doc_id)

def reducer(word, list_of_docs):
	uniques = []
	for doc in list_of_docs:
		if doc not in uniques:
			uniques.append(doc)
	mr.emit((word,uniques))


if __name__ == '__main__':
  # the code loads the json file and executes 
  # the MapReduce query which prints the result to stdout.
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)

