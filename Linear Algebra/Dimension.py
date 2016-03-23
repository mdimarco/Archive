# version code 7d9727d30a62
# Please fill out this stencil and submit using the provided submission script.

from vecutil import *
from GF2 import one
from solver import solve
from matutil import listlist2mat, coldict2mat, rowdict2mat, mat2rowdict, mat2coldict
from mat import Mat
from vec import Vec
from The_Basis import *
from independence import rank

## 1: (Problem 6.7.2) Iterative Exchange Lemma
w0 = list2vec([1,0,0])
w1 = list2vec([0,1,0])
w2 = list2vec([0,0,1])

v0 = list2vec([1,2,3])
v1 = list2vec([1,3,3])
v2 = list2vec([0,3,3])

# Fill in exchange_S1 and exchange_S2
# with appropriate lists of 3 vectors

exchange_S0 = [w0, w1, w2]
exchange_S1 = [w0,v2,w2]
exchange_S2 = [v1,v2,w2]
exchange_S3 = [v0, v1, v2]



## 2: (Problem 6.7.3) Another Iterative Exchange Lemma
w0 = list2vec([0,one,0])
w1 = list2vec([0,0,one])
w2 = list2vec([one,one,one])

v0 = list2vec([one,0,one])
v1 = list2vec([one,0,0])
v2 = list2vec([one,one,0])

exchange_2_S0 = [w0, w1, w2]
exchange_2_S1 = [...]
exchange_2_S2 = [...]
exchange_2_S3 = [v0, v1, v2]



## 3: (Problem 6.7.4) Morph Lemma Coding
def morph(S, B):
    '''
    Input:
        - S: a list of distinct Vec instances
        - B: a list of linearly independent Vec instances
        - Span S == Span B
    Output: a list of pairs of vectors to inject and eject
    Example:
        >>> # This is how our morph works.  Yours may yield different results.
        >>> # Note: Make a copy of S to modify instead of modifying S itself.
        >>> S = [list2vec(v) for v in [[1,0,0],[0,1,0],[0,0,1]]]
        >>> B = [list2vec(v) for v in [[1,1,0],[0,1,1],[1,0,1]]]
        >>> morph(S, B)
        [(Vec({0, 1, 2},{0: 1, 1: 1, 2: 0}), Vec({0, 1, 2},{0: 1, 1: 0, 2: 0})), (Vec({0, 1, 2},{0: 0, 1: 1, 2: 1}), Vec({0, 1, 2},{0: 0, 1: 1, 2: 0})), (Vec({0, 1, 2},{0: 1, 1: 0, 2: 1}), Vec({0, 1, 2},{0: 0, 1: 0, 2: 1}))]
        >>> S == [list2vec(v) for v in [[1,0,0],[0,1,0],[0,0,1]]]
        True
        >>> B == [list2vec(v) for v in [[1,1,0],[0,1,1],[1,0,1]]]
        True
    '''
    S1 = S[:]
    A = []
    final = []

    for b in B:
        for s in S1:
            if s not in A:
                S1.pop(S1.index(s))
                S1.append( b )
                if solve(coldict2mat(S1), s).is_almost_zero():
                    S1.pop()
                else:
                    A.append(b)
                    final.append( (b,s) )
                    break

    return final



## 4: (Problem 6.7.5) Row and Column Rank Practice
# Please express each solution as a list of vectors (Vec instances)

row_space_1 = [list2vec(v) for v in [[1,0,0], [0,0,1]] ]
col_space_1 = [list2vec(v) for v in [[1,0], [0,1]] ]

row_space_2 = [list2vec(v) for v in [[1,0,0,0 ], [0,1,0,0], [0,0,1,0] ] ]#Either works [[1,0,-4,0], [0,1,0,1], [1,0,0,4] ] ]
col_space_2 = [list2vec(v) for v in [[1,0,0], [0,1,0],[0,0,1]] ]

row_space_3 = [list2vec(v) for v in [[1]] ]
col_space_3 = [list2vec(v) for v in [[1,0,0]] ] 

row_space_4 = [ list2vec(v) for v in [[1,0], [0,1]] ]
col_space_4 = [ list2vec(v) for v in [[1,0,0], [0,0,1]]]



## 5: (Problem 6.7.6) My Is Independent Procedure
def my_is_independent(L):
    '''
    Input:
        - L: a list of Vecs
    Output:
        - boolean: true if the list is linearly independent
    Examples:
        >>> D = {0, 1, 2}
        >>> L = [Vec(D,{0: 1}), Vec(D,{1: 1}), Vec(D,{2: 1}), Vec(D,{0: 1, 1: 1, 2: 1}), Vec(D,{0: 1, 1: 1}), Vec(D,{1: 1, 2: 1})]
        >>> my_is_independent(L)
        False
        >>> my_is_independent(L[:2])
        True
        >>> my_is_independent(L[:3])
        True
        >>> my_is_independent(L[1:4])
        True
        >>> my_is_independent(L[0:4])
        False
        >>> my_is_independent(L[2:])
        False
        >>> my_is_independent(L[2:5])
        False
        >>> L == [Vec(D,{0: 1}), Vec(D,{1: 1}), Vec(D,{2: 1}), Vec(D,{0: 1, 1: 1, 2: 1}), Vec(D,{0: 1, 1: 1}), Vec(D,{1: 1, 2: 1})]
        True
        01  -.5
        01  .5
        11

    '''

    return  (rank(L) == len(L)) if len(L) else True



#D = {0, 1, 2}
#L = [Vec(D,{0: 1}), Vec(D,{1: 1}), Vec(D,{2: 1}), Vec(D,{0: 1, 1: 1, 2: 1}), Vec(D,{0: 1, 1: 1}), Vec(D,{1: 1, 2: 1})]
#print(my_is_independent(L))
#print(my_is_independent(L[:2]))
#print(my_is_independent(L[:3]))
#print(my_is_independent(L[1:4]))
#print(my_is_independent(L[0:4]))
#print(my_is_independent(L[2:]))
#print(my_is_independent(L[2:5]))
#print(L == [Vec(D,{0: 1}), Vec(D,{1: 1}), Vec(D,{2: 1}), Vec(D,{0: 1, 1: 1, 2: 1}), Vec(D,{0: 1, 1: 1}), Vec(D,{1: 1, 2: 1})])

## 6: (Problem 6.7.7) My Rank
from The_Basis import *
def my_rank(L):
    '''
    Input: 
        - L: a list of Vecs
    Output: 
        - the rank of the list of Vecs
    Example:
        >>> L = [list2vec(v) for v in [[1,2,3],[4,5,6],[1.1,1.1,1.1]]]
        >>> my_rank(L)
        2
        >>> L == [list2vec(v) for v in [[1,2,3],[4,5,6],[1.1,1.1,1.1]]]
        True
        >>> my_rank([list2vec(v) for v in [[1,1,1],[2,2,2],[3,3,3],[4,4,4],[123,432,123]]])
        2
        
    '''
    counter = 0
    M = []
    for l in L:
        M.append(l)
        if not my_is_independent(M):
            M.pop()
    return len(M)

L = [list2vec(v) for v in [[1,2,3],[4,5,6],[1.1,1.1,1.1]]]
#rint(my_rank(L))


## 7: (Problem 6.7.9) Direct Sum Validity
# Please give each answer as a boolean

only_share_the_zero_vector_1 = True
only_share_the_zero_vector_2 = True
only_share_the_zero_vector_3 = True



## 8: (Problem 6.7.11) Direct Sum Unique Representation
def direct_sum_decompose(U_basis, V_basis, w):
    '''
    Input:
        - U_basis: a list of Vecs forming a basis for a vector space U
        - V_basis: a list of Vecs forming a basis for a vector space V
        - w: a Vec in the direct sum of U and V
    Output:
        - a pair (u, v) such that u + v = w, u is in U, v is in V
    Example:
        >>> U_basis = [Vec({0, 1, 2, 3, 4, 5},{0: 2, 1: 1, 2: 0, 3: 0, 4: 6, 5: 0}), Vec({0, 1, 2, 3, 4, 5},{0: 11, 1: 5, 2: 0, 3: 0, 4: 1, 5: 0}), Vec({0, 1, 2, 3, 4, 5},{0: 3, 1: 1.5, 2: 0, 3: 0, 4: 7.5, 5: 0})]
        >>> V_basis = [Vec({0, 1, 2, 3, 4, 5},{0: 0, 1: 0, 2: 7, 3: 0, 4: 0, 5: 1}), Vec({0, 1, 2, 3, 4, 5},{0: 0, 1: 0, 2: 15, 3: 0, 4: 0, 5: 2})]
        >>> w = Vec({0, 1, 2, 3, 4, 5},{0: 2, 1: 5, 2: 0, 3: 0, 4: 1, 5: 0})
        >>> direct_sum_decompose(U_basis, V_basis, w) == (Vec({0, 1, 2, 3, 4, 5},{0: 2.0, 1: 4.999999999999972, 2: 0.0, 3: 0.0, 4: 1.0, 5: 0.0}), Vec({0, 1, 2, 3, 4, 5},{0: 0.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0}))
        True
    '''
    W = U_basis+V_basis
    W = coldict2mat(W)

    x = solve( W, w )

    u = []
    counter = 0
    for u1 in U_basis:
        u.append( x[counter]*u1)
        counter+=1

    v = []
    for v1 in V_basis:
        v.append( x[counter]*v1)
        counter+=1

    u=sum(u)
    v=sum(v)

    return u,v

#U_basis = [Vec({0,1,2}, {0:1,1:0,2:0}),Vec({0,1,2}, {0:0,1:1,2:0})]
#V_basis = [Vec({0,1,2}, {0:0,1:0,2:1})]
#w = Vec({0,1,2}, {0:1,1:1,2:1})


## 9: (Problem 6.7.12) Is Invertible Function
def is_invertible(M):
    '''
    input: A matrix, M
    outpit: A boolean indicating if M is invertible.

    >>> M = Mat(({0, 1, 2, 3}, {0, 1, 2, 3}), {(0, 1): 0, (1, 2): 1, (3, 2): 0, (0, 0): 1, (3, 3): 4, (3, 0): 0, (3, 1): 0, (1, 1): 2, (2, 1): 0, (0, 2): 1, (2, 0): 0, (1, 3): 0, (2, 3): 1, (2, 2): 3, (1, 0): 0, (0, 3): 0})
    >>> is_invertible(M)
    True

    >>> M1 = Mat(({0,1,2},{0,1,2}),{(0,0):1,(0,2):2,(1,2):3,(2,2):4})
    >>> is_invertible(M1)
    False
    '''
    if(M.D[0] != M.D[1]):
        return False
    M =  mat2coldict(M)
    M = [x for x in M.values()]
    ran = rank(M)
    return my_is_independent(M) 

M = Mat(({0, 1, 2, 3}, {0, 1, 2, 3}), {(0, 1): 0, (1, 2): 1, (3, 2): 0, (0, 0): 1, (3, 3): 4, (3, 0): 0, (3, 1): 0, (1, 1): 2, (2, 1): 0, (0, 2): 1, (2, 0): 0, (1, 3): 0, (2, 3): 1, (2, 2): 3, (1, 0): 0, (0, 3): 0})
#print(is_invertible(M))

M1 = Mat(({0,1,2},{0,1,2}),{(0,0):1,(0,2):2,(1,2):3,(2,2):4})
#print(is_invertible(M1))


## 10: (Problem 6.7.13) Inverse of a Matrix over GF(2)
def find_matrix_inverse(A):
    '''
    Input:
        - A: an invertible Mat over GF(2)
    Output:
        - A Mat that is the inverse of A
    Examples:
        >>> M1 = Mat(({0,1,2}, {0,1,2}), {(0, 1): one, (1, 0): one, (2, 2): one})
        >>> find_matrix_inverse(M1) == Mat(M1.D, {(0, 1): one, (1, 0): one, (2, 2): one})
        True
        >>> M2 = Mat(({0,1,2,3},{0,1,2,3}),{(0,1):one,(1,0):one,(2,2):one})
        >>> find_matrix_inverse(M2) == Mat(M2.D, {(0, 1): one, (1, 0): one, (2, 2): one})
        True
    '''

    size = A.D[0]
    eye = [ Vec(size, { x:one } ) for x in range(len(size))]

    inv = []
    for col in eye:
        inv.append( solve(A,col) )

    return coldict2mat(inv) 
    

    
M1 = Mat(({0,1,2}, {0,1,2}), {(0, 1): one, (1, 0): one, (2, 2): one})
find_matrix_inverse(M1) #== Mat(M1.D, {(0, 1): one, (1, 0): one, (2, 2): one})


## 11: (Problem 6.7.14) Inverse of a Triangular Matrix
def find_triangular_matrix_inverse(A):
    '''
    Supporting GF2 is not required.

    Input:
        - A: an upper triangular Mat with nonzero diagonal elements
    Output:
        - Mat that is the inverse of A
    
    Example:
        >>> A = listlist2mat([[1, .5, .2, 4],[0, 1, .3, .9],[0,0,1,.1],[0,0,0,1]])
        >>> find_triangular_matrix_inverse(A) == Mat(({0, 1, 2, 3}, {0, 1, 2, 3}), {(0, 1): -0.5, (1, 2): -0.3, (3, 2): 0.0, (0, 0): 1.0, (3, 3): 1.0, (3, 0): 0.0, (3, 1): 0.0, (2, 1): 0.0, (0, 2): -0.05000000000000002, (2, 0): 0.0, (1, 3): -0.87, (2, 3): -0.1, (2, 2): 1.0, (1, 0): 0.0, (0, 3): -3.545, (1, 1): 1.0})
        True
    '''

    size = A.D[0]
    eye = [ Vec(size, { x:1 } ) for x in range(len(size))]

    inv = []
    for col in eye:
        inv.append( solve(A,col) )

    return coldict2mat(inv)

A = [[1,2.28,1.79,-0.621], [0,1,-2.2,0.65], [0,0,1,0], [0,0,0,1]]
A = listlist2mat(A)

print(find_triangular_matrix_inverse(   A  ))

