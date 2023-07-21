use std::collections::HashSet;

pub fn anagrams_for<'a>(word: &str, possible_anagrams: &'a [&str]) -> HashSet<&'a str> {
    let exclude_word = word.to_lowercase();
    let letters: Vec<char> = normalize(word);

    possible_anagrams
        .iter()
        .filter(|&w| {
            let current_letters = normalize(w);
            current_letters == letters && w.to_lowercase() != exclude_word
        })
        .copied()
        .collect()
}

fn normalize(word: &str) -> Vec<char> {
    let mut chars: Vec<char> = word.to_lowercase().chars().collect();
    chars.sort_unstable();
    chars
}
