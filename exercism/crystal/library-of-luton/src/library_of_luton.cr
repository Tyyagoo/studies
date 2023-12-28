class Library
  def self.first_letter(title : String) : Char
    title[0]
  end

  def self.initials(first_name : String, last_name : String) : String
    "#{first_name[0]}.#{last_name[0]}"
  end

  def self.decrypt_character(char : Char) : Char
    if char >= 'a' && char <= 'z'
      ((char.ord - 'a'.ord + 25) % 26 + 'a'.ord).chr
    elsif char >= 'A' && char <= 'Z'
      ((char.ord - 'A'.ord + 25) % 26 + 'A'.ord).chr
    else
      char
    end
  end

  def self.decrypt_text(text : String) : String
    text.chars.map { |c| decrypt_character(c) }.join
  end
end
