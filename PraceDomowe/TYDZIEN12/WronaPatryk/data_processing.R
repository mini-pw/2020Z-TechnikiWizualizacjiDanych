options(stringsAsFactors = FALSE)

#install.packages("openxlsx")

# linki do zbioru danych:
#
# besposrednio: https://www.google.com/url?q=https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/851524/avi0101.ods&source=datasetsearch
# 
# https://datasetsearch.research.google.com/search?query=Aviation%20statistics%3A%20data%20tables%20(AVI)&docid=PBaaexhDzeS8UmZtAAAAAA%3D%3D
# ->   AVI0101: Air traffic at UK airports (ODS, 10.8KB) 

# przerobilem ww. zbior danych do .xlsx, a nastepnie wczytalem w R, aby stworzyć plik .csv:



library(openxlsx)


df <- read.xlsx("./aviation.xlsx")

for ( i in 3:13){
  df[,i] <- floor(df[,i])
}

df2 <- data.frame(NA,NA,NA,NA)
colnames(df2) <- c("Continent", "Country", "Passengers", "Year")


# 11
row_counter <- 1
country_counter <- 1
for (country in df$Country){
  
  for (i in 1:11){
    # tworzy nastepne wiersze
    df2[row_counter, 2] <- country
    df2[row_counter, 3] <- df[country_counter, 2 + i]
    df2[row_counter, 4] <- 2007 + i
    
    row_counter <- row_counter + 1
  }
  country_counter <- country_counter + 1
  
  
}

df2[1:341,1] <- "Europe"
df2[342:396,1] <- "America"
df2[397:440,1] <- "Africa"
df2[441:594,1] <- "Asia"
df2[595:605,1] <- "Oceania"

write.csv(df2, "./aviation.csv")

