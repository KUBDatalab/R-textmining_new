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
First,  create a vector with the word you wish to remove from the stopwords list
 

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

## Sentiment analysis
Sentiment analysis is a method for measuring the sentiment of a text. To do this, it is necessary to have a list of words that have been assigned to a certain sentiment. This can be a simple assignation of words into positive and negative, it can be an assignation to one among a multitude of categories, and the word can have a value on a scale. In this course we will use the AFINN index for Danish, which assigns approximately 3500 words on a scale from +5 to -5. This will enable us to calculate and compare the overall sentiment of the various speeches. As a side note, AFINN index is also available in English. 

We need to download the AFINN Index from GitHub


``` r
download.file("https://raw.githubusercontent.com/KUBDatalab/R-textmining/main/data/AFINN_dansk.csv", "data/AFINN_dansk.csv", mode = "wb")
```

Now we read need to read the AFINN Index into a tibble and rename the columns





``` r
AFINN_dansk <- read_csv("data/AFINN_dansk.csv")
```

## Bringing it all together: joins
We have now created tibbles, each with the words appropriate for removal of stopwords and application of sentiment analysis respectively. Now we need to bring them together in the correct order, and we do this by using join-functions. The join functions from the tidyverse library allow tibbles to be joined together based on columns that have cells where the content is the same in both tibbles.

There are fundamentally 2 types of joins:
* Mutating joins (which add columns)
* Filtering joins (which filter away rows)

Mutating joins work by adding new columns to the tibble. We will use left_join, which is the most common of the mutating joins
![”left_join AFINN Index with tidy text](../fig/Venn_left_join.jpg)
The left_join joins all AFINN sentiment values to those rows that contain a word that is in the AFINN Index and adds it as a new column to the tibble. In the new column, the rows that contain words that don't appear in the AFINN Index have NA in their cell

Filtering joins work by filtering away some rows in the tibble. We will use the anti_join, which removes those rows that contain a word that is also in the stopword list
![”anti_join stopwords with tidy text](../fig/Venn_anti_join.jpg)

For more info on joins see [R for Data Science section section 13: Relational data](https://r4ds.had.co.nz/relational-data.html)

We will use the anti_join first, beause we need to filter away stopwords before we analyse the text with sentiment analysis


``` r
kina_tidy_2 <- kina_tidy %>% 
  anti_join(stopwords_dansk, by = "word") %>% #stopwords in Danish
  left_join(AFINN_dansk, by = "word") #left join with AFINN Index in Danish
```

``` error
Error: object 'kina_tidy' not found
```

## Analyzing the sentiment of parties
We would like to measure the sentiment of each party when giving speeches on the topic of China

First we need to calculate the mean sentiment value for each party. We save it as an object so that we can easily recall it for visualization


``` r
kina_sentiment_value <- kina_tidy_2 %>% 
  filter(Role != "formand") %>% 
  group_by(Party) %>% 
  summarize(
    mean_sentiment_value = mean(sentiment_value, na.rm=TRUE)
  )
```

``` error
Error: object 'kina_tidy_2' not found
```

Now we want to visualize each party's mean sentiment value according to the AFINN-Index


``` r
kina_sentiment_value %>% 
  ggplot(aes(x = Party, y = mean_sentiment_value, fill = Party)) + 
  geom_col() +
  labs(x= "Party")
```

``` error
Error: object 'kina_sentiment_value' not found
```

## Analyzing the sentiment of rød and blå blok
We would also like to analyze the sentiment of rød and blå blok as a whole respectively. To do this, we need to add a column to each row that specifies whether the word comes from a member of a party in rød blok or blå blok. We must therefore first define which parties make up rød and blå blok and put that in a tibble, then bind the two tibbles into one tibble, and then make a left_join to the rows in our tidy text


``` r
roed_blok <- tibble(Party = c("ALT", "EL", "SF", "S", "RV"), Blok = c("roed_blok"))
blaa_blok <- tibble(Party = c("V", "KF", "LA", "DF"), Blok = c("blaa_blok"))
blok <- bind_rows(roed_blok, blaa_blok)
kina_tidy_blokke <- kina_sentiment_value %>% 
  left_join(blok, by = "Party")
```

``` error
Error: object 'kina_sentiment_value' not found
```

Now we would like to do the same analysis of mean sentiment value, this time for each blok. We also want to specify that the column for roed_bloek should be red and the column for blaa_blok should be blue


``` r
kina_blokke_sentiment_value <- kina_tidy_blokke %>% 
  group_by(Blok) %>% 
  summarize(
    mean_sentiment_value = mean(mean_sentiment_value, na.rm=TRUE)
  )
```

``` error
Error: object 'kina_tidy_blokke' not found
```



``` r
kina_blokke_sentiment_value %>% 
  ggplot(aes(x = Blok, y = mean_sentiment_value, fill = Blok)) + 
  geom_col() +
  scale_fill_manual(values = c("blue", "red")) +
  labs(x= "Blok")
```

``` error
Error: object 'kina_blokke_sentiment_value' not found
```

::::::::::::::::::::::::::::::::::::: keypoints 

- "All natural language texts must be prepared for analysis"

::::::::::::::::::::::::::::::::::::::::::::::::
