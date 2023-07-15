#include "armstrong_numbers.h"

#include <vector>
#include <cmath>

namespace armstrong_numbers {

bool is_armstrong_number(int n) {
    std::vector<int> digits = {};
    for (int x = n; x > 0; x = x / 10) digits.push_back(x % 10);

    int sum = 0;
    for (int d : digits) sum += std::pow(d, digits.size());
    
    return sum == n;
}

}
