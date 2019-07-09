bubble <- read.csv("10milBubble100ksize.csv", header=TRUE)

attach(bubble)

insertion <- read.csv("insertion.csv", header=TRUE)

attach(insertion)


png("graph1milBubblevsInsertion100legendsize.png")


plot(bubble_size, bubble_time, col="red", main="Bubble Sort vs Insertion Sort", xlab="Array Size", ylab="Time Taken (ns)")
points(insertion_size, insertion_time, col="blue")


legend(0, 15000, c("Bubble Sort", "Insertion Sort"), lty=c(1,1), lwd=c(2.5,2.5), col= c("red", "blue"))
