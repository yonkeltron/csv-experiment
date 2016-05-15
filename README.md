# This is an experiment in concurrent CSV processing.

Languages used as parts of the experiment:

- Scala
- Awk
- Ruby

## Results

Using a 5m-row CSV with 100 columns

```
==> Synchronous
96.31s user 17.95s system 101% cpu 1:52.27 total

==> Akka Actors
410.06s user 58.95s system 464% cpu 1:41.00 total

==> Scala Parallel collections
165.46s user 46.78s system 297% cpu 1:11.30 total

==> Akka Streams
156.59s user 76.67s system 188% cpu 2:03.98 total
```

<!-- ### Awk -->

<!-- #### gawk - GNU Awk 4.1.3, API: 1.1 -->

<!-- 26.24s user 0.77s system 99% cpu 27.246 total -->

<!-- #### awk - awk version 20070501 -->

<!-- 48.33s user 0.93s system 99% cpu 49.638 total -->


