mergeR <- read.csv("100000Merge60sizereversed.csv", header=TRUE)

attach(mergeR)

merge <- read.csv("10milMerge100size.csv", header=TRUE)

attach(merge)

png("graphmergevsmergereversed.png")

plot(merge_size1, merge_time1, col="blue", main = "Megre Sort vs Merge Sort on reversed list", xlab="Array Size", ylab="Time Taken (ns)")

points (merge_size, merge_time, col = "red")

legend(0, 15000, c("Merge Sort", "Merge Sort on reversed list"), lty=c(1,1), lwd=c(2.5,2.5), col= c("red", "blue"))
