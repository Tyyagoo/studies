export class Anagram {
  readonly word: string
  readonly lowercased: string
  readonly letters: string
  constructor(input: string) {
    this.word = input;
    this.lowercased = input.toLowerCase();
    this.letters = [...this.lowercased].sort().toString();
  }

  public matches(...potentials: string[]): string[] {
    return potentials.filter(w => w.toLowerCase() != this.lowercased &&
                              [...w.toLowerCase()].sort().toString() == this.letters);
  }
}
