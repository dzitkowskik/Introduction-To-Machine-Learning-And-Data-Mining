# exercise 2.1.2
import numpy as np
from tmgsimple import TmgSimple

# Generate text matrix with help of simple class TmgSimple
tm = TmgSimple(filename='../Data/textDocs.txt', )

# Extract variables representing data
X = tm.get_matrix(sort=True)
attributeNames = tm.get_words(sort=True)

# Display the result
print attributeNames
print X
