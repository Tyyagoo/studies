#include <string>
#include <vector>

namespace election {

struct ElectionResult {
    std::string name{};
    int votes{};
};

int vote_count(ElectionResult& res) { return res.votes; }

void increment_vote_count(ElectionResult& res, int inc) { res.votes += inc; }

ElectionResult& determine_result(std::vector<ElectionResult>& candidates) {
    ElectionResult& president = candidates[0];
    for (const auto& c: candidates)
        if (c.votes > president.votes) president = c;

    president.name = "President " + president.name;
    return president;
}
}