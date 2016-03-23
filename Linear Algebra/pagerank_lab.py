# version code f21e7db71a85+
# Please fill out this stencil and submit using the provided submission script.

from vec import Vec
from mat import Mat
from math import sqrt
import pagerank





## 1: Find Number of Links
def find_num_links(L):
    '''
    Input:
        - L: a square matrix representing link structure
    Output:
        - A vector mapping each column label of L to
          the number of non-zero entries in the corresponding
          column of L
    Example:
        >>> from matutil import listlist2mat
        >>> find_num_links(listlist2mat([[1,1,1],[1,1,0],[1,0,0]]))
        Vec({0, 1, 2},{0: 3, 1: 2, 2: 1})
    '''
    ones = Vec(L.D[1],{lab:1 for lab in L.D[1]})
    return ones*L


## 2: Make Markov
def make_Markov(L):
    '''
    Input:
        - L: a square matrix representing link structure
    Output:
        - None: changes L so that it plays the role of A_1
    Example:
        >>> from matutil import listlist2mat
        >>> M = listlist2mat([[1,1,1],[1,0,0],[1,0,1]])
        >>> make_Markov(M)
        >>> M
        Mat(({0, 1, 2}, {0, 1, 2}), {(0, 1): 1.0, (2, 0): 0.3333333333333333, (0, 0): 0.3333333333333333, (2, 2): 0.5, (1, 0): 0.3333333333333333, (0, 2): 0.5})
    '''
    links = find_num_links(L)
    for col in L.D[1]:
	    for row in L.D[0]:
		    if links[col] != 0:
		    	L[row,col] /= links[col]




## 3: Power Method
def power_method(A1, i):
    '''
    Input:
        - A1: a matrix
        - i: number of iterations to perform
    Output:
        - An approximation to the stationary distribution
    Example:
        >>> from matutil import listlist2mat
        >>> power_method(listlist2mat([[0.6,0.5],[0.4,0.5]]), 10)
        Vec({0, 1},{0: 0.5464480874307794, 1: 0.45355191256922034})
    '''
    row_labs = A1.D[0]
    vec_dict = {}
    #for lab in row_labs:
    #    vec_dict[lab] = 1/len(row_labs) 
    vec_dict[1] = 1
    
    #print("initial vector") 
    vecy = Vec(row_labs, vec_dict)
    #print(vecy)

    for x in range(i):
	    vecy  =   A1 *  vecy
   
    #print("stationary vector")
    #print(vecy)
    #vec_len_inv = 1/(sqrt( (vecy*At)*(vecy*At)) )
    #vecy = vec_len_inv * (vecy * At)
    
    return vecy

#from matutil import listlist2mat
#print(power_method(listlist2mat([[0.7,0.3],[0.3,0.7]]), 10))
#Vec({0, 1},{0: 0.5464480874307794, 1: 0.45355191256922034})
    


## 4: Jordan
number_of_docs_with_jordan = ...



## 5: Wikigoogle
def wikigoogle(w, k, p):
    '''
    Input:
        - w: a word
        - k: number of results
        - p: pagerank eigenvector
    Output:
        - the list of the names of the kth heighest-pagerank Wikipedia
          articles containing the word w
    '''
    pass



## 6: Using Power Method
p = ...
results_for_jordan = ... # give 5 of them as a list
results_for_obama  = ...
results_for_tiger  = ...
results_for_matrix = ...




## 7: Power Method Biased
def power_method_biased(A1, i, r):
    '''
    Input:
        - A1: a matrix, as in power_method
        - i: number of iterations
        - r: bias label
    Output:
        - Approximate eigenvector of .55A_1 + 0.15A_2 + 0.3A_r
    '''
    pass

p_sport = ...
sporty_results_for_jordan = ...
sporty_results_for_obama  = ...
sporty_results_for_tiger  = ...
sporty_results_for_matrix = ...

