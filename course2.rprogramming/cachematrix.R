## This R script includes two functions, 'makeCacheMatrix' and 'cacheSolve'.

## makeCacheMatrix creates a special "matrix" object that can cache its inverse.
makeCacheMatrix <- function(mat = matrix()) {
	mat.inv <- NULL
	set <- function(mat.new) {
		mat <<- mat.new
		mat.inv <<- NULL
	}
	get <- function() mat
	setinv <- function(inv) mat.inv <<- inv
	getinv <- function() mat.inv
	list(set = set, get = get, setinv = setinv, getinv = getinv)
}



## cacheSolve computes the inverse of the special "matrix" returned by makeCacheMatrix above.
cacheSolve <- function(x, ...) {
	mat.inv <- x$getinv()
	if(!is.null(mat.inv)) {
		message("getting cached data")
		return(mat.inv)
	}
	mat <- x$get()
	mat.inv <- solve(mat, ...)
	x$setinv(mat.inv)
	mat.inv
}
