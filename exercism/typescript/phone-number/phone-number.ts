export function clean(input: string): string {
  if (/[a-zA-Z]+/.test(input)) throw new Error("Letters not permitted");
  if (/[@:!]+/.test(input)) throw new Error("Punctuations not permitted");
  const cleaned = input.replaceAll(/[+().\-\s]/g, "");
  
  if (cleaned.length < 10)
    throw new Error("Incorrect number of digits");
  if (cleaned.length > 11)
    throw new Error('More than 11 digits')
  if (cleaned.length === 11 && cleaned[0] != "1")
    throw new Error('11 digits must start with 1');
  
  const number = cleaned.length == 11 ? cleaned.slice(1) : cleaned;
  if (number[0] == "0")
    throw new Error('Area code cannot start with zero');
  if (number[0] == "1")
    throw new Error('Area code cannot start with one');
  if (number[3] == "0")
    throw new Error('Exchange code cannot start with zero');
  if (number[3] == "1")
    throw new Error('Exchange code cannot start with one');

  return number;
}
