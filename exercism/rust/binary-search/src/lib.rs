use std::cmp::{Ordering, PartialOrd};
use std::convert::AsRef;

pub fn find<T: PartialOrd, U: AsRef<[T]>>(array: U, key: T) -> Option<usize> {
    let array = array.as_ref();

    if array.is_empty() {
        return None;
    }

    let mid = (array.len() - 1) / 2;

    match array.get(mid)?.partial_cmp(&key)? {
        Ordering::Equal => Some(mid),
        Ordering::Greater => find(array.get(..mid)?, key),
        Ordering::Less => find(array.get((mid + 1)..)?, key).map(|m| mid + m + 1),
    }
}
