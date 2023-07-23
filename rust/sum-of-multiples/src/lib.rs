use std::iter::from_fn;

pub fn sum_of_multiples(limit: u32, factors: &[u32]) -> u32 {
    let mut multiplies: Vec<u32> = factors
        .iter()
        .map(|&factor| match factor {
            0 => vec![0],
            factor => {
                let mut count = 1;
                from_fn(move || {
                    let multiply = count * factor;

                    if multiply < limit {
                        count += 1;
                        Some(multiply)
                    } else {
                        None
                    }
                })
                .collect::<Vec<u32>>()
            }
        })
        .flatten()
        .collect();

    multiplies.sort_unstable();
    multiplies.dedup();
    multiplies.iter().sum()
}
