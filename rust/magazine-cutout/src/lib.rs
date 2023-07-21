// This stub file contains items that aren't used yet; feel free to remove this module attribute
// to enable stricter warnings.
#![allow(unused)]

use std::collections::HashMap;

pub fn can_construct_note(magazine: &[&str], note: &[&str]) -> bool {
    let mut magazine_words_histogram: HashMap<&str, isize> = HashMap::new();
    let mut note_words_histogram: HashMap<&str, isize> = HashMap::new();

    magazine.iter().for_each(|word| {
        magazine_words_histogram
            .entry(word)
            .and_modify(|qty| *qty += 1)
            .or_insert(1);
    });

    note.iter().for_each(|word| {
        note_words_histogram
            .entry(word)
            .and_modify(|qty| *qty += 1)
            .or_insert(1);
    });

    note.iter()
        .all(|word| magazine_words_histogram.get(word) >= note_words_histogram.get(word))
}
