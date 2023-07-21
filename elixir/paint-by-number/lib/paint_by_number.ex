defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    color_count
    |> :math.log2()
    |> ceil()
  end

  def empty_picture() do
    <<>>
  end

  def test_picture() do
    <<0::2, 1::2, 2::2, 3::2>>
  end

  def prepend_pixel(picture, color_count, pixel_color_index) do
    palette = palette_bit_size(color_count)

    <<pixel_color_index::size(palette), picture::bitstring>>
  end

  def get_first_pixel(<<>>, _color_count), do: nil

  def get_first_pixel(picture, color_count) do
    palette = palette_bit_size(color_count)

    <<pixel::size(palette), _rest::bitstring>> = picture
    pixel
  end

  def drop_first_pixel(<<>>, _color_count), do: empty_picture()

  def drop_first_pixel(picture, color_count) do
    palette = palette_bit_size(color_count)

    <<_pixel::size(palette), picture::bitstring>> = picture
    picture
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
