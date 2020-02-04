movie_ravenue <- read.csv2("AllMoviesDetailsCleaned.csv")
movie_ravenue <- test
test1 <- test%>% filter(budget>0 )%>% filter(revenue>0)

write.csv2(test1,file = "data_layer1.csv")