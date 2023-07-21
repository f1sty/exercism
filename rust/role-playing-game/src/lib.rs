pub struct Player {
    pub health: u32,
    pub mana: Option<u32>,
    pub level: u32,
}

impl Player {
    pub fn revive(&self) -> Option<Player> {
        match self {
            Player {
                health: 0, level, ..
            } if level >= &10 => Some(Player {
                health: 100,
                mana: Some(100),
                level: level.to_owned(),
            }),
            Player {
                health: 0, level, ..
            } => Some(Player {
                health: 100,
                mana: None,
                level: level.to_owned(),
            }),
            _ => None,
        }
    }

    pub fn cast_spell(&mut self, mana_cost: u32) -> u32 {
        match self {
            Player {
                mana: None, health, ..
            } => {
                self.health = if *health >= mana_cost {
                    *health - mana_cost
                } else {
                    0
                };
                0
            }
            Player {
                mana: Some(pool), ..
            } if *pool < mana_cost => 0,
            Player {
                mana: Some(pool), ..
            } => {
                self.mana = Some(*pool - mana_cost);
                mana_cost * 2
            }
        }
    }
}
