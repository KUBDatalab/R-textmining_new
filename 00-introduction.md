---
title: 'Introduction'
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- What is text mining?
- What is tidy text?
- What is stop words?


::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Explain what text mining is
- Explain what tidy text is
- Explain what stop words is

::::::::::::::::::::::::::::::::::::::::::::::::

## What is text mining?
Text mining is the process of extracting useful information and knowledge from 
unstructured text. These analyses can enable insight into a collection of text 
that can be difficult to spot with the naked eye. 

Text mining tools allow the user to analyze large samples of texts and 
visualize the results.

## What is tidy text (overskrift skal ændres så den ikke er så teknisk)
In order to be able to use text mining tools on your data it is important to 
have the data in a format that can easily be used by a machine.

In the course we will work with the format tidy text.

:::: callout

## Tidy text

The tidy text concept is developed by Silge and Robinson (reference tilføjes - 
https://www.tidytextmining.com), and applies the principles from the tidy data 
to text.

The tidy data framework, principles are:

Each variable forms a column.
Each observation forms a row.
Each type of observational unit forms a table.

Applying these principles to text data, leads to a format that is easy to 
manipulate, visualize, and analyze using standard data science tools.

::::::






## Introduction to tidytext and tokenization

To analyze the speeches we need to make the text tidy. Tidy text refers to a dataset where each text has been split up into the individual words that make up the speech, and in format where each row contains one word. ![Tidy text example](../fig/Tidy_text.png)

Splitting texts, in our case speeches, into individual words is called tokenization ![Tokenization of example sentence](../fig/Tokenization.png)
Hvitfeldt & Silge, 2021

Tokenization of text into individual words is necessary for text mining because it allows us to analyze the text closely and in detail, analyses which can later be visualized to understand the patterns of the text. Tokenization is language independent, as long as the language is written in an alphabet or syllabary that uses spaces between words. When tokenizing our text to make it tidy, the metadata that describe the whole speech are carried over to also describe the individual word. Thus we can split the text into individual words but still keep track of who said that word and when they did.

We use the tidytext library for tokenization



``` r
kina_tidy <- kina %>% 
  unnest_tokens(word, Text) #tidytext tokenization
```

``` error
Error in kina %>% unnest_tokens(word, Text): could not find function "%>%"
```


## Stopwords
In all natural language texts, frequent words that carry little meaning by themselves are distributed all across the text ![”Stopwords examples](../fig/Stopwords.png)

The frequent low-meaning words need to be removed because they do not add anything to our understanding of the texts and are just noise

The tm library contains a list of stopwords for Danish, which we'll make into a tibble. We have to specify that the list of stopwords that we want to call is the list for the Danish language. Note that stopword lists are also available for most major European languages


``` r
stopwords_dansk <- tibble(word = stopwords(kind = "danish"))
```

``` error
Error in tibble(word = stopwords(kind = "danish")): could not find function "tibble"
```














::::::::::::::::::::::::::::::::::::: keypoints 

- Know what text mining is
- Know what tidy text is
- Know what stop words is

::::::::::::::::::::::::::::::::::::::::::::::::

