#include <string>

typedef std::string str;

namespace log_line {
    str message(str log) {
        return log.substr(log.find(" ") + 1);
    }

    str log_level(str log) {
        return log.substr(1, log.find("]") - 1);
    }

    str reformat(str log) {
        return message(log) + " (" + log_level(log) + ")";
    }
}
