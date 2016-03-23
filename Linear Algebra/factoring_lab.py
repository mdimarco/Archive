# version code 112c76cd8477+
# Please fill out this stencil and submit using the provided submission script.

from vec import Vec
from GF2 import one

from factoring_support import dumb_factor
from factoring_support import intsqrt
from factoring_support import gcd
from factoring_support import primes
from factoring_support import prod

import echelon

## Task 1
def int2GF2(i):
    '''
    Returns one if i is odd, 0 otherwise.

    Input:
        - i: an int
    Output:
        - one if i is congruent to 1 mod 2
        - 0   if i is congruent to 0 mod 2
    Examples:
        >>> int2GF2(3)
        one
        >>> int2GF2(100)
        0
    '''
    return 0 if i%2 == 0 else one


## Task 2
def make_Vec(primeset, factors):
    '''
    Input:
        - primeset: a set of primes
        - factors: a list of factors [(p_1,a_1), ..., (p_n, a_n)]
                   with p_i in primeset
    Output:
        - a vector v over GF(2) with domain primeset
          such that v[p_i] = int2GF2(a_i) for all i
    Example:
        >>> make_Vec({2,3,11}, [(2,3), (3,2)]) == Vec({2,3,11},{2:one})
        True
    '''
    return Vec(primeset, {tup[0]:int2GF2(tup[1]) for tup in factors } )
  

## Task 3
def find_candidates(N, primeset):
    '''
    Input:
        - N: an int to factor
        - primeset: a set of primes

    Output:
        - a tuple (roots, rowlist)
        - roots: a list a_0, a_1, ..., a_n where a_i*a_i - N can be factored
                 over primeset
        - rowlist: a list such that rowlist[i] is a
                   primeset-vector over GF(2) corresponding to a_i
          such that len(roots) = len(rowlist) and len(roots) > len(primeset)
    '''

    roots = []
    rowlist = []
    x = intsqrt(N)+2

    while( len(roots) <= len(primeset)+1 ):
        fact = dumb_factor(x*x-N, primeset)   
        if fact:
          roots.append(x)
          rowlist.append( make_Vec(primeset, fact) )
        x += 1

    return (roots, rowlist)



## Task 4
def find_a_and_b(v, roots, N):
    '''
    Input: 
     - a {0,1,..., n-1}-vector v over GF(2) where n = len(roots)
     - a list roots of integers
     - an integer N to factor
    Output:
      a pair (a,b) of integers
      such that a*a-b*b is a multiple of N
      (if v is correctly chosen)
    '''
    alist = [ roots[i] for i in range(len(v.D)) if v[i] == one ]
    a = prod(alist)
    c = prod( [x*x-N for x in alist] )
    b = intsqrt(c)
    return a,b

## Task 5
print("Start")
primelist = primes(1000)
N = 2461799993978700679
candidates = find_candidates(N, primelist)
print("Found Candidates")
M = echelon.transformation_rows( candidates[1] )
print("Found M")
print(len(M))


'''for x in range(len(M)-1,-1,-1):
  v = M[x]
  a,b = find_a_and_b(v, candidates[0], N)
  c = gcd(N, a-b)
  if c != 1 and c!=N:
    break
print(a-b)
print(gcd(N, a-b) )'''

nontrivial_divisor_of_2461799993978700679 = 1230926561 
