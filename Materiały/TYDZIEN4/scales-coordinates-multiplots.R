library(ggplot2)
library(SmarterPoland)
library(dplyr)

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

countries_f <- mutate(countries, continent = factor(continent))

ggplot(data = countries_f, aes(x = continent, fill = continent)) +
  geom_bar() + 
  scale_x_discrete(limits = continent_order)

mutate(countries_f, continent = factor(continent, levels = continent_order)) %>% 
  ggplot(aes(x = continent, fill = continent)) +
  geom_bar()

ggplot(countries_f, aes(x = death.rate, y = birth.rate)) +
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

mutate(countries_f, continent = factor(continent, levels = continent_order, labels = cntr_pop)) %>% 
  ggplot(aes(x = death.rate, y = birth.rate)) +
  geom_point() +
  facet_wrap(~ continent)


mutate(countries_f, continent = factor(continent, levels = sapply(strsplit(cntr_pop, " "), first), 
                                       labels = cntr_pop)) %>% 
  ggplot(aes(x = death.rate, y = birth.rate)) +
  geom_point() +
  facet_wrap(~ continent)

# color brewer: http://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3
# alternatywnie library(RColorBrewer)

p + scale_fill_manual(values = rainbow(5))
# gradienty: przykladowo scale_fill_gradient()

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  stat_density_2d(aes(fill = ..level..), color = "black", contour = TRUE, geom = "polygon") +
  scale_fill_gradient(low = "navyblue", high = "red")

p + theme(legend.position = "bottom") +
  guides(fill = guide_legend(nrow = 2))

# 2. koordynaty --------------------------------------------------------------

p <- ggplot(data = countries, aes(x = continent)) +
  geom_bar()

p + coord_flip()

p + coord_flip() + scale_y_reverse()


p + coord_polar()

ggplot(countries, aes(x = death.rate, y = birth.rate)) +
  geom_point() +
  facet_wrap(~ continent) + 
  coord_polar()

p <- ggplot(data = countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point() +
  geom_smooth(se = FALSE)

p + coord_equal()

# coord_cartesian nie usuwa punktów
p + coord_cartesian(xlim = c(5, 15))
p + scale_x_continuous(limits = c(5, 15))

# 3. wiele wykresow na jednym rysunku ---------------------------------------------------

library(gridExtra)

grid.arrange(p + coord_cartesian(xlim = c(5, 10)) + ggtitle("coord_cartesian"),
             p + scale_x_continuous(limits = c(5, 10)) + ggtitle("scale_x_continuous - limits"),
             ncol = 1)

main_plot <- ggplot(data = countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point() 

density_death <- ggplot(data = na.omit(countries), aes(x = death.rate, fill = continent)) +
  geom_density(alpha = 0.2) +
  coord_flip() +
  scale_y_reverse() +
  theme(legend.position = "none")

density_birth <- ggplot(data = countries, aes(x = birth.rate, fill = continent)) +
  geom_density(alpha = 0.2) +
  scale_y_reverse() +
  theme(legend.position = "none")

library(gridExtra)
library(grid)

grid.arrange(density_death, main_plot, density_birth, 
             ncol = 2)

grid.arrange(density_death, main_plot, rectGrob(gp = gpar(fill = NA, col = NA)), density_birth, 
             ncol = 2, heights = c(0.7, 0.3), widths = c(0.3, 0.7))

grid.arrange(density_death, main_plot + theme(legend.position = "none"), rectGrob(gp = gpar(fill = NA, col = NA)), density_birth, 
             ncol = 2, heights = c(0.7, 0.3), widths = c(0.3, 0.7))

get_legend <- function(gg_plot) {
  grob_table <- ggplotGrob(gg_plot)
  grob_table[["grobs"]][[which(sapply(grob_table[["grobs"]], function(x) x[["name"]]) == "guide-box")]]
}



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

plot1 <- countries %>%
  group_by(continent) %>%
  summarise(srednia = mean(birth.rate, na.rm = TRUE)) %>%
  ggplot(aes(x = continent, y = srednia)) +
  geom_col(aes(x = continent, y = srednia), fill = c('#8dd3c7','#ffffb3','#bebada','#fb8072','#80b1d3')) +
  coord_flip() +
  scale_y_reverse()

plot2 <- countries %>%
  group_by(continent) %>%
  summarise(srednia = mean(death.rate, na.rm = TRUE)) %>%
  ggplot(aes(x = continent, y = srednia)) +
  geom_col(aes(x = continent, y = srednia), fill = c('#8dd3c7','#ffffb3','#bebada','#fb8072','#80b1d3')) +
  coord_flip() +
  theme(axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank())
  
plot1 + plot2
  
