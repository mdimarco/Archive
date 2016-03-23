
from mat import *
from vec import *

labels = {"S", "R", "F", "W"}
mat_dict = { ("S","S"):0.5, ("R","S"):0.2, ("F","S"):0,   ("W","S"):0.3, 
	     ("S","R"):0.2, ("R","R"):0.6, ("F","R"):0.2, ("W","R"):0, 
	     ("S","F"):0,   ("R","F"):0,   ("F","F"):0.4, ("W","F"):0.6,
	     ("S","W"):0.1, ("R","W"):0,   ("F","W"):0.8, ("W","W"):0.1
	   }

trans_mat = Mat( (labels,labels), mat_dict )
print("Transition Matrix (Part A)")
print(trans_mat)

print("Wind vector (Part B)")
wind_vec = Vec(labels, {"W":1} )

print(trans_mat * wind_vec)
	
print("One step past the uniform distribution (Part C)")
v = Vec(labels, {"S":0.25, "R":0.25, "F":0.25,"W":0.25})
print(trans_mat*v)

A = trans_mat
for x in range(400):
	v = A*v	
print("400 Steps past the uniform distribution (Part D)")
print(v)

print("As the matrix A multiplied by the above vector will equate to that vector, we can say that the vector above is an eigenvector with a corresponding eigenvalue of 1")
