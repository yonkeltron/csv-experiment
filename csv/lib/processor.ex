defmodule Csv.Processor do
  @moduledoc "Implementation of strategies for CSV experiment"

  @doc "Async processing of CSV files with `Task.async_stream`"
  @spec do_async(String.t()) :: :ok
  def do_async(filename) do
    filename
    |> make_stream()
    |> Task.async_stream(fn raw_line ->
      line = raw_line |> String.trim()
      handle_line(line)
    end)
    |> Enum.each(fn {:ok, line} -> IO.puts(line) end)
  end

  @doc "Stream processing of CSV files with `Flow`"
  @spec do_flow(String.t()) :: :ok
  def do_flow(filename) do
    filename
    |> make_stream()
    |> Flow.from_enumerable()
    |> Flow.map(& String.trim/1)
    |> Flow.map(& handle_line(&1))
    |> Enum.each(& IO.puts/1)
  end

  @doc "Synchronous processing of CSV files `Stream` and `Enum`"
  @spec do_sync(String.t()) :: :ok
  def do_sync(filename) do
    filename
    |> make_stream()
    |> Stream.map(& String.trim/1)
    |> Stream.map(& handle_line(&1))
    |> Enum.each(& IO.puts/1)
  end

  @spec handle_line(String.t()) :: iolist()
  defp handle_line(line) do
    line
    |> String.split(",")
    |> Enum.map(& "x#{&1}")
    |> Enum.map(& "#{&1}x")
    |> Enum.intersperse(",")
  end

  @spec make_stream(String.t()) :: File.Stream.t()
  defp make_stream(filename) do
    filename |> File.stream!(read_ahead: 100_000)
  end
end
