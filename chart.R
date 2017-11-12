message("Loading libraries...")
library(ggplot2)

message("Constructing wall stats table...")

tobs <- data.frame(method = c("Rust Sync", "Rust Concur", "Scala Sync", "Scala PC", "Akka Streams"),
                   times = c(60 + 48.48,    49.821,        60 + 52.27,   120 + 3.98, 60 + 11.3))

message("Rendering wall chart...")
pdf("doc/images/summary-wall.pdf")

ggplot(tobs, aes(method, times)) +
    geom_bar(stat = "identity") +
    xlab("Method") +
    ylab("Time (seconds)") +
    ggtitle("Processing Strategy Wall Times")

dev.off()

message("Done.")

message("Constructing CPU stats table...")

wobs <- data.frame(method = c("Rust Sync", "Rust Concur", "Scala Sync", "Scala PC", "Akka Streams"),
                   times = c(108.06, 181.99, 111.26, 212.24, 233.26))


message("Rendering CPU chart...")
pdf("doc/images/summary-cpu.pdf")

ggplot(wobs, aes(method, times)) +
    geom_bar(stat = "identity") +
    xlab("Method") +
    ylab("Time (seconds)") +
    ggtitle("Processing Strategy CPU Times")

dev.off()

message("Done.")
