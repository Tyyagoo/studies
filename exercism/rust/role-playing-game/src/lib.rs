pub struct Player {
    pub health: u32,
    pub mana: Option<u32>,
    pub level: u32,
}

impl Player {
    pub fn revive(&self) -> Option<Player> {
        match self {
            Player { health: 0, .. } => Some(Player {
                health: 100,
                level: self.level,
                mana: if self.level >= 10 { Some(100) } else { None },
            }),
            _ => None,
        }
    }

    pub fn cast_spell(&mut self, mana_cost: u32) -> u32 {
        match self {
            Player { mana: Some(x), .. } if *x >= mana_cost => {
                self.mana = Some(*x - mana_cost);
                mana_cost * 2
            }
            Player { mana: None, .. } => {
                self.health = u32::saturating_sub(self.health, mana_cost);
                0
            }
            _ => 0,
        }
    }
}
