

merge <- read.csv("1Merge100000size.csv", header=TRUE)

attach(merge)


a <- seq(1:100)

c <- seq(1:100)


png("graph1Merge100000sizelegend.csv.png")


plot(merge_size, merge_time, main = "Merge Sort on a large array", xlab="Array Size", ylab="Time Taken (ns)")


#logFunction <-function(a){
#	a = a * log(a) * 13
#}

#points(a, logFunction(c), col = "red")

#legend(0, 6000, c("Merge Sort", "n log(n) curve"), lty=c(1,1), lwd=c(2.5,2.5), col= c("black", "red"))



#logFunction <-function(x){
#	x = x * log(x) * 0.35
#}

#lines(merge_size, logFunction(merge_time), col="red")






