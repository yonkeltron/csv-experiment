defmodule Csv do
  @moduledoc "Main module for CSV experiment in Elixir"

  require Logger

  @doc "Kick things off!"
  def main(args \\ []) do
    {:ok, opts} = parse_options(args)

    if File.exists?(opts[:file]) do
      case opts[:mode] do
        "sync" -> do_sync(opts[:file])
        "async" -> do_async(opts[:file])
        "flow" -> do_flow(opts[:file])
        mode -> Logger.error("Unknown mode: #{mode}")
      end
    else
      Logger.error("File #{opts[:file]} does not exist!")
    end
  end

  @spec do_async(String.t()) :: :ok
  defp do_async(filename) do
    filename
    |> make_stream()
    |> Task.async_stream(fn raw_line ->
      line = raw_line |> String.trim()
      handle_line(line)
    end)
    |> Enum.each(fn {:ok, line} -> IO.puts(line) end)
  end

  @spec do_flow(String.t()) :: :ok
  defp do_flow(filename) do
    filename
    |> make_stream()
    |> Flow.from_enumerable()
    |> Flow.map(& String.trim/1)
    |> Flow.map(& handle_line(&1))
    |> Enum.each(& IO.puts/1)
  end

  @spec do_sync(String.t()) :: :ok
  defp do_sync(filename) do
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

  @spec parse_options([String.t()]) :: {atom(), list()}
  defp parse_options(raw_opts) do
    {parsed, _argv, errors} = OptionParser.parse(raw_opts, switches: [file: :string, mode: :string])

    if Enum.count(errors) == 0 do
      {:ok, parsed}
    else
      {:error, errors}
    end
  end

  @spec make_stream(String.t()) :: File.Stream.t()
  defp make_stream(filename) do
    filename |> File.stream!(read_ahead: 100_000)
  end
end
