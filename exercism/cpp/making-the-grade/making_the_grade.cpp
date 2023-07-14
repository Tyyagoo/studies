#include <array>
#include <string>
#include <vector>
#include <cmath>

std::vector<int> round_down_scores(std::vector<double> ss) {
    std::vector<int> rounded = {};
    for (double score : ss) rounded.emplace_back(trunc(score));
    return rounded;
}

int count_failed_students(std::vector<int> ss) {
    int failed = 0;
    for (int score : ss) if (score <= 40) failed++;
    return failed;
}

std::vector<int> above_threshold(std::vector<int> ss, int threshold) {
    std::vector<int> nerds = {};
    for (int score : ss) if (score >= threshold) nerds.emplace_back(score);
    return nerds;
}

// Create a list of grade thresholds based on the provided highest grade.
std::array<int, 4> letter_grades(int highest_score) {
    int step = (highest_score - 40) / 4;
    return {41, 41 + step, 41 + step * 2, 41 + step * 3};
}

// Organize the student's rank, name, and grade information in ascending order.
std::vector<std::string> student_ranking(std::vector<int> ss, std::vector<std::string> sn) {
    std::vector<std::string> ranked = {};
    for (int i = 0; i < ss.size(); ++i) {
        std::string f = std::to_string(i + 1) + ". " + sn[i] + ": " + std::to_string(ss[i]);
        ranked.emplace_back(f);
    }
    return ranked;
}

// Create a string that contains the name of the first student to make a perfect score on the exam.
std::string perfect_score(std::vector<int> ss, std::vector<std::string> sn) {
    for (int i = 0; i < ss.size(); ++i) if (ss[i] == 100) return sn[i];
    return "";
}