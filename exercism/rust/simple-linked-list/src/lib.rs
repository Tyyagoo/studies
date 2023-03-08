use std::iter::FromIterator;

pub struct SimpleLinkedList<T> {
    head: Option<Box<Node<T>>>,
}

pub struct Node<T> {
    data: T,
    next: Option<Box<Node<T>>>,
}

impl<T> SimpleLinkedList<T> {
    pub fn new() -> Self {
        SimpleLinkedList { head: None }
    }

    pub fn is_empty(&self) -> bool {
        match self {
            SimpleLinkedList { head: None } => true,
            _ => false,
        }
    }

    pub fn len(&self) -> usize {
        let mut len = 0;
        let mut maybe_node = &self.head;

        while let Some(x) = maybe_node {
            len += 1;
            maybe_node = &x.next;
        }

        len
    }

    pub fn push(&mut self, element: T) {
        let new_head = Box::new(Node {
            data: element,
            next: std::mem::replace(&mut self.head, None),
        });
        self.head = Some(new_head);
    }

    pub fn pop(&mut self) -> Option<T> {
        match self {
            SimpleLinkedList { head: None } => None,
            SimpleLinkedList { .. } => {
                let mut popped = std::mem::replace(&mut self.head, None).unwrap();
                self.head = std::mem::replace(&mut popped.next, None);
                Some(popped.data)
            }
        }
    }

    pub fn peek(&self) -> Option<&T> {
        match &self.head {
            Some(node) => Some(&node.data),
            None => None,
        }
    }

    #[must_use]
    pub fn rev(&mut self) -> SimpleLinkedList<T> {
        let mut xs: SimpleLinkedList<T> = SimpleLinkedList::new();

        while let Some(x) = self.pop() {
            xs.push(x);
        }

        xs
    }
}

impl<T> FromIterator<T> for SimpleLinkedList<T> {
    fn from_iter<I: IntoIterator<Item = T>>(iter: I) -> Self {
        let mut xs: SimpleLinkedList<T> = SimpleLinkedList::new();

        for x in iter {
            xs.push(x);
        }

        xs
    }
}

impl<T> From<SimpleLinkedList<T>> for Vec<T> {
    fn from(mut xs: SimpleLinkedList<T>) -> Vec<T> {
        let mut vec: Vec<T> = Vec::with_capacity(xs.len());

        while let Some(x) = xs.pop() {
            vec.push(x);
        }

        // TODO: fix.
        vec.into_iter().rev().collect()
    }
}
