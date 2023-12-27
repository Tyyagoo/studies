export class Triangle {
  isEquilateral: boolean
  isIsosceles: boolean
  isScalene: boolean
  constructor(...sides: number[]) {
    const [a, b, c] = sides.sort();
    const inequality = c > a + b;

    this.isEquilateral = !inequality && (a == b && a == c) && c != 0;
    this.isIsosceles = !inequality && (a == b || a == c || b == c) && a != 0;
    this.isScalene = !inequality && (a != b && a != c && b != c) && a != 0;
  }
}
