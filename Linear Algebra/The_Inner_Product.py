# version code d755df727932+
# Please fill out this stencil and submit using the provided submission script.





## 1: (Problem 8.6.1) Norm
norm1 = 3
norm2 = 4
norm3 = 3

def sig(a,b):
	x = sum( [m*n for m,n in zip(a,b)] )
	y = sum( [m*n for m,n in zip(a,a)] )
	return x/y if y > 0 else 0

def scale(alph, alist):
	return [alph*x for x in alist]

## 2: (Problem 8.6.2) Closest Vector
# Write each vector as a list
a = [1,2]
b = [2,3]
closest_vector_1 = scale(sig(a,b), a)

a = [0,1,0]
b = [1.414, 1, 1.732]
closest_vector_2 = scale(sig(a,b), a)

a = [-3, -2, -1, 4]
b = [7, 2,5,0]
closest_vector_3 = scale(sig(a,b),a)

print(closest_vector_1)
print(closest_vector_2)
print(closest_vector_3)


## 3: (Problem 8.6.3) Projection Orthogonal to and onto Vectors
# Write each vector as a list
# round up to 6 decimal points if necessary
a = [3,0]
b = [2,1]

def list_sub(a,b):
	return [x-y for x,y in zip(a,b)]

project_onto_1 = scale(sig(a,b),a)
projection_orthogonal_1 = list_sub(b,project_onto_1)

a = [1,2,-1]
b = [1,1,4]
project_onto_2 = scale(sig(a,b),a)
projection_orthogonal_2 = list_sub(b,project_onto_2)

a = [3,3,12]
b = [1,1,4]

project_onto_3 = scale(sig(a,b),a)
projection_orthogonal_3 = list_sub(b,project_onto_3)

