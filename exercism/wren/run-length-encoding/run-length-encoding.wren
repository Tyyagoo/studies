class RLE {
  static encode(s) {
    if (s.isEmpty) return ""
    var gs = accumulate(s.bytes, Fn.new { |past, curr| past == curr })
    return gs.map{|g| "%(g.count == 1 ? "" : g.count)%(String.fromByte(g[0]))"}.join("")
  }
  
  static decode(s) {
    if (s.isEmpty) return ""
    var isDigit = Fn.new { |byte| byte >= 48 && byte <= 57 }
    var gs = accumulate(s.bytes, Fn.new {|past, curr| isDigit.call(past) && isDigit.call(curr)})
    var formatted = gs.map { |g|
                      if (!isDigit.call(g[0])) return String.fromByte(g[0])
                      var digits = g.map{|d| d - 48}
                      return Num.fromString(digits.join(""))
                  }.toList
    var result = ""
    var i = 0
    while (i < formatted.count) {
      if (formatted[i] is Num) {
        result = result + formatted[i + 1] * formatted[i]
        i = i + 2
      } else {
        result = result + formatted[i]
        i = i + 1
      }
    }
    return result
  }

  static accumulate(list, predicate) {
    var result = []
    var group = [list[0]]

    for (i in 1...list.count) {
      if (predicate.call(group[0], list[i])) {
        group.add(list[i])
      } else {
        result.add(group)
        group = [list[i]]
      }
    }

    result.add(group)
    return result
  }
}
