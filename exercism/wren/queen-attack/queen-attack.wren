class QueenAttack {
  static new() { this.new({}) }
  
  construct new(pieces) {
    _white = pieces["white"] || [7, 3]
    _black = pieces["black"] || [0, 3]

    if ((_white + _black).any {|x| x > 7 || x < 0 }) Fiber.abort("Queen must be placed on the board")

    if (_white[0] == _black[0] && _white[1] == _black[1]) Fiber.abort("Queens cannot share the same space")
      
  }

  toString {
    var grid = (0...8).map { |i| List.filled(8, "_") }.toList
    grid[_white[0]][_white[1]] = "W"
    grid[_black[0]][_black[1]] = "B"
    return grid.map { |xs| xs.join(" ")}.join("\n")
  }

  canAttack {
    return (_white[0] == _black[0]) || (_white[1] == _black[1]) || ((_white[0] - _black[0]).abs == (_white[1] - _black[1]).abs)
  }

  white { _white }
  black { _black }
}
