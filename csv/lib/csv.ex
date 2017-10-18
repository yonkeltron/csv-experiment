defmodule Csv do
  @moduledoc "Main module for CSV experiment in Elixir"

  require Logger

  @doc "Kick things off!"
  def main(args \\ []) do
    {:ok, opts} = parse_options(args)

    if File.exists?(opts[:file]) do
      case opts[:mode] do
        "sync" -> Csv.Processor.do_sync(opts[:file])
        "async" -> Csv.Processor.do_async(opts[:file])
        "flow" -> Csv.Processor.do_flow(opts[:file])
        mode -> Logger.error("Unknown mode: #{mode}")
      end
    else
      Logger.error("File #{opts[:file]} does not exist!")
    end
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
end
