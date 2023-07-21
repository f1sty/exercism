use std::fmt;

#[derive(Debug, Eq, PartialEq)]
pub struct Clock {
    hours: i32,
    minutes: i32,
}

impl Clock {
    const HOURS_PER_DAY: i32 = 24;
    const MINUTES_PER_HOUR: i32 = 60;

    pub fn new(hours: i32, minutes: i32) -> Self {
        let minutes_per_day = Self::HOURS_PER_DAY * Self::MINUTES_PER_HOUR;
        let total_minutes = (minutes + Self::MINUTES_PER_HOUR * hours).rem_euclid(minutes_per_day);
        let hours = total_minutes
            .div_euclid(Self::MINUTES_PER_HOUR)
            .rem_euclid(Self::HOURS_PER_DAY);
        let minutes = total_minutes.rem_euclid(Self::MINUTES_PER_HOUR);

        Self { hours, minutes }
    }

    pub fn add_minutes(&self, minutes: i32) -> Self {
        Self::new(self.hours, self.minutes + minutes)
    }
}
impl fmt::Display for Clock {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:02}:{:02}", self.hours, self.minutes)
    }
}
