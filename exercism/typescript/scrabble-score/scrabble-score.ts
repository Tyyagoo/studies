export function score(word: any) {
  if (typeof word != "string") return 0;
  return [...word.toUpperCase()].reduce((acc, x) => {
    switch (true) {
      case "AEIOULNRST".includes(x): return acc + 1
      case "DG".includes(x): return acc + 2
      case "BCMP".includes(x): return acc + 3
      case "FHVWY".includes(x): return acc + 4
      case "K".includes(x): return acc + 5
      case "JX".includes(x): return acc + 8
      case "QZ".includes(x): return acc + 10
      default: return acc
    }
  }, 0);
}