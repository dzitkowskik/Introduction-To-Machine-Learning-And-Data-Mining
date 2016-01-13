import numpy as np

def cfor(first,test,update):
    while test(first):
        yield first
        first = update(first)

def WriteAprioriFile(X,titles=None,filename="AprioriFile.txt"):
	#Setup
	output = u"";
	N, M = np.shape(X);

	#Go through conversion loop
	if titles==None:
		for i in cfor(0,lambda i:i<N,lambda i:i+1):
			for j in cfor(0,lambda j:j<M,lambda j:j+1):
				if (X[i,j] == 1):
					output = output + str(j) + u",";
			output = output[:-1] + u"\n";		
	else:
		for i in cfor(0,lambda i:i<N,lambda i:i+1):
			for j in cfor(0,lambda j:j<M,lambda j:j+1):
				if (X[i,j] == 1):
					output = output + titles[j] + u",";
			output = output[:-1] + u"\n";
	
	#White output to file
	f = open(filename, 'w');
	f.write(output);
	f.close;

