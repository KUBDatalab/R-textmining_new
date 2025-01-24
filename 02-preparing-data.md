---
title: "Tidytext, stopwords, and sentiment analysis"
teaching: 0
exercises: 0

---

:::::::::::::::::::::::::::::::::::::: questions 

- "How do we prepare text for analysis and measure the sentiment of the text?"

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- "Using specific packages to perform text preparation and sentiment analysis"
::::::::::::::::::::::::::::::::::::::::::::::::




## Taking a quick look at the data

``` r
head(articles)
```

``` output
# A tibble: 6 × 5
     id president text                          web_publication_date pillar_name
  <dbl> <chr>     <chr>                         <dttm>               <chr>      
1     1 obama     "Obama inauguration: We will… 2009-01-20 19:16:38  News       
2     2 obama     "Obama from outer space Whet… 2009-01-20 22:00:00  Opinion    
3     3 obama     "Obama inauguration: today's… 2009-01-20 10:17:27  News       
4     4 obama     "Obama inauguration: Countdo… 2009-01-19 23:01:00  News       
5     5 obama     "Inaugural address of Presid… 2009-01-20 16:07:44  News       
6     6 obama     "Liveblogging the inaugurati… 2009-01-20 13:56:40  News       
```


``` r
glimpse(articles)
```

``` output
Rows: 137
Columns: 5
$ id                   <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15…
$ president            <chr> "obama", "obama", "obama", "obama", "obama", "oba…
$ text                 <chr> "Obama inauguration: We will remake America, vows…
$ web_publication_date <dttm> 2009-01-20 19:16:38, 2009-01-20 22:00:00, 2009-0…
$ pillar_name          <chr> "News", "Opinion", "News", "News", "News", "News"…
```
## Tokenisation
Since we are working with text mining we focus on the `text` coloumn. We do this because the coloumn contains the text from articles.

To tokenise a coloumn, we use the functions `unnest_tokens()` from the `tidytext`-package. The function gets two arguments. The first one is `word`. This defines that the text should be split up by words. The second argument, `text`, defines the column that we want to tokenise.


``` r
articles_tidy <- articles %>% 
  unnest_tokens(word, text)
```

:::: callout

### Tokenisation

The result is 118,269 rows. The reason is that the `text`-column is replaced by a new column named `word`. This columns contains all words found in all of the articles. The information from the remaining columns are kept. This makes is possible to dermine which article each word belongs to.

::::::

## Stopwords
The next step is to remove stopwords. We have chosen to use the stopword list from the package `tidytext`. The list contains 1,149 words that are considered stopwords. Other lists are available, and they differ in terms of how many words they contain.


``` r
data(stop_words)
stop_words
```

``` output
# A tibble: 1,149 × 2
   word        lexicon
   <chr>       <chr>  
 1 a           SMART  
 2 a's         SMART  
 3 able        SMART  
 4 about       SMART  
 5 above       SMART  
 6 according   SMART  
 7 accordingly SMART  
 8 across      SMART  
 9 actually    SMART  
10 after       SMART  
# ℹ 1,139 more rows
```

:::: callout

### Adding and removing stopwords

You may find yourself in need of either adding or removing words from the stopwords list.

Here is how you add and remove stopwords to a predefined list.

**Add stopwords**
First, create a tibble with the word you wish to add to the stop words list


``` r
new_stop_words <- tibble(
  word = c("cat", "dog"),
  lexicon = "my_stopwords"
)
```

Then make a new stopwords tibble based on the original on, but with the new words added.


``` r
updated_stop_words <- stop_words %>%
  bind_rows(new_stop_words)
```

Run the following code to see that the added lexicon `my_stopwords` contains two words.

``` r
updated_stop_words %>% 
  count(lexicon)
```

``` output
# A tibble: 4 × 2
  lexicon          n
  <chr>        <int>
1 SMART          571
2 my_stopwords     2
3 onix           404
4 snowball       174
```



**remove stopword**
First,  create a vector with the word(s) you wish to remove from the stopwords list
 

``` r
words_to_remove <- c("cat", "dog")
```

Then remove the rows containing the unwanted words.

``` r
updated_stop_words <- stop_words %>%
  filter(!word %in% words_to_remove)
```

Run the following code to see that the added lexicon `my_stopwords` nolonger exists.

``` r
updated_stop_words %>% 
  count(lexicon)
```

``` output
# A tibble: 3 × 2
  lexicon      n
  <chr>    <int>
1 SMART      571
2 onix       404
3 snowball   174
```



::::::

In order to remove the stopwords from `articles_tidy`, we have to use the `anti_join`-function. 


``` r
articles_anti_join <- articles_tidy %>% 
  anti_join(stop_words, by = "word")
```

:::: callout

### `Join` and `anti_join`




::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- "All natural language texts must be prepared for analysis"

::::::::::::::::::::::::::::::::::::::::::::::::
