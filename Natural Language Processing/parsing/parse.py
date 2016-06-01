from pcfg import PCFG
from chart import Chart
import pdb

#sentence = ["i", "like", "books", "and", "also", "jobs", "i", "like", "books", "and", "also", "jobs"]


class Parser():
	def __init__(self, rules_filename, sentences_filename, output_filename):
		self.grammar = PCFG(rules_filename)
		self.sentences_filename = sentences_filename
		self.parse_tree = ""
		self.__parse_sentences()
		with open(output_filename,'w') as out:
			out.write(self.parse_tree)
		# corr = "(TOP (S (VP (VB let) (S (NP (PRP 's)) (VP (VB make) (S (NP (DT that)) (NP (CD *UNK*))) (, ,) (S (ADVP (RB just)) (VP (TO to) (VP (VB be) (ADJP (JJ sure)))))))) (. .))) "
		# print corr
	def __parse_sentences(self):
		counter = 1
		for sentence in open(self.sentences_filename):
			sentence = sentence.split()
			if len(sentence) > 25:
				self.parse_tree += "*IGNORE*\n"
				continue
			chart = Chart(sentence, self.grammar)

			print("sentence done",counter)
			start = chart.get_top()
			self.gen_tree(start)
			self.parse_tree += "\n"
			counter += 1
		#Remove last newline
		self.parse_tree = self.parse_tree[0:-1]

	def gen_tree(self, root):
		if not ( root.bp1 or root.bp2 ):
			self.parse_tree += root.label
		else:
			if root.label != "TOP":
				self.parse_tree += " "
			self.parse_tree += "("+root.label+" "
			if root.bp1:
				self.gen_tree(root.bp1)
			if root.bp2:
				self.gen_tree(root.bp2)
			self.parse_tree += ")"

