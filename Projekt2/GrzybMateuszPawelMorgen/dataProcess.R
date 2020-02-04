# jsonlite::fromJSON("./data/1.json")
library(magrittr)
library(stringi)
for(i in 1:731){
  assign(paste0(i, "thHero"), 
         jsonlite::fromJSON(paste0("./data/",i,".json")))
}

sapply(1:731, function(i){
  hero <- get(paste0(i,"thHero"))
  hero$name
}) -> allNames

sapply(1:731, function(i){
  hero <- get(paste0(i, "thHero"))
  hero$biography$`full-name`
}) -> allFullNames

# Potrzebujemy do grafu następujących rzeczy: imię, id, bazę (y), organizację(e)

# Jakie mamy unikatowe bazy?

sapply(1:731, function(i){
  hero <- get(paste0(i,"thHero"))
  hero$work$base
}) -> allBases
allBases <- allBases[!is.na(allBases)]


# 1) "-" znaczy NA
# 2) część ma znaczek formerly - proponuję olać
# 3) część ma kilka oddzielonych ";"

# Część ma formerly, ale część ma currently na końcu:(
# Jeszcze część ma "later" 
# Jeszcze część ma błąd ortograficzny - formely zamiast formerly
# 1) later
stri_replace_first_regex(allBases, pattern = "^.*[Ll]ater\\s*", replacement = "") -> allBases1
# 2) currently na końcu
stri_replace_first_regex(allBases1, pattern = "^[^(]*\\(?[Cc]urrent(ly)?\\)?\\s*?", replacement = "") -> allBases2
# 3) formerly
stri_replace_first_regex(allBases2, 
                         pattern = "[,;]?\\s*(,\\s*Shadowland\\s*)?( and\\s*)?\\(?[Ff]ormer?(ly)?\\)?.*$", 
                         replacement = "") -> allBases3
# 4) previously
stri_replace_first_regex(allBases3, 
                         pattern = "[,;]?\\s*\\(?[Pp]revious(ly)?\\)?.*$", 
                         replacement = "") -> allBases3

# przycinamy początki i końcówki
stri_replace_all_regex(allBases3, 
                         pattern = "^\\s+", 
                         replacement = "") %>%
  stri_replace_first_regex(pattern = "\\s+$",
                           replacement = "") -> allBases4

# Poprawka kilku nieścisłości
stri_replace_all_fixed(allBases4,
                 pattern=c("Chicago, Gotham City, Metropolis",
                         "Detroit, Michigan · Oa ·",
                         "Empire State University and Avengers Mansion, New York City, NY",
                         "Fantastic Four headquarters, New York City, and Keewazi Reservation, Oklahoma",
                         "Gotham City and Metropolis",
                         "Gotham City and New York City",
                         "Gotham City,",
                         "Metropolis, The Hall & The JLA Watchtower",
                         "St. Roch, Louisiana, JLA Watchtower",
                         "Wakanda, Mobile",
                         "Wayne Manor; Batcave; Gotham City",
                         "The Starjammer, Mobile",
                         "/"),
                 replacement = c("Chicago; Gotham City; Metropolis",
                                 "Detroit, Michigan; Oa",
                                 "Empire State University, New York City, New York State; Avengers Mansion, New York City, New York State",
                                 "Fantastic Four headquarters, New York City; Keewazi Reservation, Oklahoma",
                                 "Gotham City; Metropolis",
                                 "Gotham City; New York City, New York State",
                                 "Gotham City;",
                                 "Metropolis; The Hall & The JLA Watchtower",
                                 "St. Roch, Louisiana; The Hall & The JLA Watchtower",
                                 "Wakanda; Mobile",
                                 "The Starjammer; Mobile",
                                 "Wayne Manor",
                                 ";"),
                 vectorize_all = FALSE) -> allBases4

# Rozcinamy
stri_split_regex(allBases4,
                 pattern = ";\\s*") -> allBases5

# Ujednolicamy

#unlist(allBases5) %>%
#  table() %>%
#  View()

patterns <- c("^Avengers Mansion.*$",
              "^Avengers Tower.*$",
              "^Attilan.*$",
              "^Batcave.*$",
              "^Baxter Building.*$",
              "^Central City.*$",
              "NV",
              "NY",
              "^[Mm]obile.*$",
              "^New York.*$",
              "[Pp]rimarily\\s*",
              "^San Francisco.*$",
              "^Smallville.*$",
              "Hall of Justice, Justice League Watchtower",
              "^Titans Tower.*$",
              "^Wayne Manor.*$",
              "^.*Xavier.*$",
              "^X-Factor Investigations.*$",
              "\\(before death\\)\\s+",
              "^[Aa] castle on the Hudson River.*$",
              "^[Aa] penthouse in New York City",
              "Atlantean Royal Palace",
              "[Bb]ase of operations unknown",
              "^Bishop Publishing.*$",
              "Brooklyn",
              "Emma Frost operates from the ",
              "^Many bases .*$",
              "^Celestial Ship.*$",
              "^Chicago.*$",
              "^Hell's Kitchen.*$",
              "^[Aa]partment in Brooklyn.*$",
              "^\\s*Detroit.*$",
              "New York( City)?\\s*$",
              "^Keystone City.*$",
              "^Massachusetts.*$",
              "^Toronto.*$",
              "^World-?[Ss]hip.*$",
              ", New York State",
              "^[Vv]arious hidden bases.*$",
              "unrevealed",
              "^The Hall &.*$",
              "^\\(Banner\\).*$",
              "(New York City){2,}",
              "Law offices of Goodman, Lieber, Kurtzberg, & Holliway",
              "Psychiatrist, teacher, adventurer",
              "the House of Razor.*",
              "The Labyrinth.*",
              "^The Watchtower \\(on top.*$",
              "Metropolis, Earth, 21st Century",
              "21st Century Gotham City")

replacements <- c("Avengers Mansion, New York City, New York State",
                  "Avengers Tower, New York City, New York State",
                  "Attilan, Blue Area of the Moon",
                  "Batcave, Wayne Manor, Gotham City",
                  "Baxter Building, New York City, New York State",
                  "Central City, Missouri",
                  "Nevada",
                  "New York City, New York State",
                  "Mobile",
                  "New York City, New York State",
                  "",
                  "San Fransisco, California",
                  "Smallville, Kansas",
                  "The Hall & The JLA Watchtower",
                  "Titans Tower, San Fransisco, California",
                  "Wayne Manor, Gotham City",
                  "Xavier Institute, Salem Center, Westchester County, New York City, New York State",
                  "X-Factor Investigations, New York City, New York State",
                  "",
                  "A castle on the Hudson River, New York City, New York State",
                  "New York City, New York State",
                  "Atlantean Royal Palace, Atlantis",
                  "-",
                  "Bishop Publishing, New York City, New York State",
                  "Brooklyn, New York City, New York State",
                  "",
                  "-",
                  "Celestial Ship",
                  "Chicago, Illinois",
                  "Hell's Kitchen, New York City, New York State",
                  "Brooklyn, New York City, New York State",
                  "Detroit, Michigan",
                  "New York City, New York State",
                  "Keystone City, Kansas",
                  "Massachusetts Academy, Snow Valley, Massachusetts",
                  "Toronto, Canada",
                  "Worldship of Galactus",
                  "",
                  "-",
                  "-",
                  "The Hall & The JLA Watchtower",
                  "Hulkbaster Base, New Mexico",
                  "New York City",
                  "Law offices of Goodman,Lieber,Kurtzberg,&Holliway",
                  "-",
                  "The House of Razor",
                  "The Labyrinth",
                  "The Watchtower, Manhattan, New York City",
                  "21st Century Metropolis, Metropolis",
                  "21st Century Gotham City, Gotham City")

lapply(allBases5,
       function(bases) {out <- stri_replace_all_regex(str = bases,
                                              pattern = patterns,
                                              replacement = replacements,
                                              vectorize_all = FALSE)
                        if(any(unlist(out) == "")) out <- "-"
                        out}) -> finalBases

# Uff. No to teraz group-affiliation
sapply(1:731, function(i){
  hero <- get(paste0(i,"thHero"))
  hero$connections$`group-affiliation`
}) -> allGroups
stri_replace_first_regex(allGroups, pattern = "^.*[Ll]ater\\s*", replacement = "") -> allGroups1
# 2) currently na końcu - czyścimy wszystko to, co przed currently, włącznie z currently
stri_replace_first_regex(allGroups1, pattern = "^.*, [Cc]urrent(ly)?\\s*?", replacement = "") -> allGroups2

# 3) currently na początku
stri_replace_first_regex(allGroups2[stri_detect_regex(allGroups2,
                                                      pattern = "^[^,]*[Cc]urrent(ly)?")], 
                         pattern = "\\(?[Cc]urrent(ly)?\\)?\\s*?", 
                         replacement = "") -> allGroups2[stri_detect_regex(allGroups2,
                                                                           pattern = "^[^,]*[Cc]urrent(ly)?")]

# 4) formerly
# W kilku durnych przypadkach (poza Invisible Woman) mamy ..., formerly;. Wtedy trzeba wykasować wszystko
stri_replace_first_regex(allGroups2[allNames != "Invisible Woman"], 
                         pattern = "^.*[Ff]ormer?(ly)?;\\)?.*$", 
                         replacement = "") -> allGroups2[allNames != "Invisible Woman"]
# Z kolei Professora X niesłusznie nie ma wśród X-menów (wiki twierdzi, że zginął).
stri_replace_first_regex(allGroups2[allNames == "Professor X"],
                         pattern = "^\\s*[Ff]ormer(ly)?\\s*",
                         replacement = "") -> allGroups2[allNames == "Professor X"]
# Teraz powinno być OK
stri_replace_first_regex(allGroups2, 
                         pattern = "[,;]?\\s*( and\\s*)?\\(?[Ff]ormer?(ly)?\\)?.*$", 
                         replacement = "") -> allGroups2.5

# Tutaj przecinki i średniki służą do tego samego. Prawie wszędzie
stri_replace_all_regex(allGroups2.5[!stri_detect(allGroups2.5, fixed = "a band of followers")], 
                       pattern = c(", frequently teamed with the second Flash and the original Green Arrow",
                                   "^Maximum Carnage.*",
                                   ",", 
                                   "Goodman; Lieber; Kurtzberg; & Holliway", 
                                   " and the JLA",
                                   "Spider-Man and Black Cat"), 
                       replacement = c("",
                                       "Maximum Carnage",
                                       ";", 
                                       "Goodman, Lieber, Kurtzberg & Holliway",
                                       "; Justice League of America",
                                       "Spider-Man; Black Cat"),
                       vectorize_all = FALSE) -> allGroups2.5[!stri_detect(allGroups2.5, fixed = "a band of followers")]

# przycinamy początki i końcówki
stri_replace_all_regex(allGroups2.5, 
                       pattern = c("^\\s+","\\s+$"), 
                       replacement = c("", ""),vectorize_all = FALSE) -> allGroups3
# Rozcinamy
stri_split_regex(allGroups3,
                 pattern = ";\\s*") -> allGroups4

# Ujednolicamy

#unlist(allGroups6) %>%
#  table() %>%
#  View()
patterns <- c("\\(?[Aa]t (time of )?[Dd]eath\\)?",
              "\\(?(a )?(([Aa]ctive )|(honorary )|(founding )|(genetic )|(co-))?(([Mm]ember)|([Ll]eader)|([Ff]ounder)|(formally))( of( the)?)?\\)?",
              "\\(?unofficially\\)?",
              "The Society\\s*$",
              "The ",
              "\\(As Maverick\\)",
              "^\\s*[Nn]one\\s*$",
              "All-Star Squadron.*$",
              "AIM",
              " \\(Space Program\\)",
              "Incorporated",
              "Heroes [Ff]or [hH]ire",
              "Hell-[Ll]ords",
              "\\(pre-Crisis[^)]+\\)",
              "[Oo]f", 
              "MI-?6",
              "(Secret )?[Ss]ociety of [Ss]uper(\\s|-)?[Vv]illains",
              "[Uu]nderground Avengers",
              "USAF",
              "United States Air Force",
              "^Weapon X.*$",
              "^(New )?X-[Mm]en[^\\d]+$",
              '"',
              "SHIELD\\.?",
              "^\\s*and\\s*(third)?",
              "((Long-time )|(Friend and )|(Sometime ))?[Aa]ll(y|(ied)) (and companion )?of (the )?",
              "[Aa]gent of ",
              "^Darkseid.*$",
              "^Defenders.*$",
              "\\(receives costumes[^)]+\\)",
              "^Excelsior.*$",
              "Four Horsemen",
              "\\(long-time friend\\)",
              "Gods at Asgard",
              "Green Lantern Hal Jordan",
              "Hulk Family",
              "^.*Inhuman.*$",
              "^.*Hellfire Club.*$",
              "Jason Wynn",
              "Jedi High Counsl",
              "\\(ties\\)",
              "New Gods of Apokolips(ruler)",
              "Reserv(e|(ist))",
              "partner of ",
              "Phantom Zone criminals",
              "\\(both incarnations\\)",
              "Secret Avengers.*$",
              " \\(Strike Team\\)",
              "\\(ally\\)",
              "Titans of Myth",
              "^\\s+",
              "\\s+$")
replacements <- c("",
                  "",
                  "",
                  "Secret Society of Super Villains",
                  "",
                  "",
                  "",
                  "All-Star Squadron",
                  "A.I.M.",
                  "",
                  "Inc.",
                  "Heroes for hire",
                  "Hell lords",
                  "",
                  "of",
                  "MI-6",
                  "Secret Society of Super Villains",
                  "Underground Avengers",
                  "U.S. Air Force",
                  "U.S. Air Force",
                  "Weapon X",
                  "X-Men",
                  "",
                  "S.H.I.E.L.D.",
                  "",
                  "",
                  "",
                  "Darkseid",
                  "Defenders",
                  "",
                  "Loners",
                  "Apokolips",
                  "",
                  "Gods of Asgard",
                  "Hal Jordan",
                  "Hulk",
                  "Inhumans",
                  "Hellfire Club",
                  "Anti-Spawn",
                  "Jedi High Council",
                  "",
                  "Apokolips",
                  "",
                  "",
                  "Phantom Zone Criminals",
                  "",
                  "Secret Avengers",
                  "",
                  "",
                  "-",
                  "",
                  "")


lapply(allGroups4,
       function(groups) stri_replace_all_regex(str = groups,
                                              pattern = patterns,
                                              replacement = replacements,
                                              vectorize_all = FALSE)) -> allGroups5
# Wszystko, co zawiera w sobie "Justice League", musi mieć dopisek ",Justice League"
# Podobnie z Lantern Corps, Defenders, X-Factor i Avengers
# Podobnie z Titans West, Teen Titans, New Teen Titans i Titans
# Podobnie z Asgard
metaGroups <- c("Justice League",
                "Avengers", 
                "X-Factor", 
                "Lantern Corps", 
                "Defenders",
                "Titans",
                "Asgard")
lapply(allGroups5, function(groups){
  for( str in metaGroups){
             indexes <- stri_detect_regex(groups, 
                                          pattern = paste0("(.+", str, ")|(", str, ".+)"))
             groups[indexes] <- paste0(groups[indexes], ", ", str)
             if(str == "Justice League") groups[groups == "Young Justice"] <- "Young Justice, Justice League"
           }
  groups
}) -> allGroups6

# Wszystkie powiązania z bohaterami muszą być zachowane
# Poza tym pojedyncze powiązania są do odstrzału
detectMetaGroups <- function(groups){
  sapply(metaGroups, function(group){
    stri_detect_fixed(groups, group)
  }) %>% matrix(nrow = length(metaGroups), byrow = TRUE) %>% apply(MARGIN = 2, FUN = any) %>% as.logical()
}
# Szukamy grup do odstrzału
library(dplyr)
finalUniqueGroupsFactor <- unlist(allGroups6) %>% table() %>% as.data.frame() %>%
  rename(Group = ".") %>% 
  filter(!Group %in% c("", "-"),
         detectMetaGroups(Group) | Freq > 1 | Group %in% c(allNames, allFullNames)) %>%
  extract2("Group")
finalUniqueGroups <- attr(finalUniqueGroupsFactor, "levels")[as.integer(finalUniqueGroupsFactor)]
lapply(allGroups6, function(group){
  out <- group[group %in% finalUniqueGroups]
  if(length(out) == 0) out <- "-"
  out
}) -> finalGroups

# Chcemy zrobić 2 rzeczy:
# 1) nadpisać jsony z bohaterami
# 2) zrobić nowe jsony z miejscami
for(i in 1:731){
  hero <- get(paste0(i, "thHero"))
  hero$work$base <- finalBases[[i]]
  hero$connections$`group-affiliation` <- finalGroups[[i]]
  jsonlite::write_json(hero, file.path("new_data",paste0(i,".json")))
}
# 2)
uniqueBases <- unique(unlist(finalBases))
uniqueBases <- uniqueBases[!uniqueBases %in% c("", "-")]

lapply(uniqueBases, function(base){
  id_s <- which(sapply(finalBases, function(bases) any(bases %in% base)))
  lapply(id_s, function(id){
    hero <- get(paste0(id, "thHero"))
    list(id = id, name = hero$name, alignment = hero$biography$alignment)
  })
}) -> listOfAllUniqueBases
names(listOfAllUniqueBases) <- uniqueBases
jsonlite::write_json(listOfAllUniqueBases, file.path("new_data","allPlaces.json"))

# 3)

uniqueGroups <- unique(unlist(finalGroups))
uniqueGroups <- uniqueGroups[!uniqueGroups %in% c("-")]

lapply(uniqueGroups, function(group){
  id_s <- which(sapply(finalGroups, function(groups) any(groups %in% group)))
  lapply(id_s, function(id){
    hero <- get(paste0(id, "thHero"))
    list(id = id, name = hero$name, alignment = hero$biography$alignment)
  })
}) -> listOfAllUniqueGroups
names(listOfAllUniqueGroups) <- uniqueGroups
jsonlite::write_json(listOfAllUniqueGroups, file.path("new_data","allGroups.json"))
