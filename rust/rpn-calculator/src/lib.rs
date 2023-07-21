#[derive(Debug)]
pub enum CalculatorInput {
    Add,
    Subtract,
    Multiply,
    Divide,
    Value(i32),
}

pub fn evaluate(inputs: &[CalculatorInput]) -> Option<i32> {
    use CalculatorInput::*;

    let mut stack: Vec<i32> = Vec::new();

    for token in inputs.into_iter() {
        match token {
            Value(value) => stack.push(*value),
            operation => {
                let rhv = stack.pop();
                let lhv = stack.pop();

                if rhv.is_some() && lhv.is_some() {
                    let rhv = rhv.unwrap();
                    let lhv = lhv.unwrap();

                    match operation {
                        Add => stack.push(lhv + rhv),
                        Subtract => stack.push(lhv - rhv),
                        Multiply => stack.push(lhv * rhv),
                        Divide => stack.push(lhv / rhv),
                        _ => (),
                    }
                } else {
                    return None;
                }
            }
        }
    }

    if stack.len() == 1 {
        stack.pop()
    } else {
        None
    }
}
