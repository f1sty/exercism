pub fn brackets_are_balanced(string: &str) -> bool {
    let mut unclosed: Vec<char> = vec![];

    string.chars().for_each(|chr| match chr {
        '[' | '(' | '{' => unclosed.push(chr),
        ']' => {
            if let Some(new_unclosed) = unclosed.strip_suffix(&['[']) {
                unclosed = new_unclosed.to_vec();
            } else {
                unclosed.push(']');
            }
        }
        ')' => {
            if let Some(new_unclosed) = unclosed.strip_suffix(&['(']) {
                unclosed = new_unclosed.to_vec();
            } else {
                unclosed.push(')');
            }
        }
        '}' => {
            if let Some(new_unclosed) = unclosed.strip_suffix(&['{']) {
                unclosed = new_unclosed.to_vec();
            } else {
                unclosed.push('}');
            }
        }
        _ => (),
    });

    unclosed.is_empty()
}
