library("tidyverse")
library("haven")
library("dplyr")

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
questions_ST <- c("ST",19,21) # CHOOSE YOUR OWN QUESTIONS
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
    regEXP <- paste0(questions[1],"0?",toString(question),".{5}\\b")
    
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


i <- 1
for (x in students){
  print(paste(i, attr(x, "label")))
  i <- i+1
}
pytania_5 <- cbind(get_data_of_questions(questions_ST), PVREAD=rowMeans(students[, p])) %>%
  filter(!is.na(ST021Q01TA)|!is.na(ST019AQ01T)) %>%
  mutate(IMMIGRANT=(!is.na(ST021Q01TA) & ST019AQ01T==2)) %>%
  group_by(CNT, IMMIGRANT) %>% summarise(READM=mean(PVREAD, na.rm=T)) %>% na.omit()

pytania_5t <- pytania_5 %>% filter(IMMIGRANT==TRUE) %>% select(CNT, READM)
pytania_5f <- pytania_5 %>% filter(IMMIGRANT==FALSE) %>% select(CNT, READM)
pytania_5tf <- inner_join(pytania_5t, pytania_5f, by="CNT") %>% mutate(DIFF=READM.x-READM.y) %>% select(CNT, DIFF)
pytania_5good <- pytania_5tf%>% arrange(desc(DIFF)) %>% head(10)
saveRDS(pytania_5good, "wykr5a.rds")
pytania_5bad <- pytania_5tf%>% arrange(DIFF) %>% head(10)
saveRDS(pytania_5bad, "wykr5b.rds")

ggplot(pytania_5bad, aes(x=reorder(CNT, -DIFF), y=-DIFF)) + geom_col()
