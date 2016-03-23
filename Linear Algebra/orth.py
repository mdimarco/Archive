from vec import *
from vecutil import *


def dot(l1, l2):
	return sum( [x1*x2 for x1,x2 in zip(l1,l2) ] )

def scal(scalar, l1):
	return [scalar*x for x in l1]

def sub(l1, l2):
	return [x1-x2 for x1,x2 in zip(l1,l2)]


def project_along(b, a):
	sig = dot(b,a)/dot(a,a)
	return scal(sig, a)



def project_orth(b, vlist):
	for v in vlist:
		b = sub(b, project_along(b, v) )
		print(b)
	return b


def orthogonalize( vlist ):
	vstarlist = []
	for v in vlist:
		vstarlist.append(project_orth(v,vstarlist))
		print(vstarlist)
	return vstarlist

orthogonalize([[1,2,3],[-1,1,1],[7,5,4]])

