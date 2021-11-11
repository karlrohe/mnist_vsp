# thank you brendano on github!

# I fiddled with this code:
# source("https://gist.githubusercontent.com/brendano/39760/raw/22467aa8a5d104add5e861ce91ff5652c6b271b6/gistfile1.txt")

show_digit <- function(arr784, col=gray(12:1/12), ...) {
  image((matrix(as.vector(as.numeric(arr784)[1:784]), nrow=28)[,28:1]), col=col, ...)
}
