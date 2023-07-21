defmodule FileSniffer do
  @type_tuples_list [
    {"exe", "application/octet-stream", <<0x7F, 0x45, 0x4C, 0x46>>},
    {"bmp", "image/bmp", <<0x42, 0x4D>>},
    {"png", "image/png", <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>},
    {"jpg", "image/jpg", <<0xFF, 0xD8, 0xFF>>},
    {"gif", "image/gif", <<0x47, 0x49, 0x46>>}
  ]

  def type_from_extension(extension) do
    Enum.find_value(@type_tuples_list, fn {ext, type, _magic_number} ->
      (ext == extension && type) || nil
    end)
  end

  def type_from_binary(file_binary) do
    Enum.find_value(@type_tuples_list, fn {_ext, type, magic_number} ->
      (String.starts_with?(file_binary, magic_number) && type) || nil
    end)
  end

  def verify(file_binary, extension) do
    expected_type = type_from_extension(extension)
    magic_number_type = type_from_binary(file_binary)

    case expected_type == magic_number_type do
      true -> {:ok, magic_number_type}
      false -> {:error, "Warning, file format and file extension do not match."}
    end
  end
end
