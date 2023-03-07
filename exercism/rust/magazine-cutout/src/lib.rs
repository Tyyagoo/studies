use std::collections::HashMap;

pub fn can_construct_note(magazine: &[&str], note: &[&str]) -> bool {
    let mut magazine_hashmap: HashMap<&str, u32> = HashMap::new();

    for &word in magazine {
        magazine_hashmap
            .entry(word)
            .and_modify(|f| *f += 1)
            .or_insert(1);
    }

    let mut note_hashmap: HashMap<&str, u32> = HashMap::new();

    for &word in note {
        note_hashmap
            .entry(word)
            .and_modify(|f| *f += 1)
            .or_insert(1);
    }

    note_hashmap
        .iter()
        .all(|(k, v)| magazine_hashmap.get(k).map_or(false, |y| y >= v))
}
