
## With these 2 functions you can make an object of a certain matrix 
## and get the cached version 

## with this function we make an object of a certain matrix x where we 
## also make the inversion 

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



## In this function we check if the inversion is already cached, if so 
## then get it, if not then calculate it by the makeCacheMatrix function

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
