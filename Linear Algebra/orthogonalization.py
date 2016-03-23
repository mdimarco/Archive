# version code d755df727932+
# Please fill out this stencil and submit using the provided submission script.

from mat import Mat
from vec import Vec
from vecutil import list2vec
from matutil import * 
from orthogonalization import * 
import orthonormalization
from math import sqrt


## 1: (Problem 9.11.1) Generators for orthogonal complement
ortho_compl_generators_1 = ...

ortho_compl_generators_2 = ...

ortho_compl_generators_3 = ...



## 2: (Problem 9.11.3) Basis for null space
null_space_basis = ...





## 3: (Problem 9.11.9) Orthonormalize(L)
def orthonormalize(L):
    '''
    Input: a list L of linearly independent Vecs
    Output: A list T of orthonormal Vecs such that for all i in [1, len(L)],
            Span L[:i] == Span T[:i]
    '''
    L = orthogonalize(L)
    for i in range(len(L)):
        l = L[i]

        length = sqrt( l * l )
        l = (1/length) * l
        
        L[i] = l
    return L

def adjust( scalars, listo):
	new_list = []
	for x in range(len(scalars)):
	    new_list.append( scalars[x] * listo[x] )
	return list2vec(new_list)

## 4: (Problem 9.11.10) aug_orthonormalize(L)
def aug_orthonormalize(L):
    '''
    Input:
        - L: a list of Vecs
    Output:
        - A pair Qlist, Rlist such that:
            * coldict2mat(L) == coldict2mat(Qlist) * coldict2mat(Rlist)
            * Qlist = orthonormalize(L)
    '''
    Q,R = aug_orthogonalize(L)
    norms = []

    for i in range(len(Q)):
	    l = Q[i]
	    length = sqrt(l*l)
	    Q[i] = (1/length) * l
	    norms.append(length)

    for j in range(len(R)):
	    R[j] = adjust( norms, R[j] )
    return Q,R


L = [ list2vec([6,2,3]) ,list2vec( [6,0,3] ) ]
Q,R = aug_orthonormalize(L)

#for v in Q:
#	print(v[0]*v[0] + v[1]*v[1] + v[2]*v[2] )

#print(coldict2mat(Q) * coldict2mat(R) )
## 5: (Problem 9.11.11) QR factorization of small matrices
#Compute the QR factorization

#Please represent your solution as a list of rows, such as [[1,0,0],[0,1,0],[0,0,1]]

Q = coldict2mat(Q)
Q = mat2rowdict(Q)

R = coldict2mat(R)
R = mat2rowdict(R)



part_1_Q = [ [vec[i] for i in vec.D] for vec in Q.values() ] 
part_1_R = [ [vec[i] for i in vec.D] for vec in R.values() ]


L = [ list2vec([2,2,1]) ,list2vec( [3,1,1] ) ]
Q,R = aug_orthonormalize(L)
#print(Q)
#print(R)

#for v in Q:	
#	print(v[0]*v[0] + v[1]*v[1] + v[2]*v[2] )

#print(coldict2mat(Q) * coldict2mat(R) )

Q = coldict2mat(Q)
Q = mat2rowdict(Q)

R = coldict2mat(R)
R = mat2rowdict(R)



part_2_Q = [ [vec[i] for i in vec.D] for vec in Q.values() ]
part_2_R = [ [vec[i] for i in vec.D] for vec in R.values() ]



## 6: (Problem 9.11.12) QR Solve
def QR_solve(A, b):
    '''
    Input:
        - A: a Mat
        - b: a Vec
    Output:
        - vector x that minimizes norm(b - A*x)
    Note: This procedure uses the module QR, which in turn uses the module dictutil.
           You wrote the module dictutil long back.  Make sure the completed dictutil.py
           is in your matrix directory.
    Example:
        >>> domain = ({'a','b','c'},{'A','B'})
        >>> A = Mat(domain,{('a','A'):-1, ('a','B'):2,('b','A'):5, ('b','B'):3,('c','A'):1,('c','B'):-2})
        >>> Q, R = QR.factor(A)
        >>> b = Vec(domain[0], {'a': 1, 'b': -1})
        >>> x = QR_solve(A, b)
        >>> result = A.transpose()*(b-A*x)
        >>> result * result < 1E-10
        True
    '''
    pass



## 7: (Problem 9.11.13) Least Squares Problem
# Please give each solution as a Vec

least_squares_A1 = listlist2mat([[8, 1], [6, 2], [0, 6]])
least_squares_Q1 = listlist2mat([[.8,-0.099],[.6, 0.132],[0,0.986]])
least_squares_R1 = listlist2mat([[10,2],[0,6.08]])
least_squares_b1 = list2vec([10, 8, 6])

x_hat_1 = ...


least_squares_A2 = listlist2mat([[3, 1], [4, 1], [5, 1]])
least_squares_Q2 = listlist2mat([[.424, .808],[.566, .115],[.707, -.577]])
least_squares_R2 = listlist2mat([[7.07, 1.7],[0,.346]])
least_squares_b2 = list2vec([10,13,15])

x_hat_2 = ...



## 8: (Problem 9.11.14) Small examples of least squares
#Find the vector minimizing (Ax-b)^2

#Please represent your solution as a list

your_answer_1 = ...
your_answer_2 = ...



## 9: (Problem 9.11.15) Linear regression example
#Find a and b for the y=ax+b line of best fit

a = ...
b = ...

