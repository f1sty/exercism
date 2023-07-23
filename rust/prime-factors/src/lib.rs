pub fn factors(n: u64) -> Vec<u64> {
    let mut divisor = 2;
    let mut factors = vec![];
    let mut number = n;

    loop {
        if (number % divisor) == 0 {
            factors.push(divisor);
            number = number / divisor;
        } else if number == 1 {
            break factors;
        } else {
            divisor += 1;
        }
    }
}
