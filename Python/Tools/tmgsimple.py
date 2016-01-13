import numpy as np
from nltk.stem.porter import PorterStemmer
from nltk.tokenize import TreebankWordTokenizer

class TmgSimple:
    ''' Class provides simple bag-of-words representation of multiple documents.
        The text matrix has N rows (corresponding to N documents) and M columns
        (corresponding to M words/stems extracted from the documents). The
        class filters the words with respect to stopwords, stemming, length, case.
        
        Example of creating bag-of-words representation:
            tm = TmgSimple('docs.txt')
            tm = TmgSimple('docs.txt', min_term_length=2, max_term_length=10)
            tm = TmgSimple('docs.txt', 'stopwords.txt', stem=True)
        Extract resulting matrix and dictionary:
            tm.get_words(sort=True)
            tm.get_matrix(sort=True)
    '''
    words = []
    stopwords = []
    bag_of_words_matrix = None
    min_word_length = 3
    max_word_length = 30
    stopwords = []
    stem = False


    def __init__(self, filename='', stopwords_filename='', stem=False, min_term_length=3, max_term_length=30):
        self.stem = stem
        self.min_term_length=min_term_length
        self.max_term_length=max_term_length
        if len(stopwords_filename)>0:
            fstopwords = open(stopwords_filename,'r').read()
            self.stopwords = sorted(set(self.__tokenize(fstopwords)))
        print('\nExtracting documents from the file: {0}\n'.format(filename))
        print('Min. term length: {0}\nMax. term length: {1}\nStemming: {2}\nStopwords: {3}\n'.format(min_term_length, max_term_length, stem, len(stopwords_filename)>0))
        if len(filename)>0:
            self.extract_documents(filename)
            

    def __filter_words(self, word_list, sort=False, unique=False):
        ''' Returns filtered word list (lowcase, stop words eliminated,
            short words eliminated, stemmed). The list will be sorted, and/or
            filtered to contain unique words only.
        '''
        word_list = [word.lower().strip(',. ') for word in word_list]    
        if unique:
            word_list = list(set(word_list))
        if len(self.stopwords)>0:
            word_list = [word for word in word_list if word not in self.stopwords]
        if self.stem:
            stemmer = PorterStemmer()
            word_list = [stemmer.stem(word) for word in word_list]
        if unique and self.stem:
            word_list = list(set(word_list))
        word_list = [word for word in word_list if len(word)>=self.min_word_length and len(word)<=self.max_word_length]
        if sort:
            word_list = sorted(word_list)
        return word_list


    def __tokenize(self, text):
        ''' Returns tokens extracted from text. '''
        return TreebankWordTokenizer().tokenize(text)
        

    def extract_documents(self,filename):
        '''Extract multiple documents from single file.
        Here, each nonempty line is considered as independent document.'''

        # Read documents from file
        f = open(filename,'r')
        docs = f.read()
        f.seek(0); docs_lines = f.readlines()
        f.close()

        # Create a dictionary of words
        words = self.__filter_words(self.__tokenize(docs), sort=True, unique=True )
        self.words = dict(zip(words,range(len(words))))

        # Create a bag-of-words matrix for all the documents
        docs = [doc for doc in docs_lines if len(doc)>1]
        self.bag_of_words_matrix = np.zeros([len(docs),len(self.words)])
        row = 0
        for doc in docs:
            print('Processing document {0}/{1}...'.format(row+1,len(docs)))
            words = self.__filter_words(self.__tokenize(doc))
            print('   Number of terms: {0}'.format(len(words)))
            for word in words:
                # increase count of this word in this document
                col = self.words[word]
                self.bag_of_words_matrix[row,col] += 1
            row += 1
        print('\nNumber of documents (N):{0}\nNumber of extracted terms (M):{1}\n'.format(self.bag_of_words_matrix.shape[0],self.bag_of_words_matrix.shape[1]))
    

    def documents_count(self):
        ''' Returns number of documents.'''
        np.shape(self.bag_of_words_matrix)[0]
    

    def words_count(self):
        ''' Returns number of words.'''
        np.shape(self.bag_of_words_matrix)[1]        
        

    def get_words(self, sort=True):
        ''' Returns list of words encountered in file (after optional filetering).'''
        if sort:
            return sorted(self.words)
        else:
            return self.words.keys()
        

    def get_matrix(self, sort=True):
        ''' Returns a data matrix of dimension NxM, constructed from
        the text documents (bag-of-words). The N rows correspond to documents,
        and the M columns correspond to terms (extracted features).        
        '''
        if sort:
            col_order = [self.words[word] for word in sorted(self.words)]        
        else:
            col_order = [self.words[word] for word in self.words]        
        return self.bag_of_words_matrix[:,col_order]