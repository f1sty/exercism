defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, list, files, is_not \\ false)

  def grep(pattern, [], files, is_not) do
    filtered =
      files
      |> Stream.map(&File.stream!/1)
      |> Stream.flat_map(fn file ->
        file
        |> Enum.map(&{&1, file.path})
        |> Enum.filter(fn {line, _path} ->
          if is_not, do: not (line =~ pattern), else: line =~ pattern
        end)
      end)

    if length(files) > 1 do
      Enum.map_join(filtered, fn {match, path} -> "#{path}:#{match}" end)
    else
      Enum.map_join(filtered, fn {match, _path} -> "#{match}" end)
    end
  end

  def grep(pattern, flags, files, _is_not) do
    pattern = Regex.compile!(pattern)
    pattern = ("-x" in flags && entire_line(pattern)) || pattern
    pattern = ("-i" in flags && case_insensitive(pattern)) || pattern
    is_not = "-v" in flags

    cond do
      "-l" in flags ->
        files
        |> Stream.map(&File.stream!/1)
        |> Stream.filter(fn file ->
          file
          |> Enum.join()
          |> String.match?(pattern)
          |> then(fn matched? -> if is_not, do: not matched?, else: matched? end)
        end)
        |> Enum.map_join("\n", & &1.path)
        |> then(fn output -> if output == "", do: "", else: output <> "\n" end)

      "-n" in flags ->
        filtered =
          files
          |> Stream.map(&File.stream!/1)
          |> Stream.flat_map(fn file ->
            file
            |> Enum.with_index(1)
            |> Enum.map(&Tuple.append(&1, file.path))
            |> Enum.filter(fn {line, _index, _path} ->
              if is_not, do: not (line =~ pattern), else: line =~ pattern
            end)
          end)

        if length(files) > 1 do
          Enum.map_join(filtered, fn {match, line, path} -> "#{path}:#{line}:#{match}" end)
        else
          Enum.map_join(filtered, fn {match, line, _path} -> "#{line}:#{match}" end)
        end

      true ->
        grep(pattern, [], files, is_not)
    end
  end

  defp case_insensitive(pattern) do
    pattern
    |> Regex.source()
    |> Regex.compile!("i")
  end

  defp entire_line(pattern) do
    pattern
    |> Regex.source()
    |> then(fn source -> "^#{source}$" end)
    |> Regex.compile!()
  end
end
