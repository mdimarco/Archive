import pdb

class Constituent():
	""" Represents a constituent that can be placed in a cell of a chart """
	def __init__(self, label, back_pointer1, back_pointer2, prob):
		self.label = label
		self.bp1 = back_pointer1
		self.bp2 = back_pointer2
		self.prob = prob
	def fields(self):
		return (self.label, self.bp1, self.bp2, self.prob)

class Chart():
	def __init__(self, sentence, grammar):
		self.sentence = sentence
		self.grammar = grammar
		self.cells = {}
		#Start from bottom row of chart and work up
		for l in range(1, len(sentence)+1):
			#print("Filling row"+str(l))
			for s in range(0, len(sentence)-l+1):
				self.__fill(s, s+l)

	def __fill(self, i, k):
		self.cells[(i,k)] = {}
		#Lowest level of chart
		if k-i == 1:
			word = self.sentence[i]
			self.cells[(i,k)][word] =  Constituent(word, None, None, 1) 
		else:
			self.__fill_binary(i,k)
		self.__fill_unary(i,k)
		
	def __fill_binary(self, i, k):
		for j in range( (i+1), k ):
			#print("Filling binary", i,j,k)
			for lhs,left_child in self.cells[(i,j)].items():
				if left_child.label not in self.grammar.rules_rhs1_major:
					#print("(Binary) Cell's label not yet seen as rhs'", rhs1.fields())
					continue
				#Only look at rules that have left child as their rhs1
				for rule in filter(lambda rule: rule.rhs2 in self.cells[j,k], self.grammar.rules_rhs1_major[left_child.label]):
					#Only look at right children who's lhs is the rules rhs2
					right_child = self.cells[j,k][rule.rhs2]
					prob = rule.prob * left_child.prob * right_child.prob
					if self.__greatest_prob(rule.lhs, prob, i, k):
						self.cells[(i,k)][rule.lhs] = Constituent(rule.lhs, left_child, right_child, prob) 

	def __greatest_prob(self, rule_lhs, prob, i, k):
		return (rule_lhs not in self.cells[(i,k)]) or (self.cells[(i,k)][rule_lhs].prob < prob)


	def get_top(self):
		""" Retrieves the TOP constituent with the highest probability"""
		return self.cells[(0,len(self.sentence))]["TOP"]

	def print_cell(self, i, k):
		print("")
		for const in sorted(self.cells[(i,k)].values(), key=lambda x:x.label):
			#print(const.fields())
			A = const.label
			if const.bp1:
				B = const.bp1.label
			else:
				B = ""
			if const.bp2:
				C = const.bp2.label
			else:
				C = ""
			print(A,B,C,const.prob)

	def __fill_unary(self, i, k):
		changed = True
		while changed:
			changed = False
			#For each constituent in the cell
			for lhs, constituent in self.cells[(i,k)].items():
				#For all unary rules, with the constituents lhs as their rhs1
				if lhs not in self.grammar.rules_rhs1_major:
					continue
				#For all unary rules with lhs as the rhs1
				for rule in filter(lambda rule: rule.rhs2 == '', self.grammar.rules_rhs1_major[lhs]):
					prob = rule.prob * constituent.prob 
					if self.__greatest_prob(rule.lhs, prob, i, k):
						self.cells[(i,k)][rule.lhs] = Constituent(rule.lhs, constituent, "", prob)
						changed = True



