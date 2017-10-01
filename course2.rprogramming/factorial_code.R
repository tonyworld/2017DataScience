Factorial_loop <- function(x) {
	# compute the factorial of an integer using looping
	if (x < 0) {
		stop("x must be an integar > 0")
	} else if (x == 0) {
		return(1)
	} else {
		factorial <- 1
		for (i in x:1) {
			factorial <- factorial*i
		}
		return(factorial)
	}
}

Factorial_reduce <- function(x) {
	# compute the factorial using the base::Reduce() function
	if (x < 0) {
		stop("x must be an integar > 0")
	} else if (x == 0) {
		return(1)
	} else {
		return(Reduce("*", x:1))
	}
}

Factorial_func <- function(x) {
	# use recursion to compute the factorial
	if (x < 0) {
		stop("x must be an integar > 0")
	} else if (x == 0) {
		return(1)
	} else {
		return(x * Factorial_func(x - 1))
	}
}

factorials <- 1
Factorial_mem <- function(x) {
	# use memoization to compute the factorial
	if (x < 0) {
		stop("x must be an integar > 0")
	} else if (x == 0) {
		return(1)
	} else if (!is.na(factorials[x])) {
		return(factorials[x])
	} else {
		factorials[x] <<- x * Factorial_mem(x-1)
		return(factorials[x])
	}
}
