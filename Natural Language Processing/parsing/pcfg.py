
from collections import Counter
class Rule():
	def __init__(self, lhs, rhs1, rhs2, prob):
		self.lhs = lhs
		self.rhs1 = rhs1
		self.rhs2 = rhs2
		self.prob = prob


class PCFG():
	def __init__(self, rules_file):
		self.rules_counts, self.lhs_counts = self.__count_rules(rules_file)
		self.rules_rhs1_major = self.__format_rules_by_rhs1()

	def __count_rules(self, rules_file):
		""" Count rules from wsj tree bank, keeping track of specific rule counts and counts for the lhs (to be used for probability calculations)  """
		rules_counts = {}
		lhs_counts = Counter()
		for rule in open(rules_file):
			#Split rule string into list of rule elements
			rule = rule.split()
			A = rule[1]
			count = int(rule[0])

			#TODO make sure this doesn't hurt accuracy
			if count == 0 and A != 'TOP':
				continue

			#Initialize left hand side
			if A not in rules_counts:
				rules_counts[A] = Counter()
			#Add to lhs counts
			lhs_counts[A] += count

			B = rule[3]
			#If unary rule
			if len(rule) == 4:
				#Increment A --> B, by count
				rules_counts[A][(B,"")] += count
			else:
				C = rule[4]
				#Increment A --> B C, by count
				rules_counts[A][(B,C)] += count
		return rules_counts, lhs_counts
	
	def __format_rules_by_rhs1(self):
		rules_rhs1_major = {}
		for lhs in self.rules_counts:
			for (rhs1,rhs2) in self.rules_counts[lhs]:
				if rhs1 not in rules_rhs1_major:
					rules_rhs1_major[rhs1] = set({})
				# Assumption, Rules added here are unique ( #TODO verify when not tired)
				# should be unique because iterating over left hand side
				# Assert rule with same parameters never added twice
				prob = self.get_rule_prob(lhs, rhs1, rhs2)
				rules_rhs1_major[rhs1].add( Rule(lhs,rhs1,rhs2,prob) )
		return rules_rhs1_major

	def get_rule_prob(self, A, B, C=""):
		""" Get probability for a given rule """
		if C != "":
			rule_count = self.rules_counts[A][(B,C)]
		else:
			rule_count = self.rules_counts[A][(B,'')]
		lhs_count = self.lhs_counts[A]
		return rule_count / float(lhs_count)

	def get_top(self, A):
		return sorted(self.rules_counts[A].items(), key=lambda x:x[1], reverse=True)[0:5]
