use std::collections::HashSet;

pub fn is_pangram(sentence: &str) -> bool {
    let alphabet = ('a'..='z').collect::<HashSet<_>>();
    let unique_letters = sentence
        .to_lowercase()
        .chars()
        .into_iter()
        .collect::<HashSet<_>>();

    alphabet.is_subset(&unique_letters)
}
