import numpy as np
import math
from collections import Counter 
class GibbsSampler():
	def __init__(self, articles_file, num_topics=50, alpha=0.5, iterations=10):
		self.articles_file = articles_file
		self.num_topics = num_topics
		self.alpha = float(alpha)
		self.iterations = iterations
		self.__read_articles()
		self.__train()

	def __read_articles(self):
		tokens = open(self.articles_file).read()
		self.docs = {}
		self.unique_words = set({})
		doc_ind = -1
		stop_ind = 0
		for ind, token in enumerate(tokens.split()):
			#Breakpoint between articles
			if stop_ind == ind:
				stop_ind += int(token) + 1
				doc_ind += 1
				self.docs[doc_ind] = []
			else:
				self.docs[doc_ind].append( (token, np.random.choice(self.num_topics,1)[0]) )
				self.unique_words.add(token)
		self.num_unique_words = len(self.unique_words)

	def __get_prob(self, doc, topic, word):
		delta = (self.counts_dt[doc][topic] + self.alpha) / (self.counts_do[doc] + self.alpha*self.num_topics)
		tau = (self.counts_tw[topic][word] + self.alpha) / (self.counts_to[topic] + self.alpha*self.num_unique_words)
		return delta * tau

	def __get_dist(self, doc_ind, word):
		dist = np.zeros(self.num_topics)
		for topic in range(self.num_topics):
			dist[topic] = self.__get_prob(doc_ind,topic,word)
		dist = dist/sum(dist)
		return dist

	def __train(self):
		for x in range(self.iterations):

			print("Iteration", x)
			self.counts_dt = [Counter() for doc_ind in self.docs]
			self.counts_do = Counter()
			self.counts_tw = [Counter() for x in range(self.num_topics)]
			self.counts_to = Counter()

			# Count
			for doc_ind, words in self.docs.items():
				for word, topic in words:
					self.counts_dt[doc_ind][topic] += 1
					self.counts_tw[topic][word] += 1
					self.counts_do[doc_ind] += 1
					self.counts_to[topic] += 1
			# Re-Sample
			for doc_ind, words in self.docs.items():
				for ind, (word,old_topic) in enumerate(words):

					#Remove Counts
					self.counts_dt[doc_ind][old_topic] -= 1
					self.counts_tw[old_topic][word] -= 1
					self.counts_do[doc_ind] -= 1
					self.counts_to[old_topic] -= 1

					topic_dist = self.__get_dist(doc_ind, word)
					new_topic = np.random.choice(self.num_topics, 1, p=topic_dist)[0]
					words[ind] = (word,new_topic)

					#Restore Counts 
					self.counts_dt[doc_ind][new_topic] += 1
					self.counts_tw[new_topic][word] += 1
					self.counts_do[doc_ind] += 1
					self.counts_to[new_topic] += 1


		# Output 1 Log Likelihood
		prob = 0
		for doc_ind, words in self.docs.items():
			for word, topic in words:
				prob += math.log( sum([self.__get_prob(doc_ind, top, word) for top in range(self.num_topics)]) )
		print("Log Likelihood at convergence %.2f " % prob)

		# Output 2 
		doc_ind = 16
		print("Topic probabilities for document, "+str(doc_ind))
		for topic in range(self.num_topics):
			prob = (self.counts_dt[doc_ind][topic] + self.alpha) / (self.counts_do[doc_ind] + self.alpha*self.num_topics)
			print("Topic %d: %f"%(topic, prob))
		print("")
		# Output 3
		theta = 5.0
		self.counts_ow = Counter()
		for word in self.unique_words:
			for topic in range(self.num_topics):
				self.counts_ow[word] += self.counts_tw[topic][word]
		for topic in range(self.num_topics):
			p_wt = {}
			for word in self.unique_words:
				p_wt[word] = (self.counts_tw[topic][word] + float(theta)) / (self.counts_ow[word] + theta * self.num_unique_words)
			top15 = sorted(p_wt.items(), key=lambda x:x[1], reverse=True)[0:15]
			top15 = [pair[0] for pair in top15]
			print("Topic: "+str(topic)+" "+str(top15))


