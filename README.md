# This is an experiment in concurrent CSV processing.

Languages used as parts of the experiment:

- Scala
- Awk
- Ruby

## Results

Using a 10m-row CSV with 10 columns

### Scala

#### Syncronous

35.01s user 26.76s system 101% cpu 1:00.62 total

#### Actors

622.32s user 82.93s system 428% cpu 2:44.74 total

#### Parallel collections

150.46s user 60.63s system 225% cpu 1:33.71 total

### Awk

#### gawk - GNU Awk 4.1.3, API: 1.1

26.24s user 0.77s system 99% cpu 27.246 total

#### awk - awk version 20070501

48.33s user 0.93s system 99% cpu 49.638 total


