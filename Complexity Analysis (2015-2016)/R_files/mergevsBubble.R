merge <- read.csv("10000Merge60sizereversed.csv", header=TRUE)

attach(merge)

bubble <- read.csv("10000Bubble60sizereversed.csv", header=TRUE)

attach(bubble)


png("graph10000MergevsBubble60legendsizereversed.png")


plot(bubble_size, bubble_time, col="blue", main="Merge Sort vs Bubble Sort on Reveresed Arrays", xlab="Array Size", ylab="Time Taken (ns)")
points(merge_size, merge_time, col="red")


legend(0, 5000, c("Merge Sort", "Bubble Sort"), lty=c(1,1), lwd=c(2.5,2.5), col= c("red", "blue"))
