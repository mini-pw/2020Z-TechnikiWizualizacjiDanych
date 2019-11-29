library("tidyverse")
library("haven")
library("dplyr")
library("ggplot2")
library("stringi")

### PUT THIS FILE IN THE SAME DIRECTORY AS YOUR SAS FILES THAT YOU WANT TO USE


### LOADING DATA ###

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))      #sets working directory to file location


### you should have files below in the same directory as this file
# teachers <- read_sas("cy6_ms_cmb_tch_qqq.sas7bdat")
# students <- read_sas("cy6_ms_cmb_stu_qqq.sas7bdat")         # 500000x921 dataframe WATCH OUT!




### CHOSEN QUESTIONS ###

# STUDENT QUESTIONS #

# I only store question number becouse they sometimes
# have subquestions and all are of type: 
# 2  uppper case letters: type of questionnaire etc ST (student questionnaire), SC (school questionnaire), PA (parent questionnaire), 
# 3 digits: question number ect 011 or 127
# 5 diggits or upper case letters: random code etc 00ATY or A114I
# so title of question looks like this: ST034AT49Q


## Unfortunatly after getting data from multiple questionnaires you have to join dataframes yourself
questions_ST <- c("ST",3) # CHOOSE YOUR OWN QUESTIONS
questions_SC <- c("SC") 



### EXTRACTING CHOSEN QUESTIONS ###

get_data_of_questions <- function(questions){
  
  # all titles of questions 
  all_questions_names <- colnames(students)
  
  # basic info about student, Country 3-letter code, School ID, Student ID, Language of questionnaire 3-digits
  basic_info <- students[,c(2,3,4,21)]
  
  # all questions is dataframe that will be returned 
  all_questions <- basic_info
  
  for(question in questions[-1]){
    
    # setting regexp to find all sub questions to one main question
    regEXP <- paste0(questions[1],"0*",toString(question),".+\\b")
    
    # extracting all subquestions to a question
    found_questions <- str_extract(all_questions_names,regEXP)
    
    # adding found subquestions to dataframe
    all_questions <-cbind(all_questions,students[found_questions[!is.na(found_questions)]])
    
  }
  return(all_questions)
}



data_of_all_questions <-  get_data_of_questions(questions_ST)



### PLAYGROUND, have fun ###

# polskie dzieci bez w??asnego biurka, ile maj?? ksi????ek w domu
data_of_all_questions%>%
  filter(CNT=="POL",ST011Q09TA==2)%>%
  group_by(ST013Q01TA)%>%
  count()-> test_query
  

#polskie dzieci bez w??asnego biurka, jaki etap edukacji chc?? uko??czy???
data_of_all_questions%>%
  filter(CNT=="POL",ST011Q09TA==2)%>%
  group_by(ST111Q01TA)%>%
  count()-> test_query2

# moje

i <- 1
for (x in students){
  print(paste(i, attr(x, "label")))
  i <- i+1
}
miesiace <- cbind(data_of_all_questions, PV=rowMeans(students[, 810:919])) %>%
  group_by(ST003D02T) %>% summarise(MEAN=mean(PV, na.rm=T)) %>% na.omit()

miesiace$MEAN <- miesiace$MEAN-mean(miesiace$MEAN)

miesiaceK <- function(x, n) {
  mk <- cbind(data_of_all_questions, PV=rowMeans(students[, 810:919])) %>%
    group_by(ST003D02T) %>% filter(CNT==x) %>% summarise(MEAN=mean(PV, na.rm=T)) %>% na.omit()
  mk$MEAN <- mk$MEAN-mean(mk$MEAN)
  return(cbind(mk, cnt=rep(n, 12)))
}

miesiace5 <- rbind(miesiaceK("POL", "1"), miesiaceK("USA", "2"), miesiaceK("TAP", "3"), miesiaceK("BRA", "4"), miesiaceK("TUN", "5"),
                   cbind(miesiace, cnt=rep(n, 6)))

miesiaceMax <- cbind(data_of_all_questions, PV=rowMeans(students[, 810:919])) %>%
  group_by(CNT, ST003D02T) %>% summarise(MEAN=mean(PV, na.rm=T)) %>% na.omit()

miesiaceMax2 <- miesiaceMax %>% group_by(CNT) %>% summarise(MAX=max(MEAN))

miesiaceMax3 <- miesiaceMax %>% inner_join(miesiaceMax2, by="CNT") %>% filter(MEAN==MAX) %>%
  select(CNT, ST003D02T) %>% group_by(ST003D02T) %>% count()

ggplot(miesiaceMax3, aes(x=ST003D02T, y=n)) + geom_col()

miesiaceMax4 <- cbind(data_of_all_questions,
                      PV=rowMeans(students[, 810:919]),
                      AL=rowSums(students[, 122:125])) %>% na.omit() %>%
  filter(AL<=60) %>%
  group_by(AL, ST003D02T) %>% summarise(MEAN=mean(PV, na.rm=T))

miesiaceMax5 <- miesiaceMax4 %>% group_by(AL) %>% summarise(MAX=max(MEAN), MIN=min(MEAN))

miesiaceMax6 <- miesiaceMax4 %>% inner_join(miesiaceMax5, by="AL") %>% filter(MEAN==MAX) %>%
  select(AL, ST003D02T)

miesiaceMax7 <- miesiaceMax4 %>% inner_join(miesiaceMax5, by="AL") %>% filter(MEAN==MIN) %>%
  select(AL, ST003D02T)

miesiaceMaxMin <- rbind(cbind(miesiaceMax6, TYPE=rep("1", dim(miesiaceMax6)[1])), cbind(miesiaceMax7, TYPE=rep("2", dim(miesiaceMax7)[1])))

ggplot(miesiaceMaxMin, aes(y=AL)) + geom_point(aes(x=ST003D02T.x), color="#00c0c0") + geom_point(aes(x=ST003D02T.y), color="#c00000")

# WYKRESY NA PLAKAT

# Wykres 1 - średnia według miesiąca ze średniego wyniku ze wszystkich zadań
cairo_pdf("hist1.pdf", width=4, height=3.5)
ggplot(miesiace5, aes(x=ST003D02T, y=MEAN, color=cnt, linetype=cnt, size=cnt)) + geom_line() +
  scale_color_manual(values=c("#ff0000", "#0000ff", "#ff00ff", "#00ff00", "#800000", "#000000"), name="",
                     labels=c("Polska", "USA", "Tajwan", "Brazylia", "Tunezja", "świat")) +
  scale_linetype_manual(values=c(2:6, 1), name="",
                        labels=c("Polska", "USA", "Tajwan", "Brazylia", "Tunezja", "świat")) +
  scale_size_manual(values=c(rep(0.5, 5), 1), name="",
                    labels=c("Polska", "USA", "Tajwan", "Brazylia", "Tunezja", "świat")) +
  theme(legend.position = "top") +
  labs(x="miesiąc", y="różnica", title="Różnica między miesięcznym średnim\nwynikiem z zadań, a ogólnym") +
  scale_x_continuous(breaks=1:12, labels=as.roman(1:12))
dev.off()

# Wykres 2 - liczba krajów, w których uczniowie urodzeni w danym miesiącu osiągnęli statystycznie najlepsze wyniki
cairo_pdf("hist2.pdf", width=4, height=3.5)
ggplot(miesiaceMax3, aes(x=ST003D02T, y=n)) + geom_col() +
  labs(x="miesiąc", y="liczba krajów", title="Liczba krajów z każdym z miesięcy\njako najlepszym") +
  scale_x_continuous(breaks=1:12, labels=as.roman(1:12)) +
  scale_y_continuous(breaks=1:max(miesiaceMax3$n))
dev.off()

# Wykres 3 - najlepszy i najgorszy miesiąc urodzenia według liczby godzin przeznaczonych na naukę poza szkołą
cairo_pdf("hist3.pdf", width=4, height=7)
ggplot(miesiaceMaxMin, aes(x=ST003D02T, y=AL, color=TYPE)) + geom_point() + 
  scale_color_manual(values=c("#00c0c0", "#c00000"), name="", labels=c("najlepszy miesiąc", "najgorszy miesiąc")) +
  theme(legend.position = "top") +
  labs(x="miesiąc", y="liczba godzin nauki", title="Najlepsze i najgorsze miesiące według\nliczby godzin nauki poza szkołą") +
  scale_x_continuous(breaks=1:12, labels=as.roman(1:12))
dev.off()