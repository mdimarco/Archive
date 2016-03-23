from __future__ import division
from mrjob.job import MRJob
from mrjob.step import MRStep
import math

VIRTUAL_COUNT = 10
PRIOR_CORRELATION = 0.0
THRESHOLD = 0.5



class Similarities(MRJob):

	def mapper_0(self, _, line):
		# INPUT:
		# 	line: a line from either movies.dat (movie_id::movie_title::genres) or 
		# 		ratings.dat (user_id::movie_id::rating::timestamp)
		# OUTPUT:
		# 	key: movie_id
		# 	value: line.split('::'). a list of values in the line
		spl = line.split("::")
		#Case of ratings.dat
		if len(spl) == 4:
			yield spl[1],[spl[0],int(spl[2])]
		else:
			yield spl[0],[spl[1]]


	def reducer_0(self, key, values):
		# INPUT:
		# 	key: movie_id
		# 	value: a list of values in the line
		# OUTPUT:
		# 	key: movie_title
		# 	value: (user_id, rating)
		movie_title = ""
		ratings = []
		for value in values:
			if len(value) == 1:
				movie_title = value[0]
			else:
				ratings.append((value[0],value[1]))
		for rating in ratings:
			yield movie_title,rating




	def reducer_1(self, key, values):
		# INPUT:
		# 	key: movie_title
		# 	value: list of (user_id, rating)
		# OUTPUT:
		# 	key: user_id
		# 	value: (movie_title, rating, num_raters)
		user_dict = {}
		count = 0
		for value in values:
			count+=1
			user_dict[value[0]] = value[1]

		for user,rating in user_dict.items():
			yield user,(key,rating,count)




	def reducer_2(self, key, values):
		# INPUT:
		# 	key: user_id
		# 	value: list of (movie_title, rating, num_raters)
		# OUTPUT:
		# 	key: (movie_title1, movie_title2)
		# 	value: (rating1, rating2, num_raters1, num_raters2)
		# HINT:
		# 	- use the 'combination' function below to get all pair combinations
		# 	- to maintain some sort of order for later parts, let's keep the order that 
		# 		'movie_title1' < 'movie_title2' in the yield output
		titles = []
		movie_dict = {}

		for value in values:
			titles.append(value[0])
			movie_dict[value[0]] = (value[1],value[2])

		for comb in combinations(titles,2):
			m1 = comb[0]
			m2 = comb[1]
			r1,n1 = movie_dict[m1]
			r2,n2 = movie_dict[m2]
			yield (m1,m2),(r1,r2,n1,n2)


	def reducer_3(self, key, values):
		# INPUT:
		# 	key: movie_title1, movie_title2
		# 	value: list of (rating1, rating2, num_raters1, num_raters2)
		# OUTPUT:
		# 	key: movie_title1
		# 	value: (movie_title2, correlation_value, regularized_correlation_value, cosine_similarity_value, jaccard_similarity_value, n, n1, n2)
		# HINT:
		# 	ignore movie pairs whose regularized_correlation_value < THRESHOLD
		# 		so that we can keep high value movie pairs.

		x = 0
		y = 0
		count = 0
		sumxx = 0
		sumxy = 0
		sumyy = 0
		for v in values:
			x += v[0]
			y += v[1]
			n1 = v[2]
			n2 = v[3]
			sumxx += v[0]*v[0]
			sumyy += v[1]*v[1]
			sumxy += v[0]*v[1]
			count +=1
		reg_corr = regularized_correlation(count,x,y,sumxx,sumyy,sumxy,10,0.0)
		if reg_corr >= 0.5:
			corr_val = correlation(count,x,y,sumxx,sumyy,sumxy)
			cosin_val = cosine_similarity(sumxx,sumyy,sumxy)
			jacc_dist = jaccard_similarity(count,n1,n2)
			yield key[0],(key[1],corr_val,reg_corr,cosin_val,jacc_dist,count,n1,n2)



	def reducer_4(self, key, values):
		# INPUT:
		# 	key: movie_title1
		# 	value: list of (movie_title2, correlation_value, regularized_correlation_value, cosine_similarity_value, jaccard_similarity_value, n, n1, n2)
		# OUTPUT:
		# 	key: (movie_title1, movie_title2)
		# 	value: (correlation_value, regularized_correlation_value, cosine_similarity_value, jaccard_similarity_value, n, n1, n2)
		for val in sorted(values,key=lambda x: x[2],reverse=True):
			yield (key,val[0]),val[1:]




	def steps(self):
		return [
			MRStep(mapper=self.mapper_0,
					reducer=self.reducer_0),
			MRStep(reducer=self.reducer_1),
			MRStep(reducer=self.reducer_2),
			MRStep(reducer=self.reducer_3),
			MRStep(reducer=self.reducer_4)
		]


##### Metric Functions ############################################################################
def correlation(n, sum_x, sum_y, sum_xx, sum_yy, sum_xy):
	# http://en.wikipedia.org/wiki/Correlation_and_dependence
	numerator = n * sum_xy - sum_x * sum_y
	denominator = math.sqrt(n * sum_xx - sum_x * sum_x) * math.sqrt(n * sum_yy - sum_y * sum_y)
	if denominator == 0:
		return 0.0
	return numerator / denominator

def regularized_correlation(n, sum_x, sum_y, sum_xx, sum_yy, sum_xy, virtual_count, prior_correlation):
	unregularized_correlation_value = correlation(n, sum_x, sum_y, sum_xx, sum_yy, sum_xy)
	weight = n / (n + virtual_count)
	return weight * unregularized_correlation_value + (1 - weight) * prior_correlation

def cosine_similarity(sum_xx, sum_yy, sum_xy):
	# http://en.wikipedia.org/wiki/Cosine_similarity
	numerator = sum_xy
	denominator = (math.sqrt(sum_xx) * math.sqrt(sum_yy))
	if denominator == 0:
		return 0.0
	return numerator / denominator

def jaccard_similarity(n_common, n1, n2):
	# http://en.wikipedia.org/wiki/Jaccard_index
	numerator = n_common
	denominator = n1 + n2 - n_common
	if denominator == 0:
		return 0.0
	return numerator / denominator
#####################################################################################################

##### util ##########################################################################################
def combinations(iterable, r):
	# http://docs.python.org/2/library/itertools.html#itertools.combinations
	# combinations('ABCD', 2) --> AB AC AD BC BD CD
	# combinations(range(4), 3) --> 012 013 023 123
	pool = tuple(iterable)
	n = len(pool)
	if r > n:
		return
	indices = range(r)
	yield tuple(pool[i] for i in indices)
	while True:
		for i in reversed(range(r)):
			if indices[i] != i + n - r:
				break
		else:
			return
		indices[i] += 1
		for j in range(i+1, r):
			indices[j] = indices[j-1] + 1
		yield tuple(pool[i] for i in indices)
#####################################################################################################


if __name__ == '__main__':
	Similarities.run()
