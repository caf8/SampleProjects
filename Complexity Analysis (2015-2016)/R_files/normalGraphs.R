

a <- seq(1:100)

c <- seq(1:100)


logFunction <-function(a){
	a = a * log(a)
}


quadFunction <-function(b){
	a = a * a
}

png("graphnormallegend.png")





plot(a, quadFunction(c), col = "blue", main = "Quadtratic Curve vs n log(n) Curve", xlab="X", ylab="Y")

points(a, logFunction(c), col = "red")

legend(0, 10000, c("Quadratic Line", "n log(n) Line"), lty=c(1,1), lwd=c(2.5,2.5), col= c("blue", "red"))
