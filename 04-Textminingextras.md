---
title: "Text mining extras"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- "More resources"

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- "Learning about extra tools that can aid your text mining journey"


::::::::::::::::::::::::::::::::::::::::::::::::



## Stopwords for other languages
Stopword lists are available for a range of European languages via the tm library. See documentation on [https://cran.r-project.org/web/packages/tm/tm.pdf p. 38](https://cran.r-project.org/web/packages/tm/tm.pdf p. 38)

To call the stopword list for a certain language and make it a tibble to easily `anti_join` with your tidy text run the following code and insert the name of the language if a stopword list exists for it

``` r
stopwords_your_chosen_language <- as_tibble(stopwords(kind = "yourchosenlanguage"))
```

## Stemming as Natural Language Processing
One data preparation technology that we didn't use in this course is stemming. Stemming takes the inflectional morphological endings typically found at the end of words in Indo-European and Uralic languages and removes them, so that you don't need to put all potential morphological endings in a stopword list to catch all instances of a word. This is especially useful in languages with lots of verb conjugations and noun declensions like the Romance languages and the Slavic languages. BE AWARE that many Danish and English sentiment indexes don't work on stemmed words but take the limited morphological variation in these languages into account. As a rule of thumb, if you want to do sentiment analysis for a Danish or English text, then you are best of with not using stemming

It is possible to stem in a variety of European languages using the Porter-stemmer via the library SnowballC. 
Start by getting of list of which languages the stemmer can handle

``` r
install.packages("SnowballC")
library(SnowballC)
getStemLanguages()
```

Use stemming on the column with text in your tibble

``` r
tibble$stemmed_text <- wordStem(tibble$column_with_text, language = "name of the language")
```


## How to download the full dataset
Go to [https://repository.clarin.dk/repository/xmlui/handle/20.500.12115/44](https://repository.clarin.dk/repository/xmlui/handle/20.500.12115/44) and click the blue button that says: Download all files in item. This will download all approximately 860 files in Zip folder. 
The Zip folder contains zip folders for each year in the dataset, and these zip folders contain the parliament speeches including the metadata that describe them as .txt files.
You need to create a new folder somewhere outside the zip folder environment.
Now you must copy-paste all .txt files to that new folder. You can go into each zip-folder, press Ctrl+a to mark all files, and then press Ctrl+c to copy them. Go to the new folder and press Ctrl+v

To import the files into R as one tibble, you must first set the working directory to your new folder. Then run the following code:

``` r
files <- dir(pattern = "*.txt")

data <- files %>% 
  map(read_delim) %>% 
  reduce(rbind)
```

This may take up to 10 minutes. Once you have read all the files in as one tibble, you want to make it into one new file, so that you can quickly load the whole dataset in next time. Run the following code to write the file but insert the place on the C drive via the tabulator-function and finish the string with the name of your new file and put .txt after the filename:

``` r
write_delim(data, "C:/Users/yourusername/Desktop/Folder/Folketinget/filename.txt")
```

Now you can quickly load it in next time by using `read_delim`. Use `filter` to filter your dataset however you like it. For more info on the `filter` function, see [https://r4ds.had.co.nz/transform.html](https://r4ds.had.co.nz/transform.html) section 2

## Reading other types of files
You can also use `read_csv` to read .csv files in the same manner that you read .txt files

## Recommended materials
I highly recommend the book Text Mining with R: A Tidy Approach, which is openly available at [https://www.tidytextmining.com/](https://www.tidytextmining.com/)
There you can learn more advanced analyses as well as see the application of this course's methods to different datasets

## References
Hvitfeldt, E., & Silge, J. (2021). Supervised Machine Learning for Text Analysis in R (1st ed.). Chapman and Hall/CRC. https://doi.org/10.1201/9781003093459

David Robinson, & Julia Silge. (2017). Text Mining with R. O’Reilly Media, Inc.


::::::::::::::::::::::::::::::::::::: keypoints 

- "Stemming can be useful for Natural Language Processing; Stopword lists are available for many languages"

::::::::::::::::::::::::::::::::::::::::::::::::
