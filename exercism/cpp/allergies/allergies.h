#if !defined(ALLERGIES_H)
#define ALLERGIES_H
#include <string>
#include <unordered_set>
#include <map>

namespace allergies {

class allergy_test {
    static std::map<std::string, unsigned int> allergies;
    public:
        int score;

        allergy_test(int x) { score  = x; };
        bool is_allergic_to(std::string item);
        std::unordered_set<std::string> get_allergies();
};

}

#endif