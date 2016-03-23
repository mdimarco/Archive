import porter_stemmer

word = 'congratulations'
word = porter_stemmer.PorterStemmer().stem(word, 0,len(word)-1)
print word