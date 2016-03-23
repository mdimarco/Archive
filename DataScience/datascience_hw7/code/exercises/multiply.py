

import MapReduce
import sys


mr = MapReduce.MapReduce()

def mapper(entry):
	if entry[0] == 'a':
		ai = entry[1]
		aj = entry[2]
		bi = aj
		value = entry[3]
		for bj in range(5):
			mr.emit_intermediate((ai,bj), (ai,aj,bi,bj,value)    )

	else:
		bi = entry[1]
		bj = entry[2]
		aj = bi
		value = entry[3]
		for ai in range(5):
			mr.emit_intermediate((ai,bj), (ai,aj,bi,bj,value)    )

def reducer(coords, values):
	ci = coords[0]
	cj = coords[1]
	prods = []
	for x in range(len(values)):
		for y in range(len(values)):
			if values[x][0:4] == values[y][0:4] and x != y:
				x_val = values[x][-1]
				y_val = values[y][-1]
				prods.append(int(x_val)*int(y_val))
	#divided by 2 because double counted
	mr.emit((ci,cj,sum(prods)/2))






if __name__ == '__main__':
  # the code loads the json file and executes 
  # the MapReduce query which prints the result to stdout.
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)