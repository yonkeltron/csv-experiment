# This is an experiment in concurrent CSV processing.

Languages used as parts of the experiment:

- Scala
- Awk
- Ruby

## Results

Using a 5m-row CSV with 100 columns

```
==> awk
cat char_sequences.csv  0.03s user 0.48s system 0% cpu 4:20.26 total
/usr/bin/awk -f process.awk > panda.csv  256.21s user 3.41s system 99% cpu 4:20.29 total

==> gawk
cat char_sequences.csv  0.02s user 0.46s system 0% cpu 1:46.12 total
gawk -f process.awk > panda.csv  102.99s user 2.75s

==> Synchronous
96.31s user 17.95s system 101% cpu 1:52.27 total

==> Akka Actors
410.06s user 58.95s system 464% cpu 1:41.00 total

==> Scala Parallel collections
165.46s user 46.78s system 297% cpu 1:11.30 total

==> Akka Streams
156.59s user 76.67s system 188% cpu 2:03.98 total
```
