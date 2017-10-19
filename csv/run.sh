#!/usr/bin/env bash

set -e

mix local.hex --force
mix deps.get

mix run lib/tasks/cli.exs --file ../char_sequences.csv --mode sync > ../panda.csv
