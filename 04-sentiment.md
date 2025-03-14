---
title: "sentiment analysis"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- "More resources"

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- "Learning about extra tools that can aid your text mining journey"


::::::::::::::::::::::::::::::::::::::::::::::::



## Sentiment analysis
Sentiment analysis is a method for measuring the sentiment of a text. When humans read a text they can easily find the sentiment of a paragraph or text based on the meaning of the combined written words.

A machine does not have the same abilities, so instead of having it read the text, we look at the combined words of the text and look at the sentiment of each word and the sentiment of the text/paragraph would be the sum of the sentiments of the words.

In the previous section we had a list of words in the text without stopwords. To do a sentiment analysis we can use a so-called lexicon and assign a sentiment to each word. In order to do this we need an list of words and their sentiment. A simple form would be wether they are positive or negative.

There are multiple sentiment lexicons. For a start we will be using the `bing` lexicon. This lexicon categorises words as either positive or negative.



``` r
get_sentiments("bing")
```

``` output
# A tibble: 6,786 × 2
   word        sentiment
   <chr>       <chr>    
 1 2-faces     negative 
 2 abnormal    negative 
 3 abolish     negative 
 4 abominable  negative 
 5 abominably  negative 
 6 abominate   negative 
 7 abomination negative 
 8 abort       negative 
 9 aborted     negative 
10 aborts      negative 
# ℹ 6,776 more rows
```

To be able to use the `bing`-lexicon, we have to save it.


``` r
bing <- get_sentiments("bing")
```



``` r
articles_filtered %>% 
  inner_join(bing) 
```

``` output
Joining with `by = join_by(word)`
```

``` warning
Warning in inner_join(., bing): Detected an unexpected many-to-many relationship between `x` and `y`.
ℹ Row 48882 of `x` matches multiple rows in `y`.
ℹ Row 2233 of `y` matches multiple rows in `x`.
ℹ If a many-to-many relationship is expected, set `relationship =
  "many-to-many"` to silence this warning.
```

``` output
# A tibble: 6,159 × 6
      id president web_publication_date pillar_name word          sentiment
   <dbl> <chr>     <dttm>               <chr>       <chr>         <chr>    
 1     1 obama     2009-01-20 19:16:38  News        promises      positive 
 2     1 obama     2009-01-20 19:16:38  News        promise       positive 
 3     1 obama     2009-01-20 19:16:38  News        dust          negative 
 4     1 obama     2009-01-20 19:16:38  News        cold          negative 
 5     1 obama     2009-01-20 19:16:38  News        dawn          positive 
 6     1 obama     2009-01-20 19:16:38  News        celebrate     positive 
 7     1 obama     2009-01-20 19:16:38  News        inspirational positive 
 8     1 obama     2009-01-20 19:16:38  News        failed        negative 
 9     1 obama     2009-01-20 19:16:38  News        resound       positive 
10     1 obama     2009-01-20 19:16:38  News        attacks       negative 
# ℹ 6,149 more rows
```

SKRIVE NOGET OM INNER JOIN


``` r
articles_filtered %>% 
  inner_join(bing) %>% 
  count(word, sentiment, sort = TRUE) %>% 
  ungroup() %>% 
  group_by(sentiment) %>% 
  slice_max(n, n = 10) %>% 
  ungroup() %>% 
  mutate(word = reorder(word, n)) %>% 
  ggplot(mapping = aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(x = "Contribution to sentiment", 
       y = NULL)
```

``` output
Joining with `by = join_by(word)`
```

``` warning
Warning in inner_join(., bing): Detected an unexpected many-to-many relationship between `x` and `y`.
ℹ Row 48882 of `x` matches multiple rows in `y`.
ℹ Row 2233 of `y` matches multiple rows in `x`.
ℹ If a many-to-many relationship is expected, set `relationship =
  "many-to-many"` to silence this warning.
```

<img src="fig/04-sentiment-rendered-unnamed-chunk-5-1.png" style="display: block; margin: auto;" />





``` r
articles_filtered %>%
  inner_join(bing) %>% 
  group_by(president) %>% 
  summarise(positive = sum(sentiment == "positive"),
            negative = sum(sentiment == "negative")) 
```

``` output
Joining with `by = join_by(word)`
```

``` warning
Warning in inner_join(., bing): Detected an unexpected many-to-many relationship between `x` and `y`.
ℹ Row 48882 of `x` matches multiple rows in `y`.
ℹ Row 2233 of `y` matches multiple rows in `x`.
ℹ If a many-to-many relationship is expected, set `relationship =
  "many-to-many"` to silence this warning.
```

``` output
# A tibble: 2 × 3
  president positive negative
  <chr>        <int>    <int>
1 obama         1499     1800
2 trump         1160     1700
```
With ´bing´ we only look at the sentiment in binary fashion - a word is either positive or negative. If we try to do similar analysis with AFINN it looks different.


``` r
install.packages("textdata")
```

``` output
The following package(s) will be installed:
- textdata [0.4.5]
These packages will be installed into "~/work/R-textmining_new/R-textmining_new/renv/profiles/lesson-requirements/renv/library/linux-ubuntu-jammy/R-4.4/x86_64-pc-linux-gnu".

# Installing packages --------------------------------------------------------
- Installing textdata ...                       OK [linked from cache]
Successfully installed 1 package in 7 milliseconds.
```

``` r
library(textdata)
```






``` r
afinn <- get_sentiments("afinn")
```

``` output
Do you want to download:
 Name: AFINN-111 
 URL: http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010 
 License: Open Database License (ODbL) v1.0 
 Size: 78 KB (cleaned 59 KB) 
 Download mechanism: https 
```

``` error
Error in menu(choices = c("Yes", "No"), title = title): menu() cannot be used non-interactively
```



``` r
articles_filtered %>% 
  inner_join(afinn) 
```

``` error
Error: object 'afinn' not found
```


``` r
articles_filtered %>%
  inner_join(afinn) %>% 
  group_by(president) %>% 
  summarise(sentiment = sum(value))
```

``` error
Error: object 'afinn' not found
```




``` r
articles_filtered %>%
  inner_join(afinn) %>% 
  group_by(president, value) %>% 
  summarise(sentiment = sum(value)) %>% 
  ggplot(mapping = aes(x = value, y = sentiment, fill = value)) +
  geom_col() + 
  facet_wrap(~president)
```

``` error
Error: object 'afinn' not found
```


``` r
articles_filtered %>% 
  inner_join(afinn) %>% 
  count(president, word, value, sort = TRUE) %>% 
  ungroup() %>% 
  group_by(president, value) %>% 
  slice_max(n, n = 3) %>% 
  ungroup() %>% 
  mutate(word = reorder(word, n)) %>% 
  ggplot(mapping = aes(n, word, fill = president)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~value, scales = "free_y") +
  labs(x = "Contribution to sentiment", 
       y = NULL)
```

``` error
Error: object 'afinn' not found
```




::::::::::::::::::::::::::::::::::::: keypoints 

- "Stemming can be useful for Natural Language Processing; Stopword lists are available for many languages"

::::::::::::::::::::::::::::::::::::::::::::::::
