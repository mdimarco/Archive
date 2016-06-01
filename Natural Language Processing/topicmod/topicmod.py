import sys
from gibbs_sampler import GibbsSampler
if len(sys.argv) != 2:
	print("Error, incorrect args")
	sys.exit(1)

inp_file = sys.argv[1]

gs = GibbsSampler(inp_file)

