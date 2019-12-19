# potrzebne pakiety
library(ggplot2)
library(gridExtra)
library(svglite)

# przygotowanie danych
## dziewczynki
girls = data.frame(cbind(c("1. Zuzanna", "2. Julia", "3. Maja", "4. Zofia", "5. Hanna",
                           "6. Lena", "7. Maria", "8. Alicja", "9. Amelia", "10. Oliwia"),
                         c(4251, 4042, 3853, 3755, 3651,
                           3495, 2572, 2546, 2339, 2306)))
colnames(girls) = c("name", "nOfGiven")

girls$nOfGiven <- as.numeric(levels(girls$nOfGiven))[girls$nOfGiven]
girls$name <- factor(girls$name, levels = girls$name)

## chłopcy
boys = data.frame(cbind(c("1. Antoni", "2. Jakub", "3. Jan", "4. Szymon", "5. Aleksander",
                          "6. Franciszek", "7. Filip", "8. Wojciech", "9. Mikołaj", "10. Kacper"),
                        c(4247, 4050, 3979, 3584, 3582,
                          3340, 2996, 2770, 2685, 2429)))
colnames(boys) = c("name", "nOfGiven")

boys$nOfGiven <- as.numeric(levels(boys$nOfGiven))[boys$nOfGiven]
boys$name <- factor(boys$name, levels = boys$name)

# podwykresy
boysPlot <- ggplot(data = boys, aes(x = name, y = nOfGiven)) +
  geom_col(fill = "lightblue") +
  coord_cartesian(ylim = c(0, 4500)) +
  scale_y_continuous(breaks = seq(0, 4500, 1500)) +
  xlab("Chłopięce") +
  ylab("Liczba nadań") +
  theme(axis.text.x = element_text(angle = 15, size = 10, vjust = 0.7))

girlsPlot <- ggplot(data = girls, aes(x = name, y = nOfGiven)) +
  geom_col(fill = "pink") +
  coord_cartesian(ylim = c(900, 4500)) +
  scale_y_continuous(breaks = seq(0, 4500, 1500)) +
  xlab("Dziewczęce") +
  ylab("Liczba nadań") +
  theme(axis.text.x = element_text(angle = 15, size = 10, vjust = 0.7))

# cały wykres

top10beforeCorrection <- grid.arrange(girlsPlot, boysPlot, nrow = 2,
             top = "TOP 10 imion w I połowie 2019")
