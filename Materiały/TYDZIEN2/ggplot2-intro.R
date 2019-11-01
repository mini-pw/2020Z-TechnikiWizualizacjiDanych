library(ggplot2)
library(SmarterPoland)
library(dplyr)

# 1. Mapowanie --------------------------------------------
# przypisanie zrodla danych
ggplot(data = countries)

# mapowanie 
# tu przypisujemy dane do osi, zwroc uwage na zmiane wartosci na osi x
ggplot(data = countries, aes(x = birth.rate, y = death.rate))
ggplot(data = countries, aes(x = continent, y = death.rate))

# dodawanie geometrii
ggplot(data = countries, aes(x = birth.rate, y = death.rate)) + 
  geom_point()

ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point()

set.seed(1410)
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point(position = "jitter")

ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point(alpha = 0.2)

ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_boxplot()

ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_boxplot(outlier.color = "red")

ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_dotplot(binaxis = "y", stackdir = "center")

ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_violin()

# dane mozna przypisywac nie tylko do osi, ale rowniez do innych atrybutow graficznych 
ggplot(data = countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point()

# niektore geometrie wymagaja konkretnych atrybutow graficznych
ggplot(data = countries, aes(x = continent)) +
  geom_bar()

ggplot(data = countries, aes(x = death.rate)) +
  geom_density()

ggplot(data = countries, aes(x = death.rate, fill = continent)) +
  geom_density()

# 2. Wielowarstwowe wykresy ------------------------
# geometrie mozna laczyc
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_boxplot() +
  geom_point()

set.seed(15390)
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point(position = "jitter") +
  geom_boxplot(outlier.color = NA) # w celu unikniecia dublowania outlierow z geom_point

# wielowymiarowe i wielowarstwowe wykresy

continents <- group_by(countries, continent) %>% 
  na.omit %>% 
  summarise(death.rate = mean(death.rate),
            birth.rate = mean(birth.rate, na.rm = TRUE),
            population = mean(population),
            n.countries = length(country))

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population)) +
  geom_point()

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, color = continent)) +
  geom_point() +
  scale_color_manual(values = c("red", "navyblue", "orange", "pink", "green"))

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, color = n.countries)) +
  geom_point()

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, color = n.countries,
                       label = continent)) +
  geom_point() +
  geom_label()


# geometrie automatycznie wykorzystują okreslone atrybuty graficzne.
# w tym przypadku atrybut size automatycznie jest przypisany zarowno do geom_point i geom_text
ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_text(vjust = -1)

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_text(vjust = -1, size = 5)

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population)) +
  geom_point() +
  geom_text(aes(x = birth.rate, y = death.rate, label = continent), size = 5, vjust = -1, 
            inherit.aes = FALSE)

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_text(vjust = "inward", size = 5)

# wiele uzytecznych geometrii mozna znalezc w pakietach rozszerzajacych ggplot2
library(ggrepel)
ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_text_repel(size = 5, force = 1)

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_label_repel(size = 5, force = 1)

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent, 
                       color = n.countries)) +
  geom_point() +
  geom_text_repel(size = 5, force = 1, color = "black") 

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, 
                       label = paste0(continent, "; ", n.countries, " countries"))) +
  geom_point() +
  geom_text_repel(size = 4, force = 1, color = "black") 

# łącząc geometrie
# na jednym rysunku mozna przedstawic dane z wiecej niz jednego zrodla

library(ggbeeswarm)
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_quasirandom(method = "smiley")

ggplot(data = countries, aes(x = 1, y = death.rate, color = continent)) +
  geom_quasirandom()

countries %>% 
  mutate(has_p_letter = substr(country, 0, 1) == "P") %>% 
  ggplot(aes(x = continent, y = death.rate, color = has_p_letter)) +
  geom_quasirandom(method = "frowney")

ggplot(countries, aes(x = continent, y = population)) +
  geom_violin() +
  scale_y_log10()

