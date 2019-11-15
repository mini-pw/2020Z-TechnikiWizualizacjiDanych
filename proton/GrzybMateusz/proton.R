install.packages("BetaBit")
library(BetaBit)
library(stringi)
proton()

options(stringsAsFactors = FALSE)

ScrappedData <- employees
JohnInsecuresLogin <- employees[employees$name == 'John' & employees$surname == 'Insecure', 3]
proton(action = 'login', login = JohnInsecuresLogin)

PopularPasswords <- top1000passwords
for (i in 1:length(PopularPasswords)) {
  proton(action = 'login', login = JohnInsecuresLogin, password = PopularPasswords[i])
}

StolenLogs <- logs
PietraszkosLogin <- employees[employees$name == 'Slawomir' & employees$surname == 'Pietraszko', 3]
WantedHosts <- StolenLogs[StolenLogs$login == PietraszkosLogin, ]
WantedHostsCleaned <- as.vector(WantedHosts$host)
MostOftenUsedHost <- names(sort(table(WantedHostsCleaned),decreasing = TRUE))[1]
proton(action = 'server', host = MostOftenUsedHost)

CommandHistory <- bash_history
PietraszkosPassword <- tail(unique(stri_extract(CommandHistory, regex = "([^\\s]+)")), 1)

proton(action = 'login', login = PietraszkosLogin, password = PietraszkosPassword)