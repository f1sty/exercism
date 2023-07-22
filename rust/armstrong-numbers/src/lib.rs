pub fn is_armstrong_number(num: u32) -> bool {
    let digits: Vec<u32> = num
        .to_string()
        .chars()
        .map(|char| char.to_digit(10).unwrap())
        .collect();
    let exp = digits.len() as u32;
    let check_value = digits
        .iter()
        .fold(0, |acc: u32, digit| acc.saturating_add(digit.pow(exp)));

    check_value == num
}
