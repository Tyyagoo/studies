#include "high_scores.h"

#include <algorithm>

namespace arcade {

    std::vector<int> HighScores::list_scores() {
        return scores;
    }

    int HighScores::latest_score() {
        return scores.back();
    }

    int HighScores::personal_best() {
        return *std::max_element(scores.begin(), scores.end());
    }

    std::vector<int> HighScores::top_three() {
        auto v = scores;
        std::sort(v.begin(), v.end(), std::greater<int>());
        auto end = std::min(3, (int) v.size());
        return {v.begin(), v.begin() + end};
    }

}
