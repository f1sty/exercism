pub fn nth(n: u32) -> u32 {
    let mut count = 0;
    let mut number = 2;

    loop {
        if count == n {
            break number;
        }

        number += 1;
        if is_prime(number) {
            count += 1;
        }
    }
}

fn is_prime(number: u32) -> bool {
    let upper_bound = (number as f32).sqrt().round() as u32;

    !(2..=upper_bound).any(|devisor| (number % devisor) == 0)
}
