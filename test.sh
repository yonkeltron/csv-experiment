#!/usr/bin/env bash

echo
echo '==> Synchronous'
time java -jar ./target/scala-2.11/CSV\ Handler-assembly-1.0.jar -m 'sync' -i char_sequences.csv > panda.csv
echo
echo '==> Akka Actors'
time java -jar ./target/scala-2.11/CSV\ Handler-assembly-1.0.jar -m 'actor' -i char_sequences.csv > panda.csv
echo
echo '==> Scala Parallel collections'
time java -jar ./target/scala-2.11/CSV\ Handler-assembly-1.0.jar -m 'pc' -i char_sequences.csv > panda.csv
echo
echo '==> Akka Streams'
time java -jar ./target/scala-2.11/CSV\ Handler-assembly-1.0.jar -m 'stream' -i char_sequences.csv > panda.csv
echo
echo
