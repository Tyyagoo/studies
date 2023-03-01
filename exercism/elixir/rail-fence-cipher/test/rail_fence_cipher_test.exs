defmodule RailFenceCipherTest do
  use ExUnit.Case

  describe "encode" do
    test "encode with ending at the first rail" do
      assert RailFenceCipher.encode("XOXOXOXOXOXOXOXOXO", 2) == "XXXXXXXXXOOOOOOOOO"
    end

    test "encode with three rails" do
      msg = "WEAREDISCOVEREDFLEEATONCE"
      assert RailFenceCipher.encode(msg, 3) == "WECRLTEERDSOEEFEAOCAIVDEN"
    end

    test "encode with ending in the middle" do
      msg = "EXERCISES"
      assert RailFenceCipher.encode(msg, 4) == "ESXIEECSR"
    end

    test "encode empty string" do
      assert RailFenceCipher.encode("", 4) == ""
    end

    test "encode a more diverse text" do
      msg = "The quick brown fox jumps over the lazy dog."
      cipher = "Tioxs aghucrwo p rtlzo.eqkbnfjmoeh yd   uve "
      assert RailFenceCipher.encode(msg, 4) == cipher
    end

    test "encode with one rail" do
      msg = "One rail, only one rail"
      assert RailFenceCipher.encode(msg, 1) == msg
    end

    test "encode letters of less than rails" do
      msg = "More rails than letters"
      assert RailFenceCipher.encode(msg, 24) == msg
    end
  end

  describe "decode" do
    test "decode with three rails" do
      cipher = "TEITELHDVLSNHDTISEIIEA"
      assert RailFenceCipher.decode(cipher, 3) == "THEDEVILISINTHEDETAILS"
    end

    test "decode with five rails" do
      cipher = "EIEXMSMESAORIWSCE"
      assert RailFenceCipher.decode(cipher, 5) == "EXERCISMISAWESOME"
    end

    test "decode with six rails" do
      cipher = "133714114238148966225439541018335470986172518171757571896261"

      assert RailFenceCipher.decode(cipher, 6) ==
               "112358132134558914423337761098715972584418167651094617711286"
    end

    test "decode empty string" do
      assert RailFenceCipher.decode("", 4) == ""
    end

    test "decode with one rail" do
      assert RailFenceCipher.decode("ABCDEFGHIJKLMNOP", 1) == "ABCDEFGHIJKLMNOP"
    end

    test "decode letters of less than rails" do
      assert RailFenceCipher.decode("More rails than letters", 24) == "More rails than letters"
    end

    test "decode a more diverse text" do
      msg = "The quick brown fox jumps over the lazy dog."
      cipher = RailFenceCipher.encode(msg, 4)
      assert RailFenceCipher.decode(cipher, 4) == msg
    end
  end
end
