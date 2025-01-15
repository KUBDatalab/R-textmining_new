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
tail(articles)
```

``` output
# A tibble: 6 × 5
     id president text                          web_publication_date pillar_name
  <dbl> <chr>     <chr>                         <dttm>               <chr>      
1   132 trump     Buy, George? World's largest… 2017-01-20 15:53:41  News       
2   133 trump     Gove’s ‘snowflake’ tweet is … 2017-01-20 12:44:10  Opinion    
3   134 trump     Monet, Renoir and a £44.2m M… 2017-01-20 04:00:22  News       
4   135 trump     El Chapo is not a Robin Hood… 2017-01-20 17:09:54  News       
5   136 trump     They call it fun, but the di… 2017-01-20 16:19:50  Opinion    
6   137 trump     Totes annoying: words that s… 2017-01-20 12:00:06  News       
```


``` r
# glimpse()
```


``` r
# names()
```


## Tokenisation
We will start out by tokenising the text by using the **tidytext** library.



When tokenising our text to make it tidy, the metadata that describe the whole article are carried over to also describe the individual word. Thus we can split the text into individual words but still keep track of who the article was about.




``` r
#articles_tidy <- voresfil %>% 
  unnest_tokens(word, Text) #tidytext tokenization
```

``` error
Error in UseMethod("pull"): no applicable method for 'pull' applied to an object of class "function"
```


## Stopwords
In all natural language texts, frequent words that carry little meaning by themselves are distributed all across the text ![”Stopwords examples](../fig/Stopwords.png)

The frequent low-meaning words need to be removed because they do not add anything to our understanding of the texts and are just noise

The tm library contains a list of stopwords for Danish, which we'll make into a tibble. We have to specify that the list of stopwords that we want to call is the list for the Danish language. Note that stopword lists are also available for most major European languages


``` r
stopwords_dansk <- tibble(word = stopwords(kind = "danish"))
```


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
