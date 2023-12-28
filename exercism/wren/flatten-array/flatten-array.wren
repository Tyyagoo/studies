class Flatten {
  static flatten(list) {
    var result = []
    for (el in list) {
      if (el == null) continue
      if (el is Sequence) result = result + flatten(el) else result.add(el)
    }
    return result
  }
}