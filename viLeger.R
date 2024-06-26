# libraries ---------------------------------------------------------------
library(tidyverse)
library(tidytext)
library(tm)


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


# tokenization ------------------------------------------------------------

president_tokenized <- obamaTrump %>% 
  unnest_tokens(word, text) %>%
  relocate(word, .after = president)

stopwords <- tibble(word = stopwords(kind = "english"))




