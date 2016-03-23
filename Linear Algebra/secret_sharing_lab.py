# version code a52975dbbcb8
# Please fill out this stencil and submit using the provided submission script.
import sys
sys.setrecursionlimit(15000)

import random
from GF2 import one
from vecutil import list2vec
from matutil import *
from independence import is_independent
from itertools import combinations

## 1: (Task 7.7.1) Choosing a Secret Vector
def randGF2(): return random.randint(0,1)*one

a0 = list2vec([one, one,   0, one,   0, one])
b0 = list2vec([one, one,   0,   0,   0, one])

def choose_secret_vector(s,t):
	rand_vec = list2vec([randGF2() for x in range(6)])
	while( not (rand_vec*a0 == s and rand_vec*b0 == t) ):
		rand_vec = list2vec([randGF2() for x in range(6)])
	return rand_vec


def gen_rand_6vec():
	return list2vec([ randGF2() for x in range(6) ])

def pairs_ind( pair1, pair2, pair3):
	pair1 = pair1[:]
	pair1.extend( pair2 )
	pair1.extend( pair3 )

	return is_independent( pair1 )

def req_solve():

	#lin ind pair 1

	flag = True
	while( flag ):

		p0 = [ gen_rand_6vec(), gen_rand_6vec() ]
		p1 = [ gen_rand_6vec(), gen_rand_6vec() ]
		p2 = [ gen_rand_6vec(), gen_rand_6vec() ]
		p3 = [ gen_rand_6vec(), gen_rand_6vec() ]
		p4 = [ a0, b0]


		flag = False
		for combination in combinations( [p0,p1,p2,p3,p4 ], 3 ):
			if not pairs_ind( combination[0], combination[1], combination[2] ):
				flag = True


	return [p0,p1,p2,p3]

## 2: (Task 7.7.2) Finding Secret Sharing Vectors
# Give each vector as a Vec instance
secret_a0 = a0
secret_b0 = b0
secret_a1 = Vec({0, 1, 2, 3, 4, 5},{0: one, 1: 0, 2: 0, 3: 0, 4: one, 5: one})
secret_b1 = Vec({0, 1, 2, 3, 4, 5},{0: one, 1: 0, 2: 0, 3: 0, 4: one, 5: 0})
secret_a2 = Vec({0, 1, 2, 3, 4, 5},{0: 0, 1: 0, 2: one, 3: one, 4: 0, 5: one})
secret_b2 = Vec({0, 1, 2, 3, 4, 5},{0: one, 1: one, 2: one, 3: 0, 4: one, 5: 0})
secret_a3 = Vec({0, 1, 2, 3, 4, 5},{0: one, 1: 0, 2: 0, 3: one, 4: 0, 5: one})
secret_b3 = Vec({0, 1, 2, 3, 4, 5},{0: 0, 1: one, 2: one, 3: 0, 4: one, 5: 0})
secret_a4 = Vec({0, 1, 2, 3, 4, 5},{0: 0, 1: one, 2: 0, 3: 0, 4: 0, 5: one})
secret_b4 = Vec({0, 1, 2, 3, 4, 5},{0: one, 1: 0, 2: one, 3: one, 4: 0, 5: 0})

