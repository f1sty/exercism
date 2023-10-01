pub fn reply(message: &str) -> &str {
    // let message = message.trim();
    let message = message
        .chars()
        .filter(|chr| !chr.is_whitespace())
        .collect::<String>();

    dbg!(&message);
    if message.is_empty() {
        return "Fine. Be that way!";
    } else if message.ends_with('?') {
        if message
            .chars()
            .all(|chr| chr.is_digit(10) || chr.is_ascii_punctuation())
        {
            return "Sure.";
        } else if message
            .chars()
            .all(|chr| chr.is_uppercase() || chr.is_ascii_punctuation())
        {
            return "Calm down, I know what I'm doing!";
        }
    } else if message
        .chars()
        .all(|chr| chr.is_uppercase() || chr.is_ascii_punctuation() || chr.is_digit(10))
    {
        return "Whoa, chill out!";
    }
    "Whatever."
}
