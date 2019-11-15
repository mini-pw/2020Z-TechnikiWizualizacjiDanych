library(ggplot2)
library(data.table)

setwd("/home/jakubowskim/studia/semIII/twd/twd_git/2020Z-TechnikiWizualizacjiDanych/PraceDomowe/TYDZIEN2/JakubowskiMikolaj")
match_data <- read.csv("data.csv")

#death/kill plot
ggplot(match_data, aes(x = Kills, y = Deaths, label = Player, color = Team)) +
  scale_y_continuous(trans = "reverse") +
  geom_point(size = 3) +
  geom_text_repel(size = 5, force = 1, color = "black") 

#obliczenie k/d i dodanie do ramki
kd_ratio <- match_data$Kills/match_data$Deaths
match_data <- cbind(match_data, kd_ratio)

#k/d plot

ggplot(match_data, aes(x = Player, y = kd_ratio, fill = Team)) +
  geom_bar(stat = "identity")
