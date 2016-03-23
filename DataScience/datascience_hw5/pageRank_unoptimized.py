import csv
import argparse
import time

"""
Return the top num_top page rank ids
	linksReader: a csv reader. The first entry per line indicates the id of
				the page which links to all the other entries in the line.
	eps: the convergence condition. Final results should use eps = .01.
	d: the probability of following an outgoing link on the page rather than
		making a teleport to a random page: it follows that (1 - d) is the chance
		of making a teleport.
	num_top: the number of top page ranks to return; default is 3

You are welcome to write helper functions or to do everything in the pageRank
function. Just try to make your pageRank implementation as fast as possible!
"""
def pageRank(linksReaderPath, eps, d, num_top):




	current_PR = [0]
	new_PR = [0]

	#Populate current/new page ranks
	for node in csv.reader(open(linksReaderPath)):
		current_PR.append(1)
		new_PR.append(0)


	alpha = 100
	num_nodes = len(current_PR)-1


	loop1_time = []
	inner_time = []

	while alpha > float(eps):

		print("Alpha", alpha)


		c = 0
		#l1_start = time.clock()
		for node in csv.reader(open(linksReaderPath)):
			num_links = len(node)-1
			in_start = time.clock()

			node_pr = current_PR[int(node[0])]
			for i in range(1,num_links+1):
				link = int(node[i])
				c+= node_pr / num_links
				new_PR[link] += node_pr / num_links
			#inner_time.append(time.clock()-in_start)
		#loop1_time.append(time.clock()-l1_start)



		alpha = 0
		pr_teleport = (1-d)/float(num_nodes)
		for i in range(1,num_nodes+1):
			rank = d*new_PR[i]/c + pr_teleport
			alpha += abs( rank - current_PR[i])
			current_PR[i] = rank
			new_PR[i] = 0


	# TODO
	print("Loops",sum(loop1_time),sum(inner_time))
	return current_PR


"""
Do not modify, unless you want to play around with different values of num_top
"""
def main():
	d = 0.85

	parser = argparse.ArgumentParser()
	parser.add_argument('-links', required=True, help='Page links file')
	parser.add_argument('-eps', required=True, help='Convergence condition')
	opts = parser.parse_args()

	start_time = time.clock()
	ranks = pageRank(opts.links, opts.eps, d, 3)
	end_time = time.clock()
	print(sum(ranks))

	ranks[0] = (0,0)
	for i in range(1,len(ranks)):
		ranks[i] = (i,ranks[i])

	print("Time taken: {} seconds.\n".format(end_time - start_time))

	print( sorted(ranks,key=lambda x: x[1],reverse=True)[0:3])

if __name__ == '__main__':
	main()

