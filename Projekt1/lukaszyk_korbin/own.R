# POMYSŁY:
# długość lekcji
library("tidyverse")
library("haven")
library("dplyr")
library("ggplot2")
teachers <- read_sas("cy6_ms_cmb_tch_qqq.sas7bdat")
students <- read_sas("cy6_ms_cmb_stu_qqq.sas7bdat")

questions_1 <- c("ST",63,97)
questions_2 <- c("ST",62,76)
questions_3 <- c("ST",119,4)
questions_4 <- c("ST",61)

get_data_of_questions <- function(questions){
  # nazwy pytań
  all_questions_names <- colnames(students)
  # podstawowe informacje o uczniu (kod kraju, ID szkoły, ID ucznia, język ankiety)
  basic_info <- students[,c(2,3,4,21)]
  # zwracana baza danych
  all_questions <- basic_info
  
  for(question in questions[-1]){
    # wyrażenie regularne - szukane są podpytania do pytania głównego
    regEXP <- paste0(questions[1],"0*",toString(question),".{4,5}\\b")
    # podpytania
    found_questions <- str_extract(all_questions_names,regEXP)
    # dodanie podpytań do bazy danych
    all_questions <- cbind(all_questions,students[found_questions[!is.na(found_questions)]])
  }
  return(all_questions)
}

# jak często na lekcjach naukowych panuje hałas i nieporządek?
pytania_1 <- get_data_of_questions(questions_1) %>% na.omit() %>%
  filter(CNT %in% c("DZA", "FIN", "GEO", "NZL", "QAT", "USA")) %>% # 6 przykładowych krajów
  group_by(CNT, ST097Q02TA) %>% count()
saveRDS(pytania_1, "wykr1.rds")

# czy korzystanie z portali społecznościowych i granie w gry wideo wpływają na spóźnianie się?
pytania_2 <- get_data_of_questions(questions_2) %>% na.omit() %>%
  mutate(electronics=ST076Q05NA+ST076Q06NA<4) %>%
  filter(CNT=="USA") %>% group_by(ST062Q03TA, electronics) %>% count()
saveRDS(pytania_2, "wykr2.rds")

# jak różni się podejście do nauki względem płci?
pytania_3 <- get_data_of_questions(questions_3) %>% na.omit()

pytania_31 <- pytania_3 %>% filter(ST004D01T==1)
pytania_32 <- pytania_3 %>% filter(ST004D01T==2)
pytania_3a <- cbind(rep(1, 4), 1:4)
pytania_3b <- cbind(rep(2, 4), 1:4)
for (x in c("ST119Q01NA","ST119Q02NA","ST119Q03NA","ST119Q04NA","ST119Q05NA")){
  pytania_3a <- cbind(pytania_3a, (pytania_31 %>% group_by_at(x) %>% count())[,"n"])
  pytania_3b <- cbind(pytania_3b, (pytania_32 %>% group_by_at(x) %>% count())[,"n"])
}
pytania_3 <- rbind(pytania_3a, pytania_3b)
colnames(pytania_3) <- c("plec", "odpowiedz", paste("p", 1:5, sep=""))
saveRDS(pytania_3, "wykr3.rds")

# długość lekcji w zależności od średnich dochodów rodziny
wealthy <- students %>% group_by(CNT) %>% summarise(wealth = mean(WEALTH, na.rm = TRUE))
pytania_4 <- get_data_of_questions(questions_4) %>% na.omit() %>%
  group_by(CNT) %>% summarise(mean = mean(ST061Q01NA, na.rm = TRUE), sd = sd(ST061Q01NA, na.rm = TRUE)) %>%
  inner_join(wealthy, by="CNT") %>% arrange(desc(wealth))
saveRDS(pytania_4, "wykr4.rds")

ggplot(pytania_1, aes(x="", y=n, label=CNT, fill=ST097Q02TA)) +
  geom_bar(stat="identity", position=position_fill()) +
  coord_polar("y", start=0) +
  facet_wrap(~CNT) +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid  = element_blank()) +
  xlab("") +
  ylab("") +
  scale_fill_discrete(name = "częstotliwość hałasu", labels = c("na każdej lekcji", "na większości lekcji", "na niektórych lekcjach", "nigdy"))

ggplot(pytania_2, aes(x=ST062Q03TA, y=n, fill=electronics)) +
  geom_col() +
  facet_wrap(~electronics)

levels(pytania_3$plec)[levels(pytania_3$plec)==1] <- "Dziewczyny"
levels(pytania_3$plec)[levels(pytania_3$plec)==2] <- "Chłopaki"
ggplot(pytania_3, aes(x=odpowiedz)) +
  geom_line(aes(y=p1, color=rainbow(5)[1])) +
  geom_line(aes(y=p2, color=rainbow(5)[2])) +
  geom_line(aes(y=p3, color=rainbow(5)[3])) +
  geom_line(aes(y=p4, color=rainbow(5)[4])) +
  geom_line(aes(y=p5, color=rainbow(5)[5])) +
  facet_grid(.~plec) +
  scale_color_discrete(name = "numer pytania", labels = 1:5)

# ggplot(pytania_4, aes(x=reorder(CNT, -wealth), group=1)) +
#   geom_line(aes(y=wealth)) +
#   geom_line(aes(y=mean)) +
#   geom_line(aes(y=mean-sd), color="#800000", linetype="dashed") +
#   geom_line(aes(y=mean+sd), color="#000080", linetype="dashed") +
#   theme(axis.text.x = element_text(angle = 90))
 # tego nie lubimy.