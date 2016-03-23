# version code 031e89400b69
# Please fill out this stencil and submit using the provided submission script.

from GF2 import one
from math import sqrt, pi
from matutil import coldict2mat
from solver import solve
from vec import *



## 1: (Problem 5.14.1) Span of Vectors over R, A
# For each part, please provide your solution as a list of the coefficients for
# the generators of V.
#
# For example, [1, 3, 5] would mean 1*[2,0,4,0] + 3*[0,1,0,1] + 5*[0,0,-1,-1]

rep_1 = [1,1,0]
rep_2 = [0.5,1,1 ]
rep_3 = [0, 1, -1]



## 2: (Problem 5.14.2) Span of Vectors over R, B
# For each part, please provide your solution as a list of the coefficients for
# the generators of V.

lin_comb_coefficients_1 = [...]
lin_comb_coefficients_2 = [...]
lin_comb_coefficients_3 = [...]
lin_comb_coefficients_4 = [...]



## 3: (Problem 5.14.3) Span of Vectors over GF2 A
# Use one from the GF2 module, not the integer 1.
# For each part, please provide your solution as a list of the coefficients for
# the generators of V.

gf2_rep_1 = [one,0,one,0]
gf2_rep_2 = [one,0,0,one]
gf2_rep_3 = [one,one,0,one]



## 4: (Problem 5.14.4) Span of Vectors over GF2 B
# Use one from the GF2 module, not the integer 1.
# For each part, please provide your solution as a list of the coefficients for
# the generators of V.

gf2_lc_rep_1 = [0,0,0,0,1,1,0,0]
gf2_lc_rep_2 = [0,0,0,0,0,0,1,1]
gf2_lc_rep_3 = [1,0,0,1,0,0,0,0]
gf2_lc_rep_4 = [1,0,1,0,0,0,0,0]



## 5: (Problem 5.14.5) Linear Dependence over R A
# For each part, please provide your solution as a list of the coefficients for
# the generators of V.

lin_dep_R_1 = [-2,1,1]
lin_dep_R_2 = [1,-1/4,1/7]
lin_dep_R_3 = [-1.5/5,0,0,1,3]



## 6: (Problem 5.14.6) Linear Dependence over R B
# Please record your solution as a list of coefficients

linear_dep_R_1 = [...]
linear_dep_R_2 = [...]
linear_dep_R_3 = [...]



## 7: (Problem 5.14.7) Superfluous vector
# Assign the COEFFICIENT of the vector to each variable.
# Assign sum_to to the vector that you are expressing as a linear combination
# of the other two.  Write the name of the vector as a STRING.  i.e. 'u' or 'w'

u = -1
v = 1
w = 0
sum_to = 'w'



## 8: (Problem 5.14.8) 4 linearly dependent vectors, every 3 are independent
# Please use the Vec class to represent your vectors

indep_vec_1 = Vec({0,1,2,3,4}, {0:1,2:1})
indep_vec_2 = Vec({0,1,2,3,4}, {1:1,3:1})
indep_vec_3 = Vec({0,1,2,3,4}, {4:1})
indep_vec_4 = Vec({0,1,2,3,4}, {0:1,1:1,2:1,3:1,4:1})



## 9: (Problem 5.14.9) Linear Dependence over GF(2) A
# Please give your solution as a list of coefficients of the linear combination

zero_comb_1 = [one,one,0,one]
zero_comb_2 = [0,one,one,one]
zero_comb_3 = [one,one,0,0,one]



## 10: (Problem 5.14.10) Linear Dependence over GF(2) B
# Please give your solution as a list of coefficients of the vectors
# in the set in order (list the coefficient for v_i before v_j if i < j).

sum_to_zero_1 = [...]
sum_to_zero_2 = [...]
sum_to_zero_3 = [...]
sum_to_zero_4 = [...]



## 11: (Problem 5.14.11) Exchange Lemma for Vectors over $\R$
## Please express your answer as a list of ints, such as [1,0,0,0,0]

exchange_1 = [0,0,1,0,0]
exchange_2 = [0,0,0,1,0]
exchange_3 = [0,0,0,0,1]



## 12: (Problem 5.14.12) Exchange Lemma for Vectors over GF(2)
# Please give the name of the vector you want to replace as a string (e.g. 'v1')

replace_1 = 'v3'
replace_2 = 'v1'
replace_3 = 'v1'



## 13: (Problem 5.14.13) rep2vec
def rep2vec(u, veclist):

    '''
    Input:
        - u: a vector as an instance of your Vec class with domain set(range(len(veclist)))
        - veclist: a list of n vectors (as Vec instances)
    Output:
        vector v (as Vec instance) whose coordinate representation is u
    Example:
        >>> a0 = Vec({'a','b','c','d'}, {'a':1})
        >>> a1 = Vec({'a','b','c','d'}, {'b':1})
        >>> a2 = Vec({'a','b','c','d'}, {'c':1})
        >>> rep2vec(Vec({0,1,2}, {0:2, 1:4, 2:6}), [a0,a1,a2]) == Vec({'a', 'c', 'b', 'd'},{'a': 2, 'c': 6, 'b': 4, 'd': 0})
        True
    '''
    genMatrix = coldict2mat(veclist)
    return genMatrix*u


a0 = Vec({'a','b','c','d'}, {'a':1})
a1 = Vec({'a','b','c','d'}, {'b':1})
a2 = Vec({'a','b','c','d'}, {'c':1})

## 14: (Problem 5.14.14) vec2rep
def vec2rep(veclist, v):
    '''
    Input:
        - veclist: a list of vectors (as instances of your Vec class)
        - v: a vector (as Vec instance) with domain set(range(len(veclist)))
             with v in the span of set(veclist).
    Output:
        Vec instance u whose coordinate representation w.r.t. veclist is v
    Example:
        >>> a0 = Vec({'a','b','c','d'}, {'a':1})
        >>> a1 = Vec({'a','b','c','d'}, {'b':1})
        >>> a2 = Vec({'a','b','c','d'}, {'c':1})
        >>> vec2rep([a0,a1,a2], Vec({'a','b','c','d'}, {'a':3, 'c':-2})) == Vec({0, 1, 2},{0: 3.0, 1: 0.0, 2: -2.0})
        True
    '''
    genMatrix = coldict2mat(veclist)
    return solve(genMatrix,v)

a0 = Vec({'a','b','c','d'}, {'a':1})
a1 = Vec({'a','b','c','d'}, {'b':1})
a2 = Vec({'a','b','c','d'}, {'c':1})
v = Vec({'a','b','c','d'}, {'a':3, 'c':-2})

## 15: (Problem 5.14.15) Superfluous Vector in Python
def is_superfluous(L, i):

    '''
    Input:
        - L: list of vectors as instances of Vec class
        - i: integer in range(len(L))
    Output:
        True if the span of the vectors of L is the same
        as the span of the vectors of L, excluding L[i].

        False otherwise.
    Examples:
        >>> a0 = Vec({'a','b','c','d'}, {'a':1})
        >>> a1 = Vec({'a','b','c','d'}, {'b':1})
        >>> a2 = Vec({'a','b','c','d'}, {'c':1})
        >>> a3 = Vec({'a','b','c','d'}, {'a':1,'c':3})
        >>> is_superfluous(L, 3)
        True
        >>> is_superfluous([a0,a1,a2,a3], 3)
        True
        >>> is_superfluous([a0,a1,a2,a3], 0)
        True
        >>> is_superfluous([a0,a1,a2,a3], 1)
        False
    '''
    if len(L) <= 1:
        if L[i].is_almost_zero:
            return True
        else:
            return False


    L = L[:] 
    b = L.pop(i)
    M = coldict2mat(L)
    x = solve( M ,b)

    b2 = M*x 


    return (b2 - b).is_almost_zero()

    


a0 = Vec({'a','b','c','d'}, {'a':1})
a1 = Vec({'a','b','c','d'}, {'b':1})
a2 = Vec({'a','b','c','d'}, {'c':1})
a3 = Vec({'a','b','c','d'}, {'a':1,'c':3})
#L = [a0,a1,a2,a3]

## 16: (Problem 5.14.16) is_independent in Python
def is_independent(L):
    '''
    input: a list L of vectors (using vec class)
    output: True if the vectors form a linearly independent list.
    >>> vlist = [Vec({0, 1, 2},{0: 1, 1: 0, 2: 0}), Vec({0, 1, 2},{0: 0, 1: 1, 2: 0}), Vec({0, 1, 2},{0: 0, 1: 0, 2: 1}), Vec({0, 1, 2},{0: 1, 1: 1, 2: 1}), Vec({0, 1, 2},{0: 0, 1: 1, 2: 1}), Vec({0, 1, 2},{0: 1, 1: 1, 2: 0})]
    >>> is_independent(vlist)
    False
    >>> is_independent(vlist[:3])
    True
    >>> is_independent(vlist[:2])
    True
    >>> is_independent(vlist[1:4])
    True
    >>> is_independent(vlist[2:5])
    True
    >>> is_independent(vlist[2:6])
    False
    >>> is_independent(vlist[1:3])
    True
    >>> is_independent(vlist[5:])
    True
    '''
    if len(L) == 1:
        return True

    for aVec in range(len(L)):
        splic = L[:]
        del splic[aVec]

        M = coldict2mat(splic)
        x = solve(M, L[aVec])

        if( M*x == L[aVec]):
            return False
    return True


## 17: (Problem 5.14.17) Subset Basis
a = [0,1,3]
def subset_basis(T):
    '''
    input: A list, T, of Vecs
    output: A list, S, containing Vecs from T, that is a basis for the
    space spanned by T.

    >>> from h10_21 import is_superfluous, is_independent

    >>> a0 = Vec({'a','b','c','d'}, {'a':1})
    >>> a1 = Vec({'a','b','c','d'}, {'b':1})
    >>> a2 = Vec({'a','b','c','d'}, {'c':1})
    >>> a3 = Vec({'a','b','c','d'}, {'a':1,'c':3})
    >>> sb = subset_basis([a0, a1, a2, a3])
    >>> all(v in [a0, a1, a2, a3] for v in sb)
    True
    >>> is_independent(sb)
    True
    >>> all(is_superfluous([a]+sb, 0) for a in [a0, a1, a2, a3])
    True

    >>> b0 = Vec({0,1,2,3},{0:2,1:2,3:4})
    >>> b1 = Vec({0,1,2,3},{0:1,1:1})
    >>> b2 = Vec({0,1,2,3},{2:3,3:4})
    >>> b3 = Vec({0,1,2,3},{3:3})
    >>> sb = subset_basis([b0, b1, b2, b3])
    >>> all(v in [b0, b1, b2, b3] for v in sb)
    True
    >>> is_independent(sb)
    True
    >>> all(is_superfluous([b]+sb, 0) for b in [b0, b1, b2, b3])
    True
    '''

    newT = []
    for x in range(len(T)):
        S = newT + [ T[x] ]
        if( is_independent(S) ):
            newT.append(T[x])
    return newT
            
a0 = Vec({'a','b','c','d'}, {'a':1})
a1 = Vec({'a','b','c','d'}, {'b':1})
a2 = Vec({'a','b','c','d'}, {'c':1})
a3 = Vec({'a','b','c','d'}, {'a':1,'c':3})
sb = subset_basis([a0, a1, a2, a3])

b0 = Vec({0,1,2,3},{0:2,1:2,3:4})
b1 = Vec({0,1,2,3},{0:1,1:1})
b2 = Vec({0,1,2,3},{2:3,3:4})
b3 = Vec({0,1,2,3},{3:3})
sb = subset_basis([b0, b1, b2, b3]) 

## 18: (Problem 5.14.18) Superset Basis Lemma in Python
def superset_basis(T, L):
    '''
    Input:
        - T: linearly independent list of Vec instances
        - L: list of Vec instances such that every vector in T is in Span(L)
    Output:
        Linearly independent list S containing all vectors (as instances of Vec)
        such that the span of S is the span of L (i.e. S is a basis for the span
        of L).
    Example:
        >>> a0 = Vec({'a','b','c','d'}, {'a':1})
        >>> a1 = Vec({'a','b','c','d'}, {'b':1})
        >>> a2 = Vec({'a','b','c','d'}, {'c':1})
        >>> a3 = Vec({'a','b','c','d'}, {'a':1,'c':3})
        >>> superset_basis([a0, a3], [a0, a1, a2]) == [Vec({'a', 'c', 'b', 'd'},{'a': 1}), Vec({'a', 'c', 'b', 'd'},{'b':1}),Vec({'a', 'c', 'b', 'd'},{'c': 1})]
        True
    '''
    """X = subset_basis(T)
    for aVec in L:
        X.append(aVec)
        if not is_independent( X ):
            X.pop()
    return X"""

    S = T[:]
    for aVec in L:
        if not is_superfluous(S+[aVec], len(S) ):
            S.append(aVec)
    return S



a0 = Vec({'a','b','c','d'}, {'a':1})
a1 = Vec({'a','b','c','d'}, {'b':1})
a2 = Vec({'a','b','c','d'}, {'c':1})
a3 = Vec({'a','b','c','d'}, {'a':1,'c':3})
#print(superset_basis([a0, a3], [a0, a1, a2]) ) #== [Vec({'a', 'c', 'b', 'd'},{'a': 1}), Vec({'a', 'c', 'b', 'd'},{'b':1}),Vec({'a', 'c', 'b', 'd'},{'c': 1})])


## 19: (Problem 5.14.19) Exchange Lemma in Python
def exchange(S, A, z):
    '''
    Input:
        - S: a list of vectors, as instances of your Vec class
        - A: a list of vectors, each of which are in S, with len(A) < len(S)
        - z: an instance of Vec such that A+[z] is linearly independent
    Output: a vector w in S but not in A such that Span S = Span ({z} U S - {w})
    Example:
        >>> S = [list2vec(v) for v in [[0,0,5,3],[2,0,1,3],[0,0,1,0],[1,2,3,4]]]
        >>> A = [list2vec(v) for v in [[0,0,5,3],[2,0,1,3]]]
        >>> z = list2vec([0,2,1,1])
        >>> exchange(S, A, z) == Vec({0, 1, 2, 3},{0: 0, 1: 0, 2: 1, 3: 0})
        True
    '''
    mat = S[:]

    for aVec in mat:
        if aVec not in A and is_superfluous(mat+[z], mat.index(aVec) ):
            return aVec


    return z

from vecutil import *

S = [list2vec(v) for v in [[0,0,5,3],[2,0,1,3],[0,0,1,0],[1,2,3,4]]]
A = [list2vec(v) for v in [[0,0,5,3],[2,0,1,3]]]
z = list2vec([0,2,1,1])


S = [list2vec(v) for v in [[0,one,one,one],[one,0,one,one],[one,one,one,0]    ]    ]
A = [list2vec(v) for v in [[0,one,one,one], [one,one,0,one]]   ]
z = list2vec([one,one,one,0])

