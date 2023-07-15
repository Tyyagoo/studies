#include "reverse_string.h"

namespace reverse_string {

std::string reverse_string(std::string str) {
    for (size_t i = 0; i < str.size() / 2; ++i) {
        char tmp = str[str.size() - 1 - i];
        str[str.size() - 1 - i] = str[i];
        str[i] = tmp;
    }
    return str;
}

}
