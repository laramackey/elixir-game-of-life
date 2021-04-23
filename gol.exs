defmodule GameOfLife do
    def next_generation_result(current_value, neighbours) do
        cond do
            current_value === "*" and neighbours < 2 ->
                "."
            current_value === "*" and neighbours > 3 ->
                "."
            current_value === "." and neighbours === 3 ->
                "*"
            true ->
                current_value
        end
    end
    def count_neighbours(col_idx, row_idx, input_list) do
        count = 0
        # Next door neighbours
        count = if row_idx > 0 and Enum.at(Enum.at(input_list, row_idx - 1), col_idx) === "*", do: count + 1, else: count
        count = if row_idx < 3 and Enum.at(Enum.at(input_list, row_idx + 1), col_idx) === "*", do: count + 1, else: count
        count = if col_idx > 0 and Enum.at(Enum.at(input_list, row_idx ), col_idx - 1) === "*", do: count + 1, else: count
        count = if col_idx < 7 and Enum.at(Enum.at(input_list, row_idx ), col_idx + 1) === "*", do: count + 1, else: count
        # Diagonal neighbours
        count = if row_idx > 0 and col_idx > 0 and Enum.at(Enum.at(input_list, row_idx - 1), col_idx - 1) === "*", do: count + 1, else: count
        count = if row_idx > 0 and col_idx < 7 and Enum.at(Enum.at(input_list, row_idx - 1), col_idx + 1) === "*", do: count + 1, else: count
        count = if row_idx < 3 and col_idx > 0 and Enum.at(Enum.at(input_list, row_idx + 1 ), col_idx - 1) === "*", do: count + 1, else: count
        count = if row_idx < 3 and col_idx < 7 and Enum.at(Enum.at(input_list, row_idx + 1 ), col_idx + 1) === "*", do: count + 1, else: count
    end
    def output_row_result(row_string, row_idx, input_list) do
        output_row = row_string
            |> Enum.with_index()
            |> Enum.map(fn {e, col_idx} -> next_generation_result(e, count_neighbours(col_idx, row_idx, input_list)) end)
        Enum.join(output_row) <> "\n"
    end
end

{:ok, body} = File.read("input.txt")
input_list = for n <- String.split(body), do: String.split(n, "", trim: true)
output = input_list
    |> Enum.with_index()
    |> Enum.map(fn {e, row_idx} -> GameOfLife.output_row_result(e, row_idx, input_list) end)

{:ok, output_file} = File.open("output.txt", [:write])
IO.binwrite(output_file, Enum.join(output))
