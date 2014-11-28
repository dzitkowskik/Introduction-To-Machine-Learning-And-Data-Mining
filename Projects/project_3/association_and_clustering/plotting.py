import sys
import numpy as np
from pylab import *
from scipy import stats


class Results(object):
    def __init__(self):
        self.GMM_per_clust_no = \
[0.13688014,  0.13837407,  0.14652024,  0.15566729,  0.16990819,  0.16360413,
0.16191632,  0.18147025,  0.18180734,  0.18700313,  0.19206037,  0.17559811,
0.18294911,  0.18311791,  0.17068671,  0.21343687,  0.18857869,  0.18645952,
0.19625636,  0.20603556,  0.17454899]

        self.GMM_scores_avg = \
[0, 0.1414, 0.1859, 0.2095, 0.2635, 0.2948]
        self.Hier_scores_avg = \
[0, 0.2211, 0.2311, 0.3039, 0.3104, 0.3328]
        self.data_size = \
[0, 250, 500, 1000, 2000, 3000]


if __name__ == '__main__':
    results = Results()
    figure(0)
    xlabel('Number of clusters')
    ylabel('Adjusted Mutual Information (1.0 if equal)')
    title('Number of clusters in GMM vs AMI score')
    plot(range(15, 36), results.GMM_per_clust_no, color='r', linewidth=2.0)
    show()

    figure(1)
    xlabel('Data size')
    ylabel('AMI (Higher = better)')
    title('GMM vs Hierarchical clustering')
    plot(
        results.data_size,
        results.GMM_scores_avg,
        color='r',
        linewidth=2.0,
        label='GMM')
    plot(
        results.data_size,
        results.Hier_scores_avg,
        color='g',
        linewidth=2.0,
        label='Hierarchical')
    legend(loc='lower right')
    show()

    # N = 4
    # ind = np.arange(N)  # the x locations for the groups
    # width = 0.25       # the width of the bars
    #
    # fig, ax = plt.subplots()
    # rects1 = ax.bar(ind, results.NN_error_rates, width, color='r')
    # rects2 = ax.bar(
    #     ind+width,
    #     results.NaiveBayes_error_rates,
    #     width,
    #     color='g')
    # rects3 = ax.bar(
    #     ind+2*width,
    #     results.KNeighbors_error_rates,
    #     width,
    #     color='b')
    #
    # # add some text for labels, title and axes ticks
    # ax.set_ylabel('Error rate')
    # ax.set_title('Error rates')
    # ax.set_xticks(ind + 2 * width)
    # ax.set_xticklabels(('Cross 1', 'Cross 2', 'Cross 3', 'Cross 4'))
    #
    # ax.legend(
    #     (rects1[0], rects2[0], rects3[0]),
    #     ('Neural Network', 'Naive Bayes', 'K-Neighbors'))
    #
    # def autolabel(rects):
    #     # attach some text labels
    #     for rect in rects:
    #         height = rect.get_height()
    #         ax.text(
    #             rect.get_x() + rect.get_width()/2.,
    #             1.05 * height,
    #             '%2.2f' % float(height),
    #             ha='center', va='bottom')
    #
    # autolabel(rects1)
    # autolabel(rects2)
    # autolabel(rects3)
    #
    # plt.show()
    #
    # grid_scores = results.NB_accuracy
    # it = range(1, len(grid_scores[0]) + 1)
    # figure(3)
    # xlabel("Naive Bayes - number of features selected")
    # ylabel("Cross validation score (accuracy)")
    # plot(it, grid_scores[0], color='r', linewidth=2.0, label='Cross 1')
    # plot(it, grid_scores[1], color='g', linewidth=2.0, label='Cross 2')
    # plot(it, grid_scores[2], color='b', linewidth=2.0, label='Cross 3')
    # plot(it, grid_scores[3], color='y', linewidth=2.0, label='Cross 4')
    # legend(loc='lower right')
    # show()
    #
    #
    # # T-TEST
    # NN_err = results.NN_error_rates_2
    # NB_err = results.NaiveBayes_error_rates_2
    # KN_err = results.KNeighbors_error_rates_2
    # BC_err = results.BiggestClassPredictor
    # [tstval1, pvalue1] = stats.ttest_ind(NN_err, NB_err)
    # [tstval2, pvalue2] = stats.ttest_ind(NN_err, KN_err)
    # [tstval3, pvalue3] = stats.ttest_ind(NB_err, KN_err)
    #
    # [tstval4, pvalue4] = stats.ttest_ind(NN_err, BC_err)
    # [tstval5, pvalue5] = stats.ttest_ind(KN_err, BC_err)
    # [tstval6, pvalue6] = stats.ttest_ind(NB_err, BC_err)
    #
    # print round(pvalue1, 9)
    # val = [["Compared alg.", "t-test value", "p-value", "significantly"],
    #         ["NN vs NB", round(tstval1, 1), round(pvalue1, 4), pvalue1 < 0.05],
    #         ["NN vs KN", round(tstval2, 1), round(pvalue2, 4), pvalue2 < 0.05],
    #         ["NB vs KN", round(tstval3, 1), round(pvalue3, 4), pvalue3 < 0.05],
    #         ["BC vs NN", round(tstval4, 1), round(pvalue4, 4), pvalue4 < 0.05],
    #         ["BC vs KN", round(tstval5, 1), round(pvalue5, 4), pvalue5 < 0.05],
    #         ["BC vs NB", round(tstval6, 1), round(pvalue6, 4), pvalue6 < 0.05]]
    #
    # np.savetxt("ttest.csv", val, delimiter=' & ', fmt='%s', newline=' \\\\\n')
    #
    # # Boxplot to compare classifier error distributions
    # figure()
    # boxplot([KN_err, NN_err, NB_err])
    # xlabel('K-Neighbors vs Neural Network vs Naive Bayes')
    # ylabel('K-fold cross-validation error [%]')
    # xticks([1, 2, 3], ['K-Neighbors', 'Neural Network', 'Naive Bayes'])
    # show()
