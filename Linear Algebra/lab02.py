import math


from random import randint

print(randint())
print(randint())
print(randint())


def movie_review(name):
	suggestions = ["See it!", "Awesome!", "Worse than Transformers 3!"]
	return  randint() % len(suggestions) 