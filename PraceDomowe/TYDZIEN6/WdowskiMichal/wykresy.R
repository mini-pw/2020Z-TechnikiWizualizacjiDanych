# import bibliotek i danych
library(ggplot2)
data <- data.frame("Rodzaj" = c("Cena Netto", "Akcyza", "VAT", "Opłata Paliwowa", "Marża"), "Ilosc" = c(0.42, 0.33, 0.19, 0.03, 0.03))
data$Rodzaj <- factor(data$Rodzaj, levels = c("Cena Netto", "Akcyza", "VAT", "Opłata Paliwowa", "Marża"))

# wykres kołowy z podpisanymi wartościami

ggplot(data = data, aes(x = "", y = Ilosc, fill = factor(Rodzaj))) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar(theta = "y", start = 0) +
    theme(
        axis.text.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(), 
        axis.title = element_blank(),
        axis.text.x = element_text(size = 10, face = "bold"),
        axis.line.x = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) +
    labs(title = "Struktura ceny detalicznej benzyny EU95 średnio za 4 miesiące 2018 roku", fill = element_blank()) +
    scale_y_continuous(breaks = c(0.015, 0.045, 0.155, 0.415, 0.79), labels = c("3%", "3%", "19%", "33%", "42%"))

# wykres kołowy

ggplot(data = data, aes(x = "", y = Ilosc, fill = factor(Rodzaj))) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar(theta = "y", start = 0) +
    theme(
        axis.text.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(), 
        axis.title = element_blank(),
        axis.text.x = element_text(size = 10, face = "bold"),
        axis.line.x = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) +
    labs(title = "Struktura ceny detalicznej benzyny EU95 średnio za 4 miesiące 2018 roku", fill = element_blank()) +
    scale_y_continuous(breaks = c(0, 0.2, 0.4, 0.6, 0.8), labels = c("0%", "20%", "40%", "60%", "80%"))

# wykres komulnowy
ggplot(data = data, aes(x = Rodzaj, y = Ilosc)) +
    geom_bar(stat = "identity", width = 0.9, fill = "#362A66") +
    scale_y_continuous(limits = c(0, 0.42), expand = c(0, 0), labels = c("0%", "10%", "20%", "30%", "40%")) +
    theme(
        axis.text.y = element_text(size = 10, face = "bold"),
        axis.line.y = element_line(),
        axis.title = element_blank(),
        axis.text.x = element_text(size = 10, face = "bold"),
        axis.line.x = element_line(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank()) +
    coord_fixed(10) +
    labs(title = "Struktura ceny detalicznej benzyny EU95 średnio za 4 miesiące 2018 roku", fill = element_blank())

# wykres kolumnowy z podpisanymi wartościami
ggplot(data = data, aes(x = Rodzaj, y = Ilosc)) +
    geom_bar(stat = "identity", width = 0.9, fill = "#362A66") +
    geom_text(aes(label = scales::percent(Ilosc, accuracy = 1)), position = position_stack(vjust = 0.5), size = 6, color = "white") +
    scale_y_continuous(limits = c(0, 0.42), expand = c(0, 0)) +
    theme(
        axis.text.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(), 
        axis.title = element_blank(),
        axis.text.x = element_text(size = 10, face = "bold"),
        axis.line.x = element_line(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) +
    coord_fixed(10) +
    labs(title = "Struktura ceny detalicznej benzyny EU95 średnio za 4 miesiące 2018 roku", fill = element_blank())
