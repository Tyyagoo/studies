class DNA {
  static toRNA(strand) {
    var map = {"G": "C", "C": "G", "T": "A", "A": "U"}
    return strand.map { |dna| map[dna] }.join("")
  }
}
