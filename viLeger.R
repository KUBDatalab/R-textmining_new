# libraries and install ---------------------------------------------------------------
install.packages("stopwords")

library(tidyverse)
library(tidytext)
library(tm)
library(stopwords)

# indlæs data -------------------------------------------------------------

obamaTrump <- read_csv("episodes/data/obamaTrump.csv")

# tokenization ------------------------------------------------------------

# tokenizer teksten
president_tokenized <- obamaTrump %>% 
  unnest_tokens(word, text) %>%
  relocate(word, .after = president)

# tæller stopord og kan vise dem at der er en masse som er 'unødvendige'
# skal fjernes - stopord
president_tokenized %>% count(word, sort = TRUE)

# laver en stopordsliste - hvor kommer stopordslisten fra og hvorfor har vi 
# valgt denne
stopwords <- tibble(word = stopwords(kind = "english"))
stopwords_iso <- 
  tibble(word = stopwords::stopwords(language = "en", source = "stopwords-iso"))

#Fjerne stopord fra president_tokenized
president_no_stopwords <- president_tokenized %>% anti_join(stopwords_iso)
 


# frekvens analyse --------------------------------------------------------

# 10 mest brugte ord (tager ikke hensyn til president)
president_no_stopwords %>% 
  count(word, sort = TRUE) %>% 
  top_n(10)

#SKAL DER VÆRE EN SNAK OM AT TILFØJE ORD TIL EN STOPORDSLISTE

president_no_stopwords %>% 
  group_by(president) %>% 
  count(word, sort = TRUE) %>% 
  top_n(10)

# visualisering
president_no_stopwords %>% 
  group_by(president) %>% 
  count(word, sort = TRUE) %>% 
  top_n(10) %>% 
  ggplot(aes(n, word, fill = president)) +
  geom_col() +
  facet_wrap(~president, scales = "free") +
  scale_y_reordered() +
  labs(x = "Word occurrences")
