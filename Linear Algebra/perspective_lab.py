# version code 4e196c78a5b6+
# Please fill out this stencil and submit using the provided submission script.

from vec import Vec
from mat import Mat
from matutil import *
from solver import solve



## 1: (Task 5.12.1) Move To Board
def move2board(v): 
    '''
    Input:
        - v: a Vec with domain {'y1','y2','y3'}, the coordinate representation in whiteboard coordinates of a point q
    Output:
        - A {'y1','y2','y3'}-Vec, the coordinate representation
          in whiteboard coordinates of the point p such that the line through the 
          origin and q intersects the whiteboard plane at p.
    '''
    y3 = v['y3']

    return Vec({'y1','y2','y3'}, { 'y1':(v['y1']/y3), 'y2':(v['y2']/y3), 'y3':1 })



## 2: (Task 5.12.2) Make Equations
# D should be assigned the Cartesian product of R and C
D = { ('y'+str(i),'x'+str(j)) for i in range(1,4) for j in range(1,4) }

def make_equations(x1, x2, w1, w2): 
    '''
    Input:
        - x1, x2: pixel coordinates of a point q in the image plane
        - w1, w2: w1=y1/y3 and w=y2/y3 where y1,y2,y3 are the whiteboard coordinates of q.
    Output:
        - List [u,v] of D-vectors that define linear equations u*h = 0 and v*h = 0

    For example, suppose we have an image of the whiteboard in which
       the top-left whiteboard corner appears at pixel coordinates 9, 18
       the bottom-left whiteboard corner appears at pixel coordinates 8,25
       the top-right whiteboard corner appears at pixel coordinates 20,20
       the bottom-right whiteboard corner appears at pixel coordinates 18,23

    Let q be the point in the image plane with pixel coordinates x=8,y=25, i.e. camera coordinates (8,25,1).
    Let y1,y2,y3 be the whiteboard coordinates of the same point.  The line that goes through the
    origin and p intersects the whiteboard at a point p.  That point p is the bottom-left corner of
    the whiteboard, so its whiteboard coordinates are 1,0,1.  Therefore (y1/y3,y2/y3,y3/y3) = (1,0,1).
    We define w1=y1/y3 and w2=y2/y3, so w1 = 1 and w2 = 0.  Given this input-output pair, let's find
    two linear equations u*h=0 and v*h=0 constraining the unknown vector h whose entries are the entries
    of the matrix H. 

>>> for v in make_equations(8,25,1,0): print(v)
... 

 ('y3', 'x3') ('y2', 'x2') ('y1', 'x2') ('y2', 'x1') ('y1', 'x3') ('y3', 'x2') ('y2', 'x3') ('y1', 'x1') ('y3', 'x1')
---------------------------------------------------------------------------------------------------------------------
            1            0          -25            0           -1           25            0           -8            8

 ('y3', 'x3') ('y2', 'x2') ('y1', 'x2') ('y2', 'x1') ('y1', 'x3') ('y3', 'x2') ('y2', 'x3') ('y1', 'x1') ('y3', 'x1')
---------------------------------------------------------------------------------------------------------------------
            0          -25            0           -8            0            0           -1            0            0

    Note that the negations of these vectors form an equally valid solution.

    Similarly, consider the point q in the image plane with pixel coordinates 18, 23.  Let y1,y2,y3 be the whiteboard
    coordinates of p.  The corresponding point p in the whiteboard plane is the bottom-right corner, and the whiteboard
    coordinates of p are 1,1,1, so (y1/y3,y2/y3,y3/y3)=(1,1,1).  We define w1=y1/y3 and w2=y2/y3, so w1=1 and w2=1.
    We obtain the vectors u and v defining equations u*h=0 and v*h=0 as follows:

>>> for v in make_equations(18,23,1,1): print(v)
... 

 ('y3', 'x3') ('y2', 'x2') ('y1', 'x2') ('y2', 'x1') ('y1', 'x3') ('y3', 'x2') ('y2', 'x3') ('y1', 'x1') ('y3', 'x1')
---------------------------------------------------------------------------------------------------------------------
            1            0          -23            0           -1           23            0          -18           18

 ('y3', 'x3') ('y2', 'x2') ('y1', 'x2') ('y2', 'x1') ('y1', 'x3') ('y3', 'x2') ('y2', 'x3') ('y1', 'x1') ('y3', 'x1')
---------------------------------------------------------------------------------------------------------------------
            1          -23            0          -18            0           23           -1            0           18

    Again, the negations of these vectors form an equally valid solution.
    '''
    u = Vec(D, {('y3','x1'):(w1*x1), ('y3','x2'):(w1*x2), ('y3','x3'):w1, ('y1','x1'):-x1, ('y1','x2'):-x2, ('y1','x3'):-1} ) 
    v = Vec(D, {('y3','x1'):(w2*x1), ('y3','x2'):(w2*x2), ('y3','x3'):w2, ('y2','x1'):-x1, ('y2','x2'):-x2, ('y2','x3'):-1} ) 
    return [u, v]



## 3: Right-hand side
w = Vec(D, {('y1','x1'):1})

def make_nine_equations(corners):
    '''
    input: a list of four tuples:
           [(i0,j0),(i1,j1),(i2,j2),(i3,j3)]
           where i0,j0 are the pixel coordinates of the top-left corner,
                 i1,j1 are the pixel coordinates of the bottom-left corner,
                 i2,j2 are the pixel coordinates of the top-right corner,
                 i3,j3 are the pixel coordinates of the bottom-right corner,
    output: the list of Vecs u0, u1, ..., u8 that are to be the rows of the matrix.
    Vecs u0,u1 come from applying make_equations to the top-left corner,
    Vecs u2,u3 come from applying make_equations to the bottom-left corner,
    Vecs u4,u5 come from applying make_equations to the top-right corner,
    Vecs u6,u7 come from applying make_equations to the bottom-right corner,
    Vec u8 is the vector w.
    ''' 
    my_list = [ ]
    my_list.extend( make_equations(corners[0][0], corners[0][1], 0,0) )
    my_list.extend( make_equations(corners[1][0], corners[1][1], 0,1) )
    my_list.extend( make_equations(corners[2][0], corners[2][1], 1,0) )
    my_list.extend( make_equations(corners[3][0], corners[3][1], 1,1) )
    my_list.append( w )
    return my_list



## 4: (Task 5.12.4) Rows of constraint matrix
# Apply make_nine_equations to the list of tuples specifying the pixel coordinates of the
# whiteboard corners in the image.  Assign the resulting list of nine vectors to veclist:
veclist = make_nine_equations( [(358,36), (329,597), (592, 157), (580,483) ])

# Build a Mat whose rows are the Vecs in veclist
L = rowdict2mat(veclist)


## 5: Build linear system
# Now construct the Vec b that serves as the right-hand side for the matrix-vector equation L*hvec=b
# This is the {0, ..., 8}-Vec whose entries are all zero except for a 1 in position 8
b = Vec({x for x in range(9)}, {8: 1})



## 6: Solve linear system
# Now solve the matrix-vector equation to get a Vec hvec, and turn it into a matrix H.
hvec = solve(L, b)

H = Mat( ({'y1', 'y2', 'y3'}, {'x1','x2','x3'}) , hvec.f)



## 7: (Task 5.12.7) Y Board Comprehension
def mat_move2board(Y):
    '''
    Input:
        - Y: a Mat each column of which is a {'y1', 'y2', 'y3'}-Vec
          giving the whiteboard coordinates of a point q.
    Output:
        - a Mat each column of which is the corresponding point in the
          whiteboard plane (the point of intersection with the whiteboard plane 
          of the line through the origin and q).

    Example:
    >>> Y_in = Mat(({'y1', 'y2', 'y3'}, {0,1,2,3}),
         {('y1',0):2, ('y2',0):4, ('y3',0):8,
          ('y1',1):10, ('y2',1):5, ('y3',1):5,
          ('y1',2):4, ('y2',2):25, ('y3',2):2,
          ('y1',3):5, ('y2',3):10, ('y3',3):4})
    >>> print(Y_in)
    
            0  1  2  3
          ------------
     y1  |  2 10  4  5
     y2  |  4  5 25 10
     y3  |  8  5  2  4
    
    >>> print(mat_move2board(Y_in))
    
               0 1    2    3
          ------------------
     y1  |  0.25 2    2 1.25
     y2  |   0.5 1 12.5  2.5
     y3  |     1 1    1    1
    '''
    Y1 = mat2coldict(Y)
    Y2 = { i:move2board( j ) for i,j in Y1.items()}
    Y_Out = coldict2mat(Y2)
    return Y_Out

Y_in = Mat(({'y1', 'y2', 'y3'}, {0,1,2,3}),
         {('y1',0):2, ('y2',0):4, ('y3',0):8,
          ('y1',1):10, ('y2',1):5, ('y3',1):5,
          ('y1',2):4, ('y2',2):25, ('y3',2):2,
          ('y1',3):5, ('y2',3):10, ('y3',3):4})

mat_move2board(Y_in)
