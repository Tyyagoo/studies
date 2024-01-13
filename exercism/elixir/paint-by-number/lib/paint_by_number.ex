defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    :math.log2(color_count) |> ceil
  end

  def empty_picture(), do: <<>>

  def test_picture(), do: <<0::2, 1::2, 2::2, 3::2>>

  def prepend_pixel(picture, color_count, pixel_color_index) do
    s = palette_bit_size(color_count)
    <<pixel_color_index::size(s), picture::bitstring>>
  end

  def get_first_pixel(<<>>, _), do: nil

  def get_first_pixel(picture, color_count) do
    s = palette_bit_size(color_count)
    <<color::size(s), _::bitstring>> = picture
    color
  end

  def drop_first_pixel(<<>>, _), do: empty_picture()

  def drop_first_pixel(picture, color_count) do
    s = palette_bit_size(color_count)
    <<_::size(s), rest::bitstring>> = picture
    rest
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
