# version code 26c12c21abe8
# Please fill out this stencil and submit using the provided submission script.

from mat import Mat
from vec import Vec



## 1: (Problem 4.17.1) Computing matrix-vector products
# Please represent your solution vectors as lists.
vector_matrix_product_1 = [1, 0]
vector_matrix_product_2 = [0, 4.44]
vector_matrix_product_3 = [14, 20, 26]



## 2: (Problem 4.17.2) Matrix-vector multiplication to swap entries
# Represent your solution as a list of rowlists.
# For example, the 2x2 identity matrix would be [[1,0],[0,1]].

M_swap_two_vector = [[0,1],[1,0]]



## 3: (Problem 4.17.3) [z+x, y, x] Matrix-vector multiplication
three_by_three_matrix = [[1,0,1],[0,1,0],[1,0,0]] # Represent with a list of rowlists.



## 4: (Problem 4.17.4) [2x, 4y, 3z] matrix-vector multiplication
multiplied_matrix = [[2,0,0],[0,4,0],[0,0,3]] # Represent with a list of row lists.



## 5: (Problem 4.17.5) Matrix multiplication: dimension of matrices
# Please enter a boolean representing if the multiplication is valid.
# If it is not valid, please enter None for the dimensions.

part_1_valid = False # True or False
part_1_number_rows = None # Integer or None
part_1_number_cols = None # Integer or None

part_2_valid = False
part_2_number_rows = None
part_2_number_cols = None

part_3_valid = True
part_3_number_rows = 1
part_3_number_cols = 2

part_4_valid = True
part_4_number_rows = 2
part_4_number_cols = 1

part_5_valid = False
part_5_number_rows = None
part_5_number_cols = None

part_6_valid = True
part_6_number_rows = 1
part_6_number_cols = 1

part_7_valid = True
part_7_number_rows = 3
part_7_number_cols = 3



## 6: (Problem 4.17.6) Matrix-matrix multiplication practice with small matrices
# Please represent your answer as a list of row lists.
# Example: [[1,1],[2,2]]
small_mat_mult_1 = [[8,13],[8,14]]
small_mat_mult_2 = [[24, 11, 4], [1, 3, 0]]
small_mat_mult_3 = [[3, 13]]
small_mat_mult_4 = [[14]]
small_mat_mult_5 = [[14]]
small_mat_mult_6 = [[-2, 4], [1, 1], [1, -3]]



## 7: (Problem 4.17.7) Matrix-matrix multiplication practice with a permutation matrix
# Please represent your solution as a list of row lists.

part_1_AB = [[5, 2, 0, 1], [2, 1, -4, 6], [2, 3, 0, -4], [-2, 3, 4, 0]]
part_1_BA = [[1, -4, 6, 2], [3, 0, -4, 2], [3, 4, 0, -2], [2, 0, 1, 5]]

part_2_AB = [[5, 1, 0, 2], [2, 6, -4, 1], [2, -4, 0, 3], [-2, 0, 4, 3]]
part_2_BA = [[3, 4, 0, -2], [3, 0, -4, 2], [1, -4, 6, 2], [2, 0, 1, 5]]

part_3_AB = [[1, 0, 5, 2], [6, -4, 2, 1], [-4, 0, 2, 3], [0, 4, -2, 3]]
part_3_BA = [[3, 4, 0, -2], [1, -4, 6, 2], [2, 0, 1, 5], [3, 0, -4, 2]]



## 8: (Problem 4.17.9) Matrix-matrix multiplication practice with very sparse matrices
# Please represent your answer as a list of row lists.

your_answer_a_AB = [[0, 0, 2, 0], [0, 0, 5, 0], [0, 0, 4, 0], [0, 0, 6, 0]]
your_answer_a_BA = [[0, 0, 0, 0], [4, 4, 4, 0], [0, 0, 0, 0], [0, 0, 0, 0]]

your_answer_b_AB = [[0, 2, -1, 0], [0, 5, 3, 0], [0, 4, 0, 0], [0, 6, -5, 0]]
your_answer_b_BA = [[0, 0, 0, 0], [1, 5, -2, 3], [0, 0, 0, 0], [4, 4, 4, 0]]

your_answer_c_AB = [[6, 0, 0, 0], [6, 0, 0, 0], [8, 0, 0, 0], [5, 0, 0, 0]]
your_answer_c_BA = [[4, 2, 1, -1], [4, 2, 1, -1], [0, 0, 0, 0], [0, 0, 0, 0]]

your_answer_d_AB = [[0, 3, 0, 4], [0, 4, 0, 1], [0, 4, 0, 4], [0, -6, 0, -1]]
your_answer_d_BA = [[0, 11, 0, -2], [0, 0, 0, 0], [0, 0, 0, 0], [1, 5, -2, 3]]

your_answer_e_AB = [[0, 3, 0, 8], [0, -9, 0, 2], [0, 0, 0, 8], [0, 15, 0, -2]]
your_answer_e_BA = [[-2, 12, 4, -10], [0, 0, 0, 0], [0, 0, 0, 0], [-3, -15, 6, -9]]

your_answer_f_AB = [[-4, 4, 2, -3], [-1, 10, -4, 9], [-4, 8, 8, 0], [1, 12, 4, -15]]
your_answer_f_BA = [[-4, -2, -1, 1], [2, 10, -4, 6], [8, 8, 8, 0], [-3, 18, 6, -15]]



## 9: (Problem 4.17.11) Column-vector and row-vector matrix multiplication
column_row_vector_multiplication1 = Vec({0, 1}, {0: 13, 1: 20})

column_row_vector_multiplication2 = Vec({0, 1, 2}, {0: 24, 1: 11, 2: 4})

column_row_vector_multiplication3 = Vec({0, 1, 2, 3}, {0: 4, 1: 8, 2: 11, 3: 3})

column_row_vector_multiplication4 = Vec({0,1}, {0: 30, 1: 16})

column_row_vector_multiplication5 = Vec({0, 1, 2}, {0: -3, 1: 1, 2: 9})



## 10: (Problem 4.17.13) Linear-combinations matrix-vector multiply
# Remember M*v and v*M are defined
# You are also allowed to use the matutil module
def lin_comb_mat_vec_mult(M, v):
    '''
    Input:
      -M: a matrix
      -v: a vector
    Output:
      -the linear combination multiplication of M*v
    Examples:
    >>>M=Mat(({0,1},{0,1}),{(0,0):5})
    >>>v=Vec({0,1},{1:2})
    >>>lin_comb_mat_vec_mult(M,v)
    Vec({0,1},{0:0,1:0})
    >>>M1=Mat(({0,1},{0,1}),{(0,0):2,(0,1):3})
    >>>v1=Vec({0,1},{0:4,1:3})
    >>>lin_comb_mat_vec_mult(M1,v1)
    Vec({0,1},{0:17,1:0})
    '''
    assert(M.D[1] == v.D)
    ''''
    from matutil import mat2coldict
    from matutil import coldict2mat

    # Convert the matrix to a col dict
    coldict = mat2coldict(M)
    # Sum the linear combinations of the cols
    return sum([v[key] * coldict[key] for key in v.D])
    '''
    from matutil import mat2coldict

    mAsCol = mat2coldict(M)

    return sum( [ v[k] * mAsCol[k] for k in v.D ] )




## 11: (Problem 4.17.14) Linear-combinations vector-matrix multiply
def lin_comb_vec_mat_mult(v, M):
    '''
    Input:
      -v: a vector
      -M: a matrix
    Output:
      -the linear combination multiplication of v*M
    Examples:
      >>>M=Mat(({0,1},{0,1}),{(0,0):5})
      >>>v=Vec({0,1},{1:2})
      >>>lin_comb_vec_mat_mult(v,M)
      Vec({0, 1},{0: 0, 1: 0})
      >>>M1=Mat(({0,1},{0,1}),{(0,0):2,(0,1):3})
      >>>v1=Vec({0,1},{0:4,1:3})
      >>>lin_comb_mat_vec_mult(M1,v1)
      Vec({0, 1},{0: 8, 1: 12})
    '''
    assert(v.D == M.D[0])
    
    from matutil import mat2rowdict
    from matutil import rowdict2mat

    # Convert the matrix to a row dict
    rowdict = mat2rowdict(M)
    # Sum the linear combinations of the rows
    return sum([ v[key] * rowdict[key] for key in v.D])



## 12: (Problem 4.17.15) dot-product matrix-vector multiply
# Remember M*v and v*M are defined
# You are also allowed to use the matutil module
def dot_product_mat_vec_mult(M, v):
    assert(M.D[1] == v.D)
    from matutil import mat2rowdict

    # Convert the matrix to a row dict
    rowdict = mat2rowdict(M)

    '''
    # Turned this in to a single line
    # Take the dot product of the vector and each row
    outdict = {}
    for row in rowdict:
      outdict[row] = sum([rowdict[row][col] * v[col] for col in v.D]) #Vec(v.D, rowdict[row] * v)

    return Vec(v.D, outdict)
    '''
    out_dict = {}
    for row_no, row in rowdict.items():
        out_dict[row_no] = row*v

    return Vec(M.D[0], out_dict )



## 13: (Problem 4.17.16) Dot-product vector-matrix multiply
# Remember M*v and v*M are defined
# You are also allowed to use the matutil module
def dot_product_vec_mat_mult(v, M):
    assert(v.D == M.D[0])
    from matutil import mat2coldict
    coldict = mat2coldict(M)

    out_dict = {}
    for col_no, col in coldict.items():
        out_dict[col_no] = v*col
    return Vec(M.D[1], out_dict)


from matutil import *

## 14: (Problem 4.17.17) Matrix-vector matrix-matrix multiply
# You are also allowed to use the matutil module
def Mv_mat_mat_mult(A, B):
    assert A.D[1] == B.D[0]
    b_col = mat2coldict(B)

    out_dict = {}
    for col_no, col in b_col.items():
            out_dict[col_no] = A*col
    
    return coldict2mat(out_dict)





## 15: (Problem 4.17.18) Vector-matrix matrix-matrix multiply
def vM_mat_mat_mult(A, B):
    assert A.D[1] == B.D[0]
    a_row = mat2rowdict(A)

    out_dict = {}
    for row_no, row in a_row.items():
        out_dict[row_no] = row * B

    return rowdict2mat(out_dict)



## 16: (Problem 4.17.19) Comparing countries using dot-product
# Provide a set consisting of two strings
most_opposed_pair_of_countries = {..., ...}

# Provide a ten-element list of two-element sets of strings
most_opposed_10_pairs_of_countries = [{..., ...}, ..., {..., ...}]

# Provide a set consisting of two strings
most_agreeing_pair_of_countries = {..., ...}



## 17: (Problem 4.17.20) Dictlist Helper
def dictlist_helper(dlist, k):
    '''
    Input: a list dlist of dictionaries which all have the same keys, and a key k
    Output: the list whose ith element is the value corresponding to the key k 
            in the ith dictionary of dlist
    Example:
    >>> dictlist_helper([{'apple':'Apfel','bread':'Brot'},{'apple':'manzana', 'bread':'pan'},{'apple':'pomme','bread':'pain'}], 'apple')
    ['Apfel', 'manzana', 'pomme']
    '''
    pass




## 18: (Problem 4.17.21) Solving 2x2 linear systems and finding matrix inverse
solving_systems_x1 = -1/5
solving_systems_x2 = 2/5
solving_systems_y1 = 4/5
solving_systems_y2 = -3/5
solving_systems_m = Mat(({0, 1}, {0, 1}), {  (0,0):-.2, (1,0):.4, (0,1):.8, (1,1):-.6 })
solving_systems_a = Mat(({0, 1}, {0, 1}), {  (0,0):3,   (1,0):2,  (0,1):4,  (1,1):1   })
solving_systems_a_times_m = Mat(({0, 1}, {0, 1}), { (0,0):1, (1,0):0, (0,1):0, (1,1):1})
solving_systems_m_times_a = Mat(({0, 1}, {0, 1}), { (0,0):1, (1,0):0, (0,1):0, (1,1):1})



## 19: (Problem 4.17.22) Matrix inverse criterion
# Please write your solutions as booleans (True or False)

are_inverses1 = True
are_inverses2 = True
are_inverses3 = False
are_inverses4 = False

