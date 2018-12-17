
## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function

makeCacheMatrix <- function(x = matrix()) {
        inv <- NULL
        set <- function(y) {
                x <<- y
                inv <<- NULL
        }
        get <- function() x
        setinversion <- function(solve) inv <<- solve
        getinversion <- function() inv
        list(set = set, get = get,
             setinversion = setinversion,
             getinversion = getinversion)
}



## Write a short comment describing this function

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
         inv <- x$getinversion()
         if(!is.null(inv)) {
                 message("getting cached data")
                 return(inv)
         }
         data <- x$get()
         inv <- solve(data, ...)
         x$setinversion(inv)
         inv
}
