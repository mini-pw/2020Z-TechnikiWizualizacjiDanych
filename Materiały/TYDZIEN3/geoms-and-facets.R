library(ggplot2)
library(SmarterPoland)
library(dplyr)

# 1. Adekwatność geometrii ------------------------------ 
# wykresy gestosci bywaja czytelniejsze niz punktowe w przypadku duzej liczby punktow
ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point()

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_density_2d(color = "black", contour = TRUE) +
  geom_point()

ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  geom_density_2d(color = "black", contour = TRUE)

# 2. Geom i stat
# wykorzystujemy stat, a nie geom, poniewaz interesuje nas inna geometria (polygon)
ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  stat_density_2d(color = "black", contour = TRUE, geom = "polygon")

ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  stat_density_2d(aes(alpha = ..level..), color = "black", contour = TRUE, geom = "polygon")

ggplot(countries, aes(x = continent)) + 
  geom_bar()

ggplot(countries, aes(x = continent, y = birth.rate)) + 
  stat_summary(fun.y = "length", geom = "bar")

ggplot(countries, aes(x = continent, y = birth.rate)) + 
  stat_summary(fun.y = "median", geom = "bar")

ggplot(countries, aes(x = birth.rate)) + 
  stat_bin(geom = "bar")

ggplot(countries, aes(x = birth.rate)) + 
  geom_histogram()

# linie trendu

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() 

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  geom_smooth() 

ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point() + 
  geom_smooth() 

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  geom_smooth(se = FALSE) 

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  geom_smooth(se = FALSE) 

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  stat_smooth(se = FALSE) 


# 3. Panele (facets) ---------------------------------
ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  stat_density2d(aes(alpha = ..level..), color = "black", contour = TRUE, geom = "polygon") +
  facet_wrap(~ continent)

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  stat_density2d(aes(alpha = ..level..), color = "black", contour = TRUE, geom = "polygon") +
  facet_wrap(~ continent)

set.seed(16182019)
small_diamonds <- diamonds[sample(1L:nrow(diamonds), size = 500), ]

p <- ggplot(small_diamonds, aes(x = cut, y = price)) +
  geom_boxplot()

p + facet_wrap(~ clarity)

p + facet_wrap(~ clarity, scales = "free_x")

p + facet_wrap(~ clarity, scales = "free_y")

p + facet_wrap(~ clarity, scales = "free")

ggplot(small_diamonds, aes(x = carat, y = price)) +
  geom_point() +
  facet_wrap(~ clarity + color)

p + facet_wrap(~ clarity + color, labeller = label_both)

p + facet_grid(clarity ~ color)

p + facet_grid(color ~ clarity)

p + facet_grid(clarity ~ color, switch = "x")

p + facet_grid(clarity ~ color, switch = "y")

p + facet_grid(clarity ~ color, switch = "both")

p + facet_grid(clarity ~ color, margins = "color")

# 4. Transformacje danych
library(ggrepel)

# skrajne przypadki mozna podpisac
na.omit(countries) %>% 
  mutate(label_for_plot = ifelse(birth.rate %in% range(birth.rate) | death.rate %in% range(death.rate),
                                 country, "")) %>% 
  ggplot(aes(x = birth.rate, y = death.rate, label = label_for_plot)) +
  geom_point() +
  geom_text_repel()
