library(stringi)
library(dplyr)
library(jsonlite)

setwd("/home/konrad/studia/twd/TWD_p2/src/processing-data/")

# Reading CSV into R
data <- read.csv(file = "../../resources/data/data.csv", header = TRUE, 
                 sep = ",", encoding = "UTF-8", stringsAsFactors = FALSE)
data <- data[1:463, ]


# removing colons from coauthors
remove_colon <- function(full) {
  stri_replace_first(full, "", fixed = ",")
}
#remove_colon(c("dsafasdf, sdfasf (safddsaf, safddsf)", "", " ", "sdfasdf asdfdsf") ) # test

for(i in 8:ncol(data)) {
  data[[i]] <- remove_colon(data[[i]])
}


photo_prefix <- "../../resources/processed-images/"
outsider_photo_path <- photo_prefix %s+% "other.png"

remove_polish_chars <- function(text) {
  polish <- c('ą', 'ę', 'ó', 'ł', 'ć', 'ś', 'ż', 'ź', 'ń')
  english <- c('a', 'e', 'o', 'l', 'c', 's', 'z', 'z', 'n')
  for(i in 1:length(polish)) {
    text <- gsub(polish[i], english[i], text)
  }
  text
}

generate_image_name <- function(names) {
  stri_split(names, fixed = " ") %>% lapply(function(elements) {
    (remove_polish_chars(elements[2]) %s+% "_" %s+% remove_polish_chars(elements[1]) %s+% ".png")
  }) %>% unlist()
}
#generate_image_name("Słapek Mariusz")


others_photo_path <- function(author_name) {
  isPhoto <- FALSE
  outsider_photo_path <- ""
  genName <- generate_image_name(author_name)
  file.names <- dir(photo_prefix, pattern =".png")
  for(i in 1:length(file.names)) {
    if(genName == file.names[i]) {
      isPhoto <- TRUE
    }
  }
  
  if(isPhoto) {
    outsider_photo_path <- photo_prefix %s+% genName
  } else {
    outsider_photo_path <- photo_prefix %s+% "other.png"
  }
  
  outsider_photo_path
}

miniWorker_photo_path <- function(author_name) {
  isPhoto <- FALSE
  genName <- generate_image_name(author_name)
  file.names <- dir(photo_prefix, pattern =".png")
  for(i in 1:length(file.names)) {
    if(genName == file.names[i]) {
      isPhoto <- TRUE
    }
  }
  
  if(isPhoto) {
    photo_prefix %s+% genName
  } else {
    photo_prefix %s+% "mini.png"
  }
}

miniWorker_photo_path("Biecek Przemysław")

extract_author_name <- function(full) {
  stri_extract_first(full, regex = "^[^\\(]*") %>%
    stri_replace("", fixed = "(") %>%
    stri_trim()
}
#extract_author_name(c("przemyslaw biecek (MiNI PW)", " przemyslaw biecek  (MiNI PW)", "przemyslaw biecek(MiNI PW)")) # test

extract_author_affil <- function(full) {
  affil <- stri_extract_first(full, regex = "\\(.*$") %>%
    stri_replace("", fixed = "(") %>%
    stri_replace("", fixed = ")") %>%
    stri_trim()
  if(is.na(affil)) {
    affil <- ""
  }
  affil
}
#extract_author_affil(c("przemyslaw biecek (MiNI PW )", " przemyslaw biecek  (MiNI, PW)", "przemyslaw biecek( MiNI PW  )")) # test


find_author_id <- function(author_name) {
  authors %>% 
    filter(name == author_name) %>% 
    pull(id)
}


authors <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(authors) <- c("id", "name", "miniWorker", "affil", "img")

add_author <- function(authors, author_name, miniWorker, author_affil) {
  if(!(author_name %in% c("0", "", " ")) &&
     !(author_name %in% authors[["name"]]) &&
     !is.na(author_name)) {
    authors <- authors %>% add_row(id = nrow(authors) + 1, 
                                   name = author_name,
                                   miniWorker = ifelse(miniWorker, 1, 0),
                                   affil = author_affil,
                                   img = ifelse(miniWorker,
                                                miniWorker_photo_path(as.character(author_name)),
                                                others_photo_path(as.character(author_name))))

  }
  authors
}

links <- data.frame(matrix(ncol = 4, nrow = 0))
colnames(links) <- c("link_id", "source", "target", "width")

find_link <- function(links, s, t) {
  links %>% filter(source == s & target == t) %>% pull(link_id)
}

increase_link <- function(links, increased_link_id) {
  links %>% mutate(width = width + (link_id == increased_link_id))
}

pubs <- data.frame(matrix(ncol = 2, nrow = 0))
colnames(pubs) <- c("link_id", "title")


for(i in 1:nrow(data)) {
  
  # variable to keep ids of authors of i'th publication
  link_authors <- c()
    
  # adding author from 2nd row
  name <- stri_trim(data[[i, 2]])
  authors <- add_author(authors, name, TRUE, "MINI PW")
  link_authors <- link_authors %>% c(find_author_id(name))
  
  coauthors_n <- data[[i, 3]]
  
  for(j in 8:(8 + coauthors_n - 1)) {
    full <- stri_trim(data[[i, j]])
    if(!(full %in% c("", "0"))) {
      name <- extract_author_name(full)
      affil <- extract_author_affil(full)
      authors <- add_author(authors, 
                            name, 
                            stri_detect(stri_trans_tolower(affil), fixed = "mini"), 
                            affil)
      link_authors <- link_authors %>% c(find_author_id(name))
    }
  }
  
  stopifnot(length(link_authors) == length(unique(link_authors)))
  
  link_authors <- sort(link_authors)
  
  # creating pub
  title <- stri_trim(data[[i, 5]])
  if(!(title %in% pubs[["title"]])) {
    
    link_ids <- c()
    
    #print(link_authors)
    #print(length(link_authors))
    # is new publication so we add links
    for(k in 1:length(link_authors)) {
      for(l in (0:(k - 1))[-1]) { # l != 0, so done this strange thing instead 1:(k - 1) #(0:(k - 1))[-1]
        #print(k)
        #print(l)
        found <- find_link(links, link_authors[k], link_authors[l])
        if(length(found) > 0) {
          #print("old_link")
          links <- increase_link(links, found)
        } else {
          #print("new_link")
          links <- links %>% add_row(link_id = nrow(links) + 1,
                                     source = link_authors[k],
                                     target = link_authors[l], 
                                     width = 1)
          found <- nrow(links)
        }
        
        link_ids <- link_ids %>% c(found)
      }
    }
    
    link_ids <- unique(link_ids)
    
    pubs <- pubs %>% rbind(data.frame(link_id = link_ids, title = rep(title, length(link_ids))))
  } 
  
}

generate_initials <- function(names) {
  stri_split(names, fixed = " ") %>% lapply(function(elements) {
    inits <- stri_sub(elements, from = 1, to = 1)
    inits <- c(inits[length(inits)], inits[-length(inits)])
    stri_flatten(inits, collapse = "")
  }) %>% unlist()
}
# generate_initials(c("Biecek Przemysław", "Mariusz Słapek"))

# adding initials
authors <- authors %>% mutate(initials = generate_initials(name))

# generating files for manual input
#input <- authors %>% mutate(web_usos = "", web_scholar = "", web_other = "")
#write.csv(input, "../../resources/data/hand_input.csv")

# # writing json file
authors <- read.csv("../../resources/data/hand_input.csv")
authors <- authors[-1]
write_json(list(nodes = authors, links = links, pubs = pubs), "../ui/final.json")
