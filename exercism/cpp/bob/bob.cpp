#include "bob.h"
#include <regex>

namespace bob {

std::string hey(const std::string speech) {
    bool uppercase = false, 
         lowercase = false,
         question  = false,
         blank     = true;

    for (auto c: speech) {
        if (isupper(c)) uppercase = true;
        if (islower(c)) lowercase = true;
        if (!isspace(c)) blank = question = false;
        if (c == '?') question = true;
    }

    bool yelling = uppercase && !lowercase;

    if (blank) return "Fine. Be that way!";
    if (yelling && question) return "Calm down, I know what I'm doing!";
    if (question) return "Sure.";
    if (yelling) return "Whoa, chill out!";
    return "Whatever.";
}

}
