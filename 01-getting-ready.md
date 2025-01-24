---
title: "Loading data"
teaching: 0
exercises: 0
questions:

objectives:

keypoints:
---

:::::::::::::::::::::::::::::::::::::: questions 


- "How do we load in the dataset?"
- "Prering data for analysis"

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- "Be introduced to text mining"
- "Be introduced to loading in text data"
::::::::::::::::::::::::::::::::::::::::::::::::




## Getting startet
When performing text analysis in R, the built-in functions in R are not sufficient. It is therefore necessary to install som additional packages. In this course we will be using `tidyverse`, `tidytext` and `tm`.





``` r
install.packages("tidyverse")
install.packages("tidytext")
install.packages("tm")

library(tidyverse)
library(tidytext)
library(tm)
```


:::: callout
### Documentation for each package
If you would like to know more about the different packages, please click on the links below.

* [tidyverse](https://www.tidyverse.org/packages/)
* [tidytext](https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html)
* [tm](https://cran.r-project.org/web/packages/tm/tm.pdf)

::::::

## Getting data
Begin by downloading the dataset called `articles.csv`. Place the downloaded file in the data/. You can do this directly from R by copying and pasting this in your terminal.


``` r
download.file("https://raw.githubusercontent.com/KUBDatalab/R-textmining_new/main/episodes/data/articles.csv", "data/articles.csv", mode = "wb")
```

After downloading the data you need to load the data in R's memory using the function `read_csv()`


``` r
articles <- read_csv("data/articles.csv", na = c("NA", "NULL", ""))
```

## Data description
The dataset contains newspaper articles from the Guardian. The harvested articles were published on the first inauguration day of each of the two presidents. Inclusion criteria were that the articles had to contain the name of the relevant president, the word "inauguration" and a publication date similar to the inaugration date.

The original dataset contained lots of variables that are irrelevant within the parameters of this course. The following variables were kept:

* `id`
* `president`
* `text`
* `web_publication_date`
* `pillar_name`

::::::::::::::::::::::::::::::::::::: keypoints 

- "Packages must be installed and loaded in, and dataset must be loaded in by typing commands"

::::::::::::::::::::::::::::::::::::::::::::::::
