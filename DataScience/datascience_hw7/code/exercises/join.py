

import json
import MapReduce
import sys

mr = MapReduce.MapReduce()


def mapper(record):
	if record[0] == "order":
		mr.emit_intermediate("o"+record[1],record)
	else:
		mr.emit_intermediate(record[1],record)

def reducer(key,values):
	if key[0] != "o":
		order_part = mr.intermediate["o"+key]
		for line_part in values:
			mr.emit(order_part[0]+line_part)



if __name__ == '__main__':
  # the code loads the json file and executes 
  # the MapReduce query which prints the result to stdout.
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
