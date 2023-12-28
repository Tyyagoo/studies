class SimpleCipher
  getter key : String
  def initialize(@key) end
  def initialize; @key = Array.new(100, 'a').map{|c| c + rand(26)}.join; end
  def encode(text : String); shift(text, ->(x : Int32, y : Int32) { x + y }); end
  def decode(text : String); shift(text, ->(x : Int32, y : Int32) { x - y }); end

  private def shift(text : String, f : (Int32, Int32) -> Int32 )
    text.chars.map_with_index do |char, index|
      offset = @key[index % @key.size].ord - 'a'.ord
      (f.call(char.ord - 'a'.ord, offset) % 26 + 'a'.ord).chr
    end.join
  end
end
