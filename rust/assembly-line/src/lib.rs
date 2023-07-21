const CARS_PER_HOUR: f64 = 221.0;

pub fn production_rate_per_hour(speed: u8) -> f64 {
    match speed {
        1..=4 => speed as f64 * CARS_PER_HOUR,
        5..=8 => speed as f64 * CARS_PER_HOUR * 0.9,
        9..=10 => speed as f64 * CARS_PER_HOUR * 0.77,
        _ => 0.0,
    }
}

pub fn working_items_per_minute(speed: u8) -> u32 {
    production_rate_per_hour(speed) as u32 / 60
}
