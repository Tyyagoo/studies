import "random" for Random

class Util {
  static abilityModifier(n) {
    if (n < 3) Fiber.abort("Ability scores must be at least 3")
    if (n > 18) Fiber.abort("Ability scores can be at most 18")
    return ((n - 10) / 2).floor
  }
}

class Character {
  static rollAbility() {
    var rnd = Random.new()
    var r1 = rnd.int(1,6)
    var r2 = rnd.int(1,6)
    var r3 = rnd.int(1,6)
    return r1 + r2 + r3
  }

  construct new() {
    _strength = Character.rollAbility()
    _dexterity = Character.rollAbility()
    _constitution = Character.rollAbility()
    _intelligence = Character.rollAbility()
    _wisdom = Character.rollAbility()
    _charisma = Character.rollAbility()
    _hitpoints = 10 + Util.abilityModifier(constitution)
  }

  strength { _strength }
  dexterity { _dexterity }
  constitution { _constitution }
  intelligence { _intelligence }
  wisdom { _wisdom }
  charisma { _charisma }
  hitpoints { _hitpoints }
}
