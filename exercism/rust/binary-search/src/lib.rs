use std::cmp::{Ordering, PartialOrd};
use std::convert::AsRef;

pub fn find<T: PartialOrd, U: AsRef<[T]>>(array: U, key: T) -> Option<usize> {
    let array = array.as_ref();

    if array.is_empty() {
        return None;
    }

    let mid = (array.len() - 1) / 2;

    match array.get(mid)?.partial_cmp(&key) {
        Some(Ordering::Equal) => Some(mid),
        Some(Ordering::Greater) => find(array.get(0..mid)?, key),
        Some(Ordering::Less) => find(array.get((mid + 1)..array.len())?, key).map(|m| mid + m + 1),
        None => None,
    }
}
