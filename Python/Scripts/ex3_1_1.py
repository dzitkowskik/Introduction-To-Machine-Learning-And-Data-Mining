# exercise 3.1.1

import numpy as np

x = np.array([-0.68, -2.11, 2.39, 0.26, 1.46, 1.33, 1.03, -0.41, -0.33, 0.47])

# Compute values
mean_x = x.mean()
variance_x = x.var(ddof=1)
median_x = np.median(x)
range_x = x.max()-x.min()

# Display results
print 'Vector:',x
print 'Mean:',mean_x
print 'Variance:',variance_x
print 'Median:',median_x
print 'Range:',range_x
