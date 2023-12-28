class Year {
  static isLeap(n) {
    return (n % 400 == 0) || ((n % 4 == 0) && !(n % 100 == 0))
  }
}
