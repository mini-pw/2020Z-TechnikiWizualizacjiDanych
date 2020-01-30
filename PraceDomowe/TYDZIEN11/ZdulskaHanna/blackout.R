library(visNetwork)
library(dplyr)

get_M <- function(filename = "us_power.csv", lim = 100){
  M <- read.csv(filename, sep= " ", header = FALSE) # US-power-grid
  colnames(M) <- c('from', 'to')
  
  M2 <- M %>% filter(from <= lim & to <= lim)
  
  return(M2)
}

get_A <- function(M2, lim = 100){
  A <- matrix(rep(0, lim**2), nrow = lim)
  
  for(i in 1:dim(M2)[1]){
    A[M2[i,1], M2[i,2]] = 1
  }
  
  Matrix::t(A) + A -> A
  A %>% as.logical() %>% as.numeric() %>% as.matrix() -> A
  
  dim(A) <- c(lim,lim)
  return(A)
}

get_neighbours <- function(A){
  nei <- list()
  
  for(i in 1:dim(A)[1]){
    n <-  which(A[i,] == 1)
    if(length(n) == 0 ){
      n <- NULL
    }
    nei[[i]] <- n
  }
  
  return(nei)
}

get_neighbours_wrapped <- function(filename = "us_power.csv", lim = 100){
  M <- get_M(filename, lim)
  A <- get_A(M, lim)
  n <- get_neighbours(A)
  return(n)
}

get_degs <- function(A){
  degs <- Matrix::rowSums(A)
  return(degs)
}

get_m <- function(filename = "us_power.csv", lim = 100){
  M <- get_M(filename, lim)
  A <- get_A(M, lim)
  degs <- get_degs(A)
  
  m <- as.data.frame(cbind(p = (degs+1)**2, is_active = TRUE, capacity = (degs+1)**2 + degs))
  
  return(m)
}

destab <- function(m2, v0, nei){
  
  m2[v0, "is_active"] <- FALSE 
  
  active_nei <- 0
  for(vi in nei[[v0]]){
    if(m2[vi, "is_active"] == TRUE){
      active_nei <- active_nei + 1
    }
  }
  
  if(active_nei == 0){
    return(m2)
  }
  
  power_transfer <- m2[v0, "p"] / active_nei
  cat()
  for(vn in nei[[v0]]){
    if(m2[vn, "is_active"] == TRUE){
      m2[vn, "p"] <- m2[vn, "p"] +  power_transfer
      if(m2[vn, "p"] > m2[vn, "capacity"]){
        #cat(vn)
        #cat(" ")
        m2 <- destab(m2,vn,nei)
      }
    }
  }
  return(m2)
}
