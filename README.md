# An experiment in concurrent CSV processing.

I've been reading quite a bit about this idea that, for all of our fancy multi-threading and big data systems, sometimes the overhead introduced outstrips the potential performance gain. When is a single thread better than all the other fanciness? When does fancy concurrency triumph over a boring synchronous approach?

Let's do some work to find out.

## Tools

Languages used as parts of the experiment:

- Scala
- Awk
- Ruby (for generating fake data)
- Rust

## Results

Using a 5m-row CSV with 100 columns

```
==> awk (259.62 CPU seconds)
256.21s user 3.41s system 99% cpu 4:20.29 total

==> gawk (105.74s)
102.99s user 2.75s system 99% cpu 1:46.14 total

==> Synchronous Rust (108.06s)
99.54s user 8.52s system 99% cpu 1:48.48 total

==> Concurrent Rust (181.99s)
139.16s user 42.83s system 365% cpu 49.821 total

==> Synchronous Scala (111.26s)
96.31s user 17.95s system 101% cpu 1:52.27 total

==> Akka Actors (469.01s)
410.06s user 58.95s system 464% cpu 1:41.00 total

==> Akka Streams (233.26)
156.59s user 76.67s system 188% cpu 2:03.98 total

==> Scala Parallel collections (212.24s)
165.46s user 46.78s system 297% cpu 1:11.30 total
```

### Discussion

Each strategy handles each CSV line by splitting on commas, and doing two additional traversals of the row to add an "x" character to each element. Then, it rejoins the strings with commas and prints the new line to standard out.

So it maps `"a,b,c" -> "xax,xbx,xcx"` and so forth. As indicated above, the test CSV has 5 million rows each with 100 columns. Just random letters chosen `a-z` by the included Ruby script.

You find the real meat here when you measure the memory usage of each approach! The Rust approach may be as slow as the Akka Streams approach but it uses *far* less memory (under 1.5mb) and confines itself to one CPU core. Actors cause a veritable memory explosion and chew CPU worse than any other strategy.

### Observations, caveats and questions

* I am not sure the Akka Actor system implementation ever finishes computation before I shut down the actor system itself. This might be a bad implementation.

* The Awk code doesn't do the same traversal that the other ones do so don't consider it a fair comparison. I threw it there to make the point that you can find creative ways to accomplish different tasks. If I wanted to make this more than string formatting, I'd want to switch to something like computing the SHA256 of each CSV line or something.

* The Scala approach using parallel collections actually seem like an efficient one but it relies on loading the entire file into memory. If you have the memory to spare for loading large CSVs (in real life, some of these can exceed many gigabytes in size), good for you!

* Rust does a darn good job, whether sync or async.
