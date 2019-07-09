insertion <- read.csv("10000insertion10000size.csv", header = TRUE)

attach(insertion)

png("graph10000insertion10000.png")

plot(insertion_size, insertion_time, main = "Insertion Sort", xlab="Array Size", ylab="Time Taken (ns)")
