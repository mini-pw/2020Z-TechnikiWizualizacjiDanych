generateFractal <- function(n, b){
  x <- 0
  y <- 0
  xlist <- as.list(x)
  ylist <- as.list(y)
  Z <- list(xlist, ylist)

  # losuje liczbe calkowita z przedzialu od 0-1
  # jesli wylosuje liczbe z przedzialu [0-0.32] to wylosowano 1. przeksztalcenie
  # jesli wylosuje liczbe z przedzialu (0.32-0.64] to wylosowano 2. przeksztalcenie
  # jesli wylosuje liczbe z przedzialu (0.64-0.96] to wylosowano 3. przeksztalcenie
  # jesli wylosuje liczbe z przedzialu (0.96-1], to wylosowano 4. przeksztalcenie
  
  for (i in 2:n) {
    rand <- runif(1, min = 0, max = 1)
    if (rand <= 0.32){
      x = -0.67*Z[[1]][[i-1]]-0.02*Z[[2]][[i-1]]
      y = -0.18*Z[[1]][[i-1]]+0.81*Z[[2]][[i-1]]+10
    }
    else if (rand > 0.32 & rand <= 0.64){
      x = 0.4*Z[[1]][[i-1]]+0.4*Z[[2]][[i-1]]
      y = -0.1*Z[[1]][[i-1]]+0.4*Z[[2]][[i-1]]
    }
    else if (rand > 0.64 & rand <= 0.96){
      x = -0.4*Z[[1]][[i-1]]-0.4*Z[[2]][[i-1]]
      y = -0.1*Z[[1]][[i-1]]+0.4*Z[[2]][[i-1]]
    }
    else{
      x = 0.1*Z[[1]][[i-1]]
      y = 0.44*Z[[1]][[i-1]]+0.44*Z[[2]][[i-1]]-2
    }
    
    Z[[1]][[i]] <- x
    Z[[2]][[i]] <- y
    
  }
  xmin <- min(unlist(Z[[1]]))
  xmax <- max(unlist(Z[[1]]))
  ymin <- min(unlist(Z[[2]]))
  ymax <- max(unlist(Z[[2]]))
  
  for (i in 1:n) {
    Z[[1]][[i]] <- (Z[[1]][[i]] + abs(xmin))/(abs(xmin) + xmax) # lista [x_0, x_1, ...] wspolrzednych x-owych punktow (x_i, y_i)
    Z[[2]][[i]] <- (Z[[2]][[i]] + abs(ymin))/(abs(ymin) + ymax) # lista [y_0, y_1, ...] wspolrzednych y-owych punktow (x_i, y_i)
  }
  
  colors <-  rep("green", n)
  size <- rep(1, n)
  baubles <- sample(seq(0, n), size = b)
  colors[baubles] <- "red"
  size[baubles] <- 5
  
  Z <- as.data.frame(cbind(Z[[1]], Z[[2]], colors, size))
  return(Z)
}