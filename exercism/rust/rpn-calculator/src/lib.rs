#[derive(Debug)]
pub enum CalculatorInput {
    Add,
    Subtract,
    Multiply,
    Divide,
    Value(i32),
}

pub fn evaluate(inputs: &[CalculatorInput]) -> Option<i32> {
    let mut stack: Vec<i32> = vec![];
    for entry in inputs {
        match entry {
            CalculatorInput::Value(x) => stack.push(*x),
            op => {
                let y = stack.pop();
                let x = stack.pop();

                match (x, y) {
                    (Some(x), Some(y)) => match op {
                        CalculatorInput::Add => stack.push(x + y),
                        CalculatorInput::Subtract => stack.push(x - y),
                        CalculatorInput::Multiply => stack.push(x * y),
                        CalculatorInput::Divide => stack.push(x / y),
                        _ => panic!(),
                    },
                    _ => return None,
                };
            }
        }
    }

    match stack.len() {
        1 => stack.pop(),
        _ => None,
    }
}
