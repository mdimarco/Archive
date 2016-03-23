

points = []
X = [ [] ]
y = []
from random import *
for x in range(-100,100,1):
	X[0].append(x+1)
	y.append(x)

from plotting import plot
from matutil import *
from vecutil import *
from solver import solve

X = listlist2mat(X)
y = list2vec(y)

m = solve(X,y)
for point in y.D:
	points.append( (point,m[0]*point) )
print(m)
plot(points)
