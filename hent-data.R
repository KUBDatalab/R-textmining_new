library(tidyverse)
library(readr)
library(guardianapi)
library(tidytext)
# kør og giv den api-nøglen i console
guardianapi::gu_api_key()

#obama

obama <- guardianapi::gu_content(query = "Obama", from_date = "2009-01-20", to_date = "2009-01-20")


obama %>% 
  filter(!(type %in% c("gallery", "audio", "video"))) %>%
  filter(!(section_id %in% c("tv-and-radio", 
                             "film", 
                             "football", 
                             "stage", 
                             "theguardian",
                             "lifeandstyle", 
                             "sport",
                             "media",
                             "travel",
                             "music"))) %>% 
    select(c(id, web_publication_date, pillar_name, headline, 
             standfirst, body_text)) %>% 
  mutate(id = row_number()) %>%
  write_csv("episodes/data/obama.csv")  



#trump

trump <- guardianapi::gu_content(query = "Trump", from_date = "2017-01-20", to_date = "2017-01-20")
 
trump %>% 
  filter(!(type %in% c("gallery", "audio", "video", "liveblog"))) %>% 
  filter(!(section_id %in% c("tv-and-radio", 
                             "film",
                             "football",
                             "stage",
                             "theguardian",
                             "lifeandstyle",
                             "sport",
                             "media",
                             "travel",
                             "music",
                             "artanddesign",
                             "books",
                             "fashion"))) %>% 
   select(c(id, web_publication_date, pillar_name, headline, 
   standfirst, body_text)) %>%
  mutate(id = row_number()) %>%
  write_csv("episodes/data/trump.csv")

# read in files -----------------------------------------------------------

trumpOrg <- read_csv("episodes/data/trump.csv")
obamaOrg <- read_csv("episodes/data/obama.csv")


# tilrette datasæt --------------------------------------------------------

trump <- trumpOrg %>% 
  mutate(president = "trump", .after = id)

obama <- obamaOrg %>% 
  mutate(president = "obama", .after = id)

obamaTrump <- obama %>% 
  rbind(trump) %>% 
  mutate(id = row_number()) %>% 
  mutate(standfirst = str_replace_na(standfirst, replacement = "")) %>% 
  mutate(text = str_c(headline, standfirst, body_text, sep = " "), .after = president) %>% 
  select(-c(headline, standfirst, body_text))

write_csv(obamaTrump, "episodes/data/obamaTrump.csv")

articles <- read_csv("episodes/data/obamaTrump.csv")

articles_tidy <- articles %>% 
  unnest_tokens(word, text)
