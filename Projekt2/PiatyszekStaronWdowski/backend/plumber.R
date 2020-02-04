library(dplyr)
library(tidyr)
library(httr)

tmdb_api_key <- 'TMDB_API_KEY'

movies_cast <- read.csv('./movies_cast.csv')
movies_genres <- read.csv('./movies_genres.csv')
cast_vote <- read.csv('./cast_vote.csv')
cast_genres_count <- read.csv('./cast_genres_count.csv')
cast_genres_timeseries <- read.csv('./cast_genres_timeseries.csv')
genres_list <- read.csv('./genres_list.csv')
movies_info <- read.csv('./movies_info.csv')
movies_cast$release_date <- as.Date(movies_cast$release_date)
movies_genres$release_date <- as.Date(movies_genres$release_date)

#* Return cast with summarise
#* @get /cast
function(){
  cast_vote
}

#* Return movies id,name list
#* @get /movie
function() {
  movies_info %>%
    select(id=movie_id, name=title)
}

#* Return movie poster url
#* @get /movie/<movieId>/poster
function(movieId) {
  if (is.na(as.numeric(movieId))) return(list())
  response <- GET(paste0('https://api.themoviedb.org/3/movie/', movieId, '?api_key=', tmdb_api_key))
  list(path=paste0('https://image.tmdb.org/t/p/w154', content(response)$poster_path)) 
}

#* Return actor photo
#' @serializer unboxedJSON
#* @get /cast/<actorId>/photo
function(actorId) {
  if (is.na(as.numeric(actorId))) return(list())
  response <- GET(paste0('https://api.themoviedb.org/3/person/', actorId, '/images?api_key=', tmdb_api_key))
  content(response)$profiles 
}

#* Return movie overview
#* @get /movie/<movieId>
function(movieId) {
  if (is.na(as.numeric(movieId))) return(list())
  movies_info %>%
    filter(movie_id == as.numeric(movieId))
}

#* Return movie overview
#* @get /movie/<movieId>/cast/<n>
function(movieId, n) {
  if (is.na(as.numeric(movieId))) return(list())
  movies_cast %>%
    filter(movie_id == as.numeric(movieId)) %>%
    arrange(order) %>%
    slice(1:as.numeric(n)) %>%
    select(name, id)
}

#* Return genres id,name list
#* @get /genre
function() {
  genres_list %>%
    select(id=genre_id, name=genre)
}

#* Return actor summarise
#* @get /cast/<actorId>
function(actorId) {
  cast_vote %>%
    filter(id == as.numeric(actorId)) %>%
    slice(1:1)
}

#* Return top n cast with summarise
#* @param n
#* @get /topcast
function(n) {
  n <- as.numeric(n)
  cast_vote %>% top_n(n, popularity_sum) %>% slice(1:n)
}

#' Return actor <param> over time
#' @get /cast/<actorId>/timeseries/<param>
function(actorId, param) {
  if (!(param %in% colnames(movies_cast))) {
    return(list())
  }
  movies_cast  %>%
    filter(id == as.numeric(actorId)) -> df
  df$param_value = df[,param]
  df$tdiff = as.numeric(df$release_date - min(df$release_date))
  sm <- loess(param_value ~ tdiff, data=df, span=0.9)
  newdata <- data.frame(tdiff=seq(from=0, to=max(df$tdiff), length.out=200))
  newdata$param_value <- predict(sm, newdata=newdata)
  sm_x <- min(df$release_date) + newdata$tdiff
  list(time=df$release_date, value=df$param_value, label=df$title, movieid=df$movie_id,
       smoothed=list(time=sm_x, value=newdata$param_value))
}

#' Return actor <param> over time
#' @get /genre/<genreId>/timeseries/<param>
ff <- function(genreId, param) {
  if (!(param %in% colnames(movies_genres))) {
    return(list())
  }
  movies_genres  %>%
    filter(genre_id == as.numeric(genreId)) -> df
  df$param_value = df[,param]
  df$tdiff = as.numeric(df$release_date - min(df$release_date))
  sm <- loess(param_value ~ tdiff, data=df, span=0.9)
  newdata <- data.frame(tdiff=seq(from=0, to=max(df$tdiff), length.out=200))
  newdata$param_value <- predict(sm, newdata=newdata)
  sm_x <- min(df$release_date) + newdata$tdiff
  list(time=df$release_date, value=df$param_value, label=df$title, movieid=df$movie_id,
       smoothed=list(time=sm_x, value=newdata$param_value))
}

#* Return actor genres summary
#* @get /cast/<actorId>/bars/genres
function(actorId) {
  cast_genres_count %>%
    filter(id==as.numeric(actorId)) %>%
    arrange(desc(n)) %>%
    select(genre, n) -> df
  list(name=df$genre, value=df$n)
}


#* Return actor genres grouped per year
#* @get /cast/<actorId>/yeartimeseries/genres
function(actorId) {
  cast_genres_timeseries %>%
    filter(id==as.numeric(actorId), n > 0) -> df
  gnames <- unique(as.character(df$genre))
  out <- lapply(gnames, function(gn) {
    df %>% filter(genre == gn) %>% arrange(year) -> df2
    smoothed <- list()
    if (nrow(df2) >= 2) {
      suppressWarnings({
        try({
          suppressWarnings({
          sm <- loess(freq ~ year, data=df2, span=0.9)
          newdata <- data.frame(year=seq(from=min(df2$year), to=max(df2$year), length.out=200))
          newdata$freq <- predict(sm, newdata=newdata)
          smoothed <- list(year=newdata$year, value=newdata$freq)
          })
        }, silent=T)
      })
    }
    list(year=df2$year, value=df2$freq, smoothed=smoothed)
  })
  names(out) <- gnames
  out
}

#* @filter cors
cors <- function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}
