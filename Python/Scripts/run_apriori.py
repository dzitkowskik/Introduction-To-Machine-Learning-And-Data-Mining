import numpy as np
from subprocess import call
import re
import os


filename = 'courses.txt'
minSup = 80
minConf = 100
maxRule = 4

base_dir = os.path.dirname(__file__)
file = os.path.join(base_dir, 'apriori')
filename = os.path.join(base_dir, filename)
outfile = os.path.join(base_dir, 'apriori_temp1.txt')

# Run Apriori Algorithm
print('Mining for frequent itemsets by the Apriori algorithm')
temp = './apriori -f"," -s"{1}" -v"[Sup. %0S]" {2} {3}'.format(file, minSup, filename, outfile)
print temp
status1 = call(temp, shell=True)

if status1!=0:
    print('An error occured while calling apriori, a likely cause is that minSup was set to high such that no frequent itemsets were generated or spaces are included in the path to the apriori files.')
    exit()
if minConf>0:
    print('Mining for associations by the Apriori algorithm')
    status2 = call('./apriori -tr -f "," -n{0} -c{1} -s{2} -v"[Conf. %0C,Sup. %0S]" {3} apriori_temp2.txt'.format(maxRule, minConf, minSup, filename))
    if status2!=0:
        print('An error occured while calling apriori')
        exit()
print('Apriori analysis done, extracting results')


# Extract information from stored files apriori_temp1.txt and apriori_temp2.txt
f = open('apriori_temp1.txt','r')
lines = f.readlines()
f.close()
# Extract Frequent Itemsets
FrequentItemsets = ['']*len(lines)
sup = np.zeros((len(lines),1))
for i,line in enumerate(lines):
    FrequentItemsets[i] = line[0:-1]
    sup[i] = re.findall(' \d*]', line)[0][1:-1]
os.remove('apriori_temp1.txt')

# Read the file
f = open('apriori_temp2.txt','r')
lines = f.readlines()
f.close()
# Extract Association rules
AssocRules = ['']*len(lines)
conf = np.zeros((len(lines),1))
for i,line in enumerate(lines):
    AssocRules[i] = line[0:-1]
    conf[i] = re.findall(' \d*,', line)[0][1:-1]
os.remove('apriori_temp2.txt')

# sort (FrequentItemsets by support value, AssocRules by confidence value)
AssocRulesSorted = [AssocRules[item] for item in np.argsort(conf,axis=0).ravel()]
AssocRulesSorted.reverse()
FrequentItemsetsSorted = [FrequentItemsets[item] for item in np.argsort(sup,axis=0).ravel()]
FrequentItemsetsSorted.reverse()

# Print the results
import time; time.sleep(.5)
print('\n')
print('RESULTS:\n')
print('Frequent itemsets:')
for i,item in enumerate(FrequentItemsetsSorted):
    print('Item: {0}'.format(item))
print('\n')
print('Association rules:')
for i,item in enumerate(AssocRulesSorted):
    print('Rule: {0}'.format(item))
