import sys
import numpy as np
from pylab import *


class Results(object):
    def __init__(self):
        self.NN_error_rates = [0.3488, 0.375, 0.4164, 0.359]
        self.NaiveBayes_error_rates = [0.4482, 0.4598, 0.4388, 0.4564]
        self.KNeighbors_error_rates = [0.0422, 0.0422, 0.0434, 0.046]
        self.NN_inner_errors = \
[[49.85, 50.38, 43.31, 44.81, 41.79, 43.50, 43.91, 42.70, 40.87, 40.93, 39.55,
38.97, 42.43, 38.94, 41.56, 38.81, 39.45, 41.27, 40.37, 40.01, 39.00],
[44.91, 47.65, 47.00, 44.54, 42.96, 45.47, 43.18, 40.84, 40.47, 39.29, 42.17,
37.93, 39.53, 40.06, 39.94, 37.97, 39.02, 35.99, 38.27, 37.32, 36.53],
[53.33, 44.13, 43.93, 46.26, 42.37, 43.57, 43.97, 42.74, 43.52, 41.91, 38.56,
41.13, 39.94, 39.81, 40.43, 40.03, 38.13, 39.97, 40.05, 40.75, 38.40]]
        self.KNeighbors_inner_errors = \
[[0.056, 0.073, 0.062, 0.065, 0.061, 0.064, 0.065, 0.068],
[ 0.054, 0.072, 0.057, 0.060, 0.060, 0.065, 0.066, 0.066],
[ 0.052, 0.070, 0.059, 0.060, 0.059, 0.064, 0.064, 0.068],
[ 0.054, 0.070, 0.059, 0.062, 0.059, 0.063, 0.065, 0.068]]

def main():
    print Results().NN_inner_errors

if __name__ == '__main__':
    results = Results()

    a = [results.NN_error_rates, results.NaiveBayes_error_rates, results.KNeighbors_error_rates]
    np.savetxt("error_rates.csv", np.matrix(a), delimiter=' & ', fmt='%2.2f', newline=' \\\\\n')

    figure(1)
    for i in range(0,4):
        plot(range(1,9), results.KNeighbors_inner_errors[i-1])
    show()


    N = 4
    ind = np.arange(N)  # the x locations for the groups
    width = 0.25       # the width of the bars

    fig, ax = plt.subplots()
    rects1 = ax.bar(ind, results.NN_error_rates, width, color='r')
    rects2 = ax.bar(ind+width, results.NaiveBayes_error_rates, width, color='g')
    rects3 = ax.bar(ind+2*width, results.KNeighbors_error_rates, width, color='b')

    # add some text for labels, title and axes ticks
    ax.set_ylabel('Error rate')
    ax.set_title('Error rates')
    ax.set_xticks(ind + 2*width)
    ax.set_xticklabels( ('Cross 1', 'Cross 2', 'Cross 3', 'Cross 4') )

    ax.legend(
        (rects1[0], rects2[0], rects3[0]),
        ('Neural Network', 'Naive Bayes', 'K-Neighbors'))

    def autolabel(rects):
        # attach some text labels
        for rect in rects:
            height = rect.get_height()
            ax.text(rect.get_x()+rect.get_width()/2., 1.05*height, '%2.2f' %float(height),
                    ha='center', va='bottom')

    autolabel(rects1)
    autolabel(rects2)
    autolabel(rects3)

    plt.show()
