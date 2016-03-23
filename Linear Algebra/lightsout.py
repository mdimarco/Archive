# version code 0f8f12adb6fe+
# Please fill out this stencil and submit using the provided submission script.





## 1: () Buttons
from vec import Vec
from mat import Mat
from solver import solve
from GF2 import one

def D(n): return {(i,j) for i in range(n) for j in range(n)}

def button_vectors(n):
  return {(i,j):Vec(D(n),dict([((x,j),one) for x in range(max(i-1,0), min(i+2,n))]
                           +[((i,y),one) for y in range(max(j-1,0), min(j+2,n))]))
                           for (i,j) in D(n)}

b1=Vec(D(9),{(7, 8):one,(7, 7):one,(6, 2):one,(3, 7):one,(2, 5):one,(8, 5):one,(1, 2):one,(7, 2):one,(6, 3):one,(0, 4):one,(2, 2):one,(5, 0):one,(6, 4):one,(0, 0):one,(5, 4):one,(1, 4):one,(8, 7):one,(0, 8):one,(6, 5):one,(2, 7):one,(8, 3):one,(7, 0):one,(4, 6):one,(6, 8):one,(0, 6):one,(1, 8):one,(7, 4):one,(2, 4):one})

#Solution given by solver.
A = Mat((D(9),D(9)),button_vectors(9))
x1 = solve(A,b1)

#residual
r1 = ...

#Is x1 really a solution? True or False
is_good1 = ...

b2=Vec(D(9), {(3,4):one})
#Solution given by solver.

#Solution given by solver
x2 = ...

#residual
r2 = ...

#Is it really a solution? True or False
is_good2 = ...


