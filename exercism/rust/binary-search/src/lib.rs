pub fn find(array: &[i32], key: i32) -> Option<usize> {
    if array.is_empty() {
        return None;
    }

    let mid = (array.len() - 1) / 2;

    match array.get(mid) {
        Some(n) if *n == key => Some(mid),
        Some(n) if *n > key => find(array.get(0..mid)?, key),
        Some(n) if *n < key => {
            find(array.get((mid + 1)..array.len())?, key).map(|offset| mid + offset + 1)
        }
        _ => None,
    }
}
