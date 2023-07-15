#include "allergies.h"

std::map<std::string, unsigned int> 
    allergies::allergy_test::allergies = {
        {"eggs", 0x01},
        {"peanuts", 0x02},
        {"shellfish", 0x04},
        {"strawberries", 0x08},
        {"tomatoes", 0x10},
        {"chocolate", 0x20},
        {"pollen", 0x40}, 
        {"cats", 0x80}};

namespace allergies {

bool allergy_test::is_allergic_to(std::string item) {
    return allergies[item] & score;
}

std::unordered_set<std::string> allergy_test::get_allergies() {
    std::unordered_set<std::string> set;
    for (const auto& kv: allergies)
        if (is_allergic_to(kv.first))
            set.emplace(kv.first);
    return set;
}

}
