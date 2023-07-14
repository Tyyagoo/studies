#include "vehicle_purchase.h"

namespace vehicle_purchase {

    bool needs_license(std::string kind){
        return kind == "car" || kind == "truck";
    }

    std::string choose_vehicle(std::string option1, std::string option2) {
        std::string answer = option1 < option2 ? option1 : option2;
        return answer + " is clearly the better choice.";
    }

    double calculate_resell_price(double original_price, double age) {
        if (age < 3) return original_price * 0.8;
        if (age < 10) return original_price * 0.7;
        return original_price * 0.5;
    }

}