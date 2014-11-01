import sys
import numpy as np
from pylab import *
from scipy import stats


class Results(object):
    def __init__(self):
        # 4 fold cross validation
        self.NN_error_rates = [0.3488, 0.3750, 0.4164, 0.3590]
        self.NaiveBayes_error_rates = [0.4482, 0.4598, 0.4388, 0.4564]
        self.KNeighbors_error_rates = [0.0422, 0.0422, 0.0434, 0.0460]

        # 10 fold cross validation
        self.NN_error_rates_2 = \
[0.357, 0.371, 0.366, 0.372, 0.405, 0.371, 0.404, 0.374, 0.393, 0.401]
        self.NaiveBayes_error_rates_2 = \
[0.429, 0.442, 0.467, 0.448, 0.456, 0.462, 0.444, 0.455, 0.440, 0.449]
        self.KNeighbors_error_rates_2 = \
[0.035, 0.035, 0.045, 0.038, 0.040, 0.032, 0.045, 0.050, 0.049, 0.037]

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
        self.NB_accuracy = \
[[0.05216673, 0.16948604, 0.24898836, 0.25140338, 0.28592436, 0.32241157,
  0.37448850, 0.38556729, 0.40723945, 0.49348714, 0.54339751, 0.54230951,
  0.58813333, 0.64012797, 0.67138812, 0.68439432, 0.69272644],
[ 0.05224987, 0.15850133, 0.25857634, 0.25615460, 0.28083587, 0.33483017,
  0.38749620, 0.39399696, 0.41516605, 0.50115237, 0.55364912, 0.56032562,
  0.59997923, 0.64304627, 0.67055997, 0.68157238, 0.69399156],
[ 0.05091669, 0.13808696, 0.22633516, 0.24582184, 0.27731407, 0.33059129,
  0.38232362, 0.39315975, 0.40966108, 0.49765200, 0.54765119, 0.54889828,
  0.59189645, 0.64331373, 0.66114720, 0.67423677, 0.68465545],
[ 0.05083359, 0.13524413, 0.23798838, 0.25756984, 0.27875229, 0.31883491,
  0.38307887, 0.39224431, 0.40891974, 0.49733538, 0.54499315, 0.54741040,
  0.58382421, 0.63990547, 0.65765351, 0.66924905, 0.68016717]]


def main():
    print Results().NN_inner_errors

if __name__ == '__main__':
    results = Results()

    labels = [
        'Algorithm',
        'Cross 1',
        'Cross 2',
        'Cross 3',
        'Cross 4',
        'Average']

    NN_error_rates = np.concatenate((
        ['Neural Network'],
        results.NN_error_rates,
        [0.3748]))
    NB_error_rates = np.concatenate((
        ['Naive Bayes'],
        results.NaiveBayes_error_rates,
        [0.4508]))
    KN_error_rates = np.concatenate((
        ['K-Neighbors'],
        results.KNeighbors_error_rates,
        [0.0435]))
    a = [labels, NN_error_rates, NB_error_rates, KN_error_rates]
    np.savetxt("errors.csv", a, delimiter=' & ', fmt='%s', newline=' \\\\\n')

    figure(1)
    xlabel('K')
    ylabel('Error rate')
    title('K-Neighbors value of K vs error')
    for i in range(0, 4):
        plot(
            range(1, 9),
            results.KNeighbors_inner_errors[i-1],
            linewidth=2.0,
            label='Cross '+str(i))
    legend(loc='lower right')
    show()

    internal_errors = np.average(results.NN_inner_errors, 0) / 100.0
    figure(2)
    xlabel('Number of hidden nodes')
    ylabel('Average error rate (cross validation)')
    title('Neural network hidden nodes vs error')
    plot(range(10, 31), internal_errors, color='r', linewidth=2.0)
    show()

    N = 4
    ind = np.arange(N)  # the x locations for the groups
    width = 0.25       # the width of the bars

    fig, ax = plt.subplots()
    rects1 = ax.bar(ind, results.NN_error_rates, width, color='r')
    rects2 = ax.bar(
        ind+width,
        results.NaiveBayes_error_rates,
        width,
        color='g')
    rects3 = ax.bar(
        ind+2*width,
        results.KNeighbors_error_rates,
        width,
        color='b')

    # add some text for labels, title and axes ticks
    ax.set_ylabel('Error rate')
    ax.set_title('Error rates')
    ax.set_xticks(ind + 2 * width)
    ax.set_xticklabels(('Cross 1', 'Cross 2', 'Cross 3', 'Cross 4'))

    ax.legend(
        (rects1[0], rects2[0], rects3[0]),
        ('Neural Network', 'Naive Bayes', 'K-Neighbors'))

    def autolabel(rects):
        # attach some text labels
        for rect in rects:
            height = rect.get_height()
            ax.text(
                rect.get_x() + rect.get_width()/2.,
                1.05 * height,
                '%2.2f' % float(height),
                ha='center', va='bottom')

    autolabel(rects1)
    autolabel(rects2)
    autolabel(rects3)

    plt.show()

    grid_scores = results.NB_accuracy
    it = range(1, len(grid_scores[0]) + 1)
    figure(3)
    xlabel("Naive Bayes - number of features selected")
    ylabel("Cross validation score (accuracy)")
    plot(it, grid_scores[0], color='r', linewidth=2.0, label='Cross 1')
    plot(it, grid_scores[1], color='g', linewidth=2.0, label='Cross 2')
    plot(it, grid_scores[2], color='b', linewidth=2.0, label='Cross 3')
    plot(it, grid_scores[3], color='y', linewidth=2.0, label='Cross 4')
    legend(loc='lower right')
    show()


    # T-TEST
    NN_err = results.NN_error_rates_2
    NB_err = results.NaiveBayes_error_rates_2
    KN_err = results.KNeighbors_error_rates_2
    [tstval1, pvalue1] = stats.ttest_ind(NN_err, NB_err)
    [tstval2, pvalue2] = stats.ttest_ind(NN_err, KN_err)
    [tstval3, pvalue3] = stats.ttest_ind(NB_err, KN_err)
    print round(pvalue1, 9)
    val = [["Compared alg.", "t-test value", "p-value", "significantly"],
            ["NN vs NB", round(tstval1, 1), round(pvalue1, 4), pvalue1 < 0.05],
            ["NN vs KN", round(tstval2, 1), round(pvalue2, 4), pvalue2 < 0.05],
            ["NB vs KN", round(tstval3, 1), round(pvalue3, 4), pvalue3 < 0.05]]

    np.savetxt("ttest.csv", val, delimiter=' & ', fmt='%s', newline=' \\\\\n')

    # Boxplot to compare classifier error distributions
    figure()
    boxplot([KN_err, NN_err, NB_err])
    xlabel('K-Neighbors vs Neural Network vs Naive Bayes')
    ylabel('K-fold cross-validation error [%]')
    xticks([1, 2, 3], ['K-Neighbors', 'Neural Network', 'Naive Bayes'])
    show()
