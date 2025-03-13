---
title: "Word frequency analysis"
teaching: 0
exercises: 0
---


:::::::::::::::::::::::::::::::::::::: questions 

- "How can we find the most frequent terms from each party?"

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- "Learning how to analyze term frequency and visualize it"


::::::::::::::::::::::::::::::::::::::::::::::::





## Frequency analysis

A word frequency is a relatively simple analysis. It meassures how often words occur in a text. 



``` r
articles_anti_join %>% 
  count(word, sort = TRUE)
```

``` output
# A tibble: 12,328 × 2
   word             n
   <chr>        <int>
 1 obama          513
 2 trump          479
 3 president      450
 4 people         337
 5 inauguration   249
 6 america        237
 7 world          212
 8 american       201
 9 time           189
10 day            188
# ℹ 12,318 more rows
```

The previous code chunk resulted in a list containing the most frequent words. The words are from articles about both presidents, and they are sorted based on frequency with the highest number on top.

A closer look at the list may reveal that some words are irrelevant. Given that the articles in the dataset are about the two presidents' respective inaugurations, we consider the words below irrelevant for our analysis. Therefore, we make a new dataset without those words.


``` r
articles_filtered <- articles_anti_join %>%
  filter(!word %in% c("trump", "trump’s", "obama", "obama's", "inauguration", "president"))

articles_filtered %>% 
  count(word, sort = TRUE)
```

``` output
# A tibble: 12,322 × 2
   word           n
   <chr>      <int>
 1 people       337
 2 america      237
 3 world        212
 4 american     201
 5 time         189
 6 day          188
 7 bush         186
 8 speech       183
 9 white        180
10 washington   150
# ℹ 12,312 more rows
```
The words deemed irrelevant are no longer on the list above.

Instead of a general list it may be more interesting to focus on the most frequent words belonging to articles about the two presidents respectively.


``` r
articles_filtered %>%
  count(president, word, sort = TRUE)
```

``` output
# A tibble: 15,989 × 3
   president word         n
   <chr>     <chr>    <int>
 1 obama     bush       174
 2 obama     people     170
 3 trump     people     167
 4 obama     america    123
 5 obama     speech     121
 6 obama     world      120
 7 obama     time       119
 8 obama     american   116
 9 trump     america    114
10 trump     it’s       108
# ℹ 15,979 more rows
```
It can be a bit tricky to keep an overview of the words associated with each president. For instance, the people is associated with both presidents. This is easy to see, as the two words are right next to each other. America, however, are further apart, although this word i also associated with the presidents. To that end, a visualisation may help.



``` r
articles_filtered %>%
  count(president, word, sort = TRUE) %>% 
  group_by(president) %>%
  slice(1:10) %>% 
  ggplot(mapping = aes(x = n, y = word, colour = president, shape = president)) +
  geom_point() 
```

<img src="fig/03-frequency-analysis-rendered-unnamed-chunk-5-1.png" style="display: block; margin: auto;" />
The plot above shows the top-ten words associated Obamma and Trump respectively. If a word features on both presidents' top-ten list, it only occures once in the plot. This is why the plot doesn't contain 20 words in total.

Another interesting aspect to look at would be the most frequent words used in relation to each president. In this analysis the president is the guiding principle.


``` r
articles_filtered %>%
  count(president, word, sort = TRUE) %>% 
  pivot_wider(
    names_from = president,
    values_from = n
  )
```

``` output
# A tibble: 12,322 × 3
   word     obama trump
   <chr>    <int> <int>
 1 bush       174    12
 2 people     170   167
 3 america    123   114
 4 speech     121    62
 5 world      120    92
 6 time       119    70
 7 american   116    85
 8 it’s        NA   108
 9 day        106    82
10 donald       1   106
# ℹ 12,312 more rows
```


``` r
articles_filtered %>%
  group_by(president) %>% 
  count(word, sort = TRUE) %>% 
  top_n(10) %>% 
  ungroup() %>% 
  mutate(word = reorder_within(word, n, president)) %>% 
  ggplot(aes(n, word, fill = president)) +
  geom_col() +
  facet_wrap(~president, scales = "free") +
  scale_y_reordered() + 
  labs(x = "word occurrences")
```

``` output
Selecting by n
```

<img src="fig/03-frequency-analysis-rendered-unnamed-chunk-7-1.png" style="display: block; margin: auto;" />
The analyses just made can easily be ajusted. For instance, if we want look at the words by `pillar_name` instead of by `president`, we just need to replace `president` with `pillar_name` in the code.


``` r
articles_filtered %>%
  count(pillar_name, word, sort = TRUE) %>% 
  group_by(pillar_name) %>%
  slice(1:10) %>% 
  ggplot(mapping = aes(x = n, y = word, colour = pillar_name, shape = pillar_name)) +
  geom_point() 
```

<img src="fig/03-frequency-analysis-rendered-unnamed-chunk-8-1.png" style="display: block; margin: auto;" />





















``` error
Error: '../data/kina.txt' does not exist in current working directory ('/home/runner/work/R-textmining_new/R-textmining_new/site/built').
```

``` error
Error: object 'kina' not found
```

``` error
Error: object 'kina_tidy' not found
```

``` error
Error: object 'kina_tidy_2' not found
```

## Word frequency
Now that we have seen the average sentiment of the parties, we want to get a deeper understanding of what they talk about when discussing China. We can calculate the most frequent words that each party uses, and then visualize that to get an impression of what they talk about when discussing China.

First we calculate the 10 most frequent words that each party says


``` r
kina_top_10_ord <- kina_tidy_blokke %>% 
  filter(Role != "formand") %>% 
  group_by(Party) %>% 
  count(word, sort = TRUE) %>%
  top_n(10) %>% 
  ungroup() %>% 
  mutate(word = reorder_within(word, n, Party))
```

``` error
Error: object 'kina_tidy_blokke' not found
```

Now we want to visualize the result


``` r
kina_top_10_ord %>% 
  ggplot(aes(n, word, fill = Party)) +
  geom_col() + 
  facet_wrap(~Party, scales = "free") +
  scale_y_reordered() +
  labs(x = "Word occurrences")
```

``` error
Error: object 'kina_top_10_ord' not found
```

A  more extensive stopword list for Danish is the ISO stopword list. We will use it know, so lets download it from the repository. Then we save it as an object. Then we make it into a tibble to prepare it for `anti_join` with our dataset


``` r
download.file("https://raw.githubusercontent.com/KUBDatalab/R-textmining/main/data/iso_stopwords.csv", "data/iso_stopwords.csv", mode = "wb")
```




``` r
iso_stopwords <- read_csv("data/iso_stopwords.csv")
```


Let us now apply it to the dataset by `anti_join`


``` r
kina_top_10_ord_2 <- kina_tidy_blokke %>% 
  anti_join(iso_stopwords, by = "word")
```

``` error
Error: object 'kina_tidy_blokke' not found
```


Unfortunately for us, most of the most common words are words that act like stopwords, carrying no meaning in themselves. To get around this, we can create our own custom list of stopwords as a tibble, and then `anti_join` it with the dataset, just like we did for the already existing stopword lists.

First we look at the top words to find the stopwords for our custom stopword list. Here I have printed 10, but I have looked at over 70


``` r
kina_top_10_ord_2 %>% 
  count(word, sort = TRUE) %>% 
  top_n(10) %>% 
  tbl_df %>% 
  print(n=10)
```

``` error
Error: object 'kina_top_10_ord_2' not found
```


Based on this, we select the words that we consider stopwords and make them into a tibble. We also want to include among our stopwords the word Danmark and its genitive case and derivative adjectives, because Denmark of course is frequently named in a Danish parliamentary debate and adds little to our analysis and understanding. Let's also remove the name China, its genitive case and derivative adjectives, because we know that the debate is about China. Let's also remove words that state the title or role of a member of the parliament. Let's also remove the words spørgsmål and møder, as it relates internal questions and meetings among the members of parliament. Let's also remove the words about Folketingets Præsidium, which do not pertain to the content of the debate. Upon later examinations some more names have also been added to the custom stopword list



``` r
custom_stopwords <- tibble(word = c("så", "kan", "hr", "sige", "synes", "ved", "altså", "søren", "tror", 
                                    "få", "bare", "derfor", "godt", "andre", "må", "espersen", "mener", "gøre", "helt", "dag", 
                                    "faktisk", "folkeparti", "gerne", "side", "gør", "nogen", "fordi", "hvordan", "tak",
                                    "måde", "set", "siger", "andet", "sagt", "år", "lige", "står", "tage", "nemlig", "lidt",
                                    "sag", "går", "kommer", "nok", "danmark", "danmarks", "dansk", "danske", "danskt", 
                                    "kina", "kinas", "kinesisk", "kinesiske", "kinesiskt", "kineser", "kineseren", 
                                    "kinesere", "kineserne", "ordfører", "ordføreren", "ordførerens", "ordførere", "ordførerne", 
                                    "spørgsmål", "møder", "holger", "k", "nielsen", "regering", "regeringen", "regeringens", 
                                    "folketinget", "folketingets", "måske", "forslag", "egentlig", "rigtig", "rigtigt", "rigtige", 
                                    "hvert", "bør", "grund", "vigtig", "vigtigt", "vigtige", "ting", "ønsker", "fru", "hr", 
                                    "selvfølgelig", "gange", "præcis", "sagde", "hele", "fald", "enhedslisten", "sidste", 
                                    "forstå", "betyder", "alliances", "fortsat", "venstre", "holde", "præsidium", "baseret",
                                    "lande", "land", "gjorde", "pind", "simpelt", "frem", "præsidiet", "præsidium", 
                                    "dokument", "tale", "hen", "o.k", "alverden", "angiveligt"))
```

We then do an `anti_join` of our custom stopword list to our tidy text


``` r
kina_top_10_ord_3 <- kina_top_10_ord_2 %>% 
  anti_join(custom_stopwords, by = "word")
```

``` error
Error: object 'kina_top_10_ord_2' not found
```

Let's now calculate the top 10 words from each party and save it as an object


``` r
kina_top_10_ord_4 <- kina_top_10_ord_3 %>% 
  filter(Role != "formand") %>% 
  group_by(Party) %>% 
  count(word, sort = TRUE) %>%
  top_n(10) %>% 
  ungroup() %>% 
  mutate(word = reorder_within(word, n, Party))
```

``` error
Error: object 'kina_top_10_ord_3' not found
```

Let us now plot the result


``` r
kina_top_10_ord_4 %>% 
  ggplot(aes(n, word, fill = Party)) +
  geom_col() + 
  facet_wrap(~Party, scales = "free") +
  scale_y_reordered() +
  labs(x = "Word occurrences")
```

``` error
Error: object 'kina_top_10_ord_4' not found
```

## tf_idf
We see that many words co-occur among the parties. How can we make a plot of what each party talks about that the others don't?
We can use the tf_idf calculation. Briefly, tf_idf in this case looks at the words that occur among each party, and gives a high value to those that frequently occur in one party but rarely occur among the other parties. This will give us a sense of what each party emphasizes in their speeches about China

First we need to calculate the tf_idf of each word in our tidy text

``` r
kina_tidy_tf_idf <- kina_top_10_ord_3 %>% 
  filter(Role != "formand") %>% 
  count(Party, word, sort = TRUE) %>% 
  bind_tf_idf(word, Party, n) %>% 
  arrange(desc(tf_idf))
```

``` error
Error: object 'kina_top_10_ord_3' not found
```

Now we want to select each party's 10 words that have the highest tf_idf


``` r
kina_tidy_tf_idf_top_10 <- kina_tidy_tf_idf %>% 
  group_by(Party) %>% 
  top_n(10) %>% 
  ungroup() %>% 
  mutate(word = reorder_within(word, tf_idf, Party))
```

``` error
Error: object 'kina_tidy_tf_idf' not found
```


Now let's make our plot.


``` r
kina_tidy_tf_idf_top_10 %>%  
  ggplot(aes(tf_idf, word, fill = Party)) +
  geom_col() +
  facet_wrap(~Party, scales = "free") +
  scale_y_reordered() +
  labs(x = "tf_idf")
```

``` error
Error: object 'kina_tidy_tf_idf_top_10' not found
```

::::::::::::::::::::::::::::::::::::: keypoints 

- "Custom stopword list may be necessary depending on the context"


::::::::::::::::::::::::::::::::::::::::::::::::
