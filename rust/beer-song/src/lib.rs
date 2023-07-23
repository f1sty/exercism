pub fn verse(n: u32) -> String {
    let verse = "n bottles of beer on the wall, n bottles of beer.\nTake one down and pass it around, {} bottles of beer on the wall.\n";

    match n {
        0 => "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n".to_string(),
        1 => verse.replace("n bottles", "1 bottle").replace("{}", "no more").replace("Take one", "Take it"),
        2 => verse.replace("n bottles", "2 bottles").replace("{} bottles", "1 bottle"),
        n => verse.replace("n bottles", format!("{n} bottles").as_str()).replace("{} bottles", format!("{} bottles", n - 1).as_str()),
    }
}

pub fn sing(start: u32, end: u32) -> String {
    (end..=start)
        .rev()
        .map(|verse_number| verse(verse_number))
        .collect::<Vec<String>>()
        .join("\n")
}
