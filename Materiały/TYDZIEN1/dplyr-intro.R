install.packages("dplyr")
install.packages("tidyverse")
library(dplyr)

iris %>%  
  group_by(Species) %>% 
  summarise(n = length(Species),
            mean = mean(Sepal.Length))

iris %>% 
  mutate(norm_sepal = Sepal.Length/max(Sepal.Length))

iris %>% 
  group_by(Species) %>% 
  mutate(norm_sepal = Sepal.Length/max(Sepal.Length)) %>% 
  data.frame()

iris %>% 
  mutate(nowa_kolumna = "string",
         nowa_kolumna2 = Sepal.Length^2)

iris %>% 
  filter(Sepal.Length > 6.1)

means <- iris %>% 
  filter(Species == "versicolor" | Sepal.Length > 6.1) %>% 
  summarise(mean_length = mean(Sepal.Length),
            mean_width = mean(Sepal.Width))

iris %>% 
  filter(Species == "versicolor" & Sepal.Length > 4 & Sepal.Length < 5)