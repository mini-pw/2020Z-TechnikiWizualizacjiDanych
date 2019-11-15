<<<<<<< HEAD


=======
>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
library(ggplot2)
library(SmarterPoland)
library(dplyr)

<<<<<<< HEAD
=======
ggplot(countries, aes(x = continent, label = paste(continent, 2, sep = "\n"))) +
  geom_bar() +
  geom_text(stat = "count")

>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
# 1. skale -----------------------------------------------------------------

p <- ggplot(data = countries, aes(x = continent, fill = continent)) +
  geom_bar()

p + scale_x_discrete(position = "top")

p + scale_y_continuous(position = "right")

p + scale_x_discrete(limits = sort(unique(countries[["continent"]]), decreasing = TRUE))

p + scale_y_reverse()

# p + scale_x_reverse() juz nie dziala

continent_order <- group_by(countries, continent) %>% 
  summarise(count = length(continent)) %>% 
  arrange(desc(count)) %>% 
  pull(continent)

p + scale_x_discrete(limits = continent_order)

<<<<<<< HEAD
=======
mutate(countries, 
       country = factor(country, levels = countries[order(countries[["birth.rate"]]), "country"])) %>% 
  filter(continent == "Europe") %>% 
  ggplot(aes(x = country, y = birth.rate)) +
  geom_col()

>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
countries_f <- mutate(countries, continent = factor(continent))

ggplot(data = countries_f, aes(x = continent, fill = continent)) +
  geom_bar() + 
  scale_x_discrete(limits = continent_order)

mutate(countries_f, continent = factor(continent, levels = continent_order)) %>% 
  ggplot(aes(x = continent, fill = continent)) +
  geom_bar()

<<<<<<< HEAD
ggplot(countries_f, aes(x = death.rate, y = birth.rate)) +
=======
mutate(countries_f, continent = factor(continent, levels = continent_order)) %>% 
  ggplot(aes(x = death.rate, y = birth.rate)) +
>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
  geom_point() +
  facet_wrap(~ continent)


mutate(countries_f, continent = factor(continent, levels = continent_order),
       continent = factor(continent, labels = toupper(levels(continent)))) %>% 
  ggplot(aes(x = death.rate, y = birth.rate)) +
  geom_point() +
  facet_wrap(~ continent)

cntr_pop <- group_by(countries, continent) %>% 
  summarise(count = length(continent)) %>% 
  arrange(desc(count)) %>% 
  mutate(both = paste0(continent, " (", count, " countries)")) %>% 
  pull(both)

<<<<<<< HEAD
mutate(countries_f, continent = factor(continent, levels = continent_order, labels = cntr_pop)) %>% 
=======
mutate(countries_f, continent = factor(continent, 
                                       levels = continent_order, 
                                       labels = cntr_pop)) %>% 
>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
  ggplot(aes(x = death.rate, y = birth.rate)) +
  geom_point() +
  facet_wrap(~ continent)

<<<<<<< HEAD

=======
>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
mutate(countries_f, continent = factor(continent, levels = sapply(strsplit(cntr_pop, " "), first), 
                                       labels = cntr_pop)) %>% 
  ggplot(aes(x = death.rate, y = birth.rate)) +
  geom_point() +
  facet_wrap(~ continent)

# color brewer: http://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3
# alternatywnie library(RColorBrewer)

p + scale_fill_manual(values = c("red", "grey", "black", "navyblue", "green"))
<<<<<<< HEAD
=======

p + scale_fill_manual(values = rainbow(5))

>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
# gradienty: przykladowo scale_fill_gradient()

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  stat_density_2d(aes(fill = ..level..), color = "black", contour = TRUE, geom = "polygon") +
  scale_fill_gradient(low = "navyblue", high = "red")

<<<<<<< HEAD
=======
ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  stat_density_2d(aes(fill = ..level..), color = "black", contour = TRUE, geom = "polygon") +
  scale_fill_gradient2(low = "navyblue", high = "red", mid = "white", 
                       midpoint = 0.004)

>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
p + theme(legend.position = "bottom") +
  guides(fill = guide_legend(nrow = 2))

# 2. koordynaty --------------------------------------------------------------

p <- ggplot(data = countries, aes(x = continent)) +
  geom_bar()

p + coord_flip()

p + coord_flip() + scale_y_reverse()

p + coord_polar()

<<<<<<< HEAD
=======
ggplot(data = countries, aes(x = 1, fill = continent)) +
  geom_bar(position = "stack") +
  coord_polar()

>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
ggplot(countries, aes(x = death.rate, y = birth.rate)) +
  geom_point() +
  facet_wrap(~ continent) + 
  coord_polar()

p <- ggplot(data = countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point() +
  geom_smooth(se = FALSE)

<<<<<<< HEAD
p + coord_equal()

# coord_cartesian nie usuwa punktów
p + coord_cartesian(xlim = c(5, 15))
p + scale_x_continuous(limits = c(5, 15))
=======
p + coord_equal() + facet_wrap(~ continent)

# coord_cartesian nie usuwa punktów
p + coord_cartesian(xlim = c(5, 15))
p + scale_x_continuous(limits = c(5, 15)) 
>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04

# 3. wiele wykresow na jednym rysunku ---------------------------------------------------

library(gridExtra)

grid.arrange(p + coord_cartesian(xlim = c(5, 10)) + ggtitle("coord_cartesian"),
             p + scale_x_continuous(limits = c(5, 10)) + ggtitle("scale_x_continuous - limits"),
             ncol = 1)

<<<<<<< HEAD
=======
grid.arrange(p + coord_cartesian(xlim = c(5, 10)) + ggtitle("coord_cartesian") + 
               theme(legend.position = "none"),
             p + scale_x_continuous(limits = c(5, 10)) + ggtitle("scale_x_continuous - limits"),
             ncol = 1)

grid.arrange(p + coord_cartesian(xlim = c(5, 10)) + ggtitle("coord_cartesian") + 
               theme(legend.position = "none"),
             p + scale_x_continuous(limits = c(5, 10)) + 
               ggtitle("scale_x_continuous - limits") +
               theme(legend.position = "bottom"),
             ncol = 1)

>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
main_plot <- ggplot(data = countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point() 

density_death <- ggplot(data = na.omit(countries), aes(x = death.rate, fill = continent)) +
  geom_density(alpha = 0.2) +
  coord_flip() +
<<<<<<< HEAD
=======
  scale_y_reverse() +
>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
  theme(legend.position = "none")

density_birth <- ggplot(data = countries, aes(x = birth.rate, fill = continent)) +
  geom_density(alpha = 0.2) +
<<<<<<< HEAD
  theme(legend.position = "none")

library(gridExtra)
library(grid)

grid.arrange(density_death, main_plot, density_birth, 
=======
  scale_y_reverse() +
  theme(legend.position = "none")

grid.arrange(density_death, main_plot, density_birth, 
             ncol = 2)

library(grid)


grid.arrange(density_death, main_plot, rectGrob(gp = gpar(fill = NA, col = NA)), density_birth, 
>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
             ncol = 2)

grid.arrange(density_death, main_plot, rectGrob(gp = gpar(fill = NA, col = NA)), density_birth, 
             ncol = 2, heights = c(0.7, 0.3), widths = c(0.3, 0.7))

grid.arrange(density_death, main_plot + theme(legend.position = "none"), rectGrob(gp = gpar(fill = NA, col = NA)), density_birth, 
             ncol = 2, heights = c(0.7, 0.3), widths = c(0.3, 0.7))

get_legend <- function(gg_plot) {
  grob_table <- ggplotGrob(gg_plot)
  grob_table[["grobs"]][[which(sapply(grob_table[["grobs"]], function(x) x[["name"]]) == "guide-box")]]
}

<<<<<<< HEAD
grid.arrange(density_death, main_plot + theme(legend.position = "none"), get_legend(main_plot), density_birth, 
=======
grid.arrange(density_death, main_plot + theme(legend.position = "none"), 
             get_legend(main_plot), density_birth, 
>>>>>>> 14dfab715972436fd97860c65308c26059e5dc04
             ncol = 2, heights = c(0.7, 0.3), widths = c(0.3, 0.7))


main_plot <- ggplot(data = countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point() +
  theme_bw(base_size = 14)

density_death <- ggplot(data = na.omit(countries), aes(x = death.rate, fill = continent)) +
  geom_density(alpha = 0.2) +
  scale_y_reverse() +
  coord_flip() +
  theme_bw(base_size = 14) +
  theme(legend.position = "none") 

density_birth <- ggplot(data = countries, aes(x = birth.rate, fill = continent)) +
  geom_density(alpha = 0.2) +
  theme_bw(base_size = 14) +
  theme(legend.position = "none") + 
  scale_y_reverse()

grid.arrange(density_death, main_plot + theme(legend.position = "none"), get_legend(main_plot), density_birth, 
             ncol = 2, heights = c(0.7, 0.3), widths = c(0.3, 0.7))

# alternatywy do patchwork
# library(cowplot)
# library(customLayout)

# install.packages("ggplot2")
source("https://install-github.me/thomasp85/patchwork")
library(patchwork)

p1 <- ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_boxplot()

set.seed(1410)
p2 <- ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point(position = "jitter")

p3 <- ggplot(data = countries, aes(x = continent)) +
  geom_bar()

p1 + p2

p1 / p2

(p1 + p2) / p3

((p1 + p2) / p3) * theme_bw()

((p1 + p2) / p3) & theme_bw()

# rozklady brzegowe w patchwork
density_death + main_plot + plot_spacer() + density_birth + 
  plot_layout(ncol = 2, heights = c(0.7, 0.3), widths = c(0.3, 0.7))
