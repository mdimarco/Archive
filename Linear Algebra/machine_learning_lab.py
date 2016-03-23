# version code c354cada1d21+
# Please fill out this stencil and submit using the provided submission script.

from mat import *
from vec import *
from cancer_data import *



## Task 1 ##
def signum(u):
    '''
    Input:
        - u: Vec
    Output:
        - v: Vec such that:
            if u[d] >= 0, then v[d] =  1
            if u[d] <  0, then v[d] = -1
    Example:
        >>> signum(Vec({1,2,3},{1:2, 2:-1})) == Vec({1,2,3},{1:1,2:-1,3:1})
        True
    '''


    v_dict = {}
    for d in u.D:
        if u[d] >= 0:
            v_dict[d] = 1
        else:
            v_dict[d] = -1
    return Vec(u.D, v_dict)

from matutil import *
from vecutil import *

## Task 2 ##
def fraction_wrong(A, b, w):
    '''
    Input:
        - A: a Mat with rows as feature vectors
        - b: a Vec of actual diagnoses
        - w: hypothesis Vec
    Output:
        - Fraction (as a decimal in [0,1]) of vectors incorrectly
          classified by w 
    '''
    A_rows = mat2rowdict(A)

    Aw = A*w
    nAw = signum(Aw)


    num_rows = len(b.D)
    pos_rows = [1 for x in b.D if nAw[x] == b[x] ]
    neg_rows = num_rows - len(pos_rows)

    return neg_rows/(num_rows*1.0)



## Task 3 ##
def loss(A, b, w):
    '''
    Input:
        - A: feature Mat
        - b: diagnoses Vec
        - w: hypothesis Vec
    Output:
        - Value of loss function at w for training data
    '''
    A = mat2rowdict(A)
    return sum([ (A[ind]*w - b[ind])**2 for ind in b.D ])


## Task 4 ##
def find_grad(A, b, w):
    '''
    Input:
        - A: feature Mat
        - b: diagnoses Vec
        - w: hypothesis Vec
    Output:
        - Value of the gradient function at w
    '''
    A = mat2rowdict(A)
    return sum( [ 2*(A[ind]*w - b[ind])*A[ind] for ind in b.D ] )

## Task 5 ##
def gradient_descent_step(A, b, w, sigma):
    '''
    Input:
        - A: feature Mat
        - b: diagnoses Vec
        - w: hypothesis Vec
        - sigma: step size
    Output:
        - The vector w' resulting from 1 iteration of gradient descent
          starting from w and moving sigma.
    '''
    return w-sigma*find_grad(A,b,w)

from random import randint
(A,b) = read_training_data("train.data")
sigma = 1e-9
w = Vec(A.D[1], {key:randint(-10,10) for key in A.D[1]})


soon = []
for x in range(10000):


    '''if len(soon) >= 500 and ( sum(soon)/500 > .5 or sum(soon)/500 -soon[0] < .01 ):
        print("restart")
        w = Vec(A.D[1], {key:randint(-10,10) for key in A.D[1]})
        soon = []'''


    if x%30 == 0:
        print( fraction_wrong(A,b,w) )
    w = gradient_descent_step(A,b,w,sigma)

    soon.append( fraction_wrong(A,b,w) )

print(w)
    


