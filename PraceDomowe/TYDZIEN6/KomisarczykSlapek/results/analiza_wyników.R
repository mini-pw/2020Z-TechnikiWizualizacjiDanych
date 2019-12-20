library(dplyr)
library(ggplot2)

wyniki <- read.csv(file = "wyniki.csv")

poprawne <- c("nie", "Litwa, Szwecja", "2", "2", "Litwa", "2", "3", "Szwecja", "Belgia, Hiszpania", "2")


an_pytanie <- function(nr, typ, wykres) {
  data.frame(nr_pytania = nr, typ_pytania = typ, wykres = wykres, 
             procent_poprawnych_odpowiedzi = mean(wyniki[[nr]] == poprawne[nr - 1]))
}

poprawne <- an_pytanie(3, "rownolicznosc", "słupkowy") %>% 
  rbind(an_pytanie(4, "porzadek", "słupkowy")) %>% 
  rbind(an_pytanie(5, "stosunek", "słupkowy")) %>% 
  rbind(an_pytanie(6, "porzadek", "kołowy")) %>% 
  rbind(an_pytanie(7, "rownolicznosc", "kołowy")) %>% 
  rbind(an_pytanie(8, "stosunek", "kołowy")) %>% 
  rbind(an_pytanie(9, "porzadek", "waflowy")) %>% 
  rbind(an_pytanie(10, "rownolicznosc", "waflowy")) %>% 
  rbind(an_pytanie(11, "stosunek", "waflowy"))

ggplot(poprawne, aes(x = nr_pytania, y = procent_poprawnych_odpowiedzi, fill = wykres)) +
  geom_bar(stat = "identity")

poprawne[1:9, ]
