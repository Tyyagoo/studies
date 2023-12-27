export function toRna(dna: string): string {
  const complement = (x: string) => {
    switch (x) {
      case "G": return "C"
      case "C": return "G"
      case "T": return "A"
      case "A": return "U"
      default: throw new Error("Invalid input DNA.")
    }
  }
  return [...dna].map(complement).join("");
}
