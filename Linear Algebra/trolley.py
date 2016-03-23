import random
from math import sqrt
from vec import Vec

def norm(v): return sqrt(v*v)
    
def normalized(v): return v/norm(v)

def first_right_singular_vector(A):
    iter = 15
    v = Vec(A.D[1], {k:1+random.gauss(0,1) for k in A.D[1]})
    for i in range(iter): v = normalized((A*v)*A)
    return v

Point_list1 = [(1.55, 0.9) , (-0.87, -2.42) , (0.61, -1.84) , (0.72, -0.1) , (0.16, 0.48) , (0.46, 0.81) , (-0.71, -1.69) , (1.26, 1.11),
(-2.14, -5.34) , (-1.09, -4.2) , (-0.61, 0.14) , (-0.33, -0.59) , (-0.64, -0.76) , (1.73, -0.67) , (2.38, 1.38) , (-0.34, -0.97),
(-2.17, -2.51) , (0.42, -0.93) , (2.43, -0.43) , (1.9, 1.22) , (2.24, 1.98) , (-1.83, -1.6) , (-0.17, 1.22) , (0.64, -0.61),
(-2.07, -3.11) , (0.59, 1.77) , (1.96, -0.38) , (-0.05, -2.64) , (0.49, 1.6) , (-0.23, 2.43) , (1.62, 1.06) , (2.06, -0.03),
(1.6, 0.41) , (1.38, 2.29) , (-0.96, -0.8) , (-0.4, -2.42) , (2.97, 1.56) , (-0.03, 1.46) , (-0.1, 0.94) , (1.29, -2.39)]

Point_list2 = [(1.38, 0.44), (-0.59, -0.26), (-1.24, 0.07), (-1.42, 1.99), (1.2, 0.01), (-0.88, -2.63), (-1.35, -0.83), (-1.09, 2.34), (-0.22, 1.21), (0.77, -0.32), (-0.15, 1.88), (-0.86, -0.38), (0.91, -2.46), (0.71, 1.06), (-1.98, -0.26), (-0.71, 1.71), (0.0, 0.15), (-0.94, 1.25), (0.55, 0.85), (-1.06, -0.58), (-1.06, -1.55), (-0.49, 0.65), (-0.37, 1.2), (-0.78, 1.02), (0.5, 0.48), (-0.38, -0.28), (-2.29, 0.2), (-1.27, 1.14), (-0.47, 1.68), (-0.65, 0.15), (2.24, -0.33), (0.6, -0.95), (-0.2, 1.85), (-0.53, -0.7), (0.23, -1.68), (0.58, 0.05), (0.81, 0.38), (-1.87, -0.1), (0.08, 0.63), (0.63, 0.05)]


from matutil import listlist2mat
from vecutil import list2vec
from solver import solve

#BEGIN Y=MX TEST
x = []
y = []

for point in Point_list1:
	x.append( [point[0]] )
	y.append( point[1] )
x = listlist2mat(x)
y = list2vec(y)

m = solve(x,y)
ymx_plot = []
for xy in range(-200,200, 5):
	ymx_plot.append( (xy/100, m[0]*xy/100 ) )
print("Y = mx + 0: "+str(m[0]))
#END Y=MX


'''
#Being First Singular Value
A = []
for point in Point_list1:
	A.append( [point[0], point[1]])
A = listlist2mat(A)
v1 = first_right_singular_vector(A)

print("v1")
print(v1)
print()

sing_plot = []
for xy in range(-200,200, 5):
	sing_plot.append( (xy*v1[0]/100, v1[1]*xy/100 ) )

#End First Singular Value

'''

#BEGIN LINEAR REGRESSION
x = [  ]
y = [ ]
for point in Point_list2:
	new_point = []
	new_point.append(point[0])
	new_point.append(1)
	x.append( new_point )
	y.append(point[1])
X = listlist2mat(x)
y = list2vec(y)

m = solve(X,y)
print("Y = mx+b: "+str(m[0]))
xy_points = []

for xy in range(-300,300,5):
	xy_scaled = xy/100
	xy_points.append( (xy_scaled+m[1],m[0]*xy_scaled+m[1]) )
#END LINEAR REGRESSION

'''

#Affine space

x = 0
y = 0
for point in Point_list2:
	x+=point[0]
	y+=point[1]

x /= len(Point_list2)
y /= len(Point_list2)

centroid = x,y
A_Translated = []
for point in Point_list2:
	A_Translated.append( (point[0] - centroid[0], point[1] - centroid[1]) )

v1 = first_right_singular_vector( listlist2mat(A_Translated) )


affine_plot = []
for xy in range(-200,200, 5):
	affine_plot.append( (xy*v1[0]/100+x, v1[1]*xy/100+y ) )
'''

from plotting import plot




