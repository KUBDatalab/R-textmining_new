---
title: "Loading data"
teaching: 0
exercises: 0
questions:

objectives:

keypoints:
---

:::::::::::::::::::::::::::::::::::::: questions 

- "What is text mining and how do we load in the dataset?"

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- "To be introduced to text mining and loading in text data"
::::::::::::::::::::::::::::::::::::::::::::::::




## R Markdown
## What is text mining?
Text mining refers to the use of digital tools to enable automatized analyses of text data. These analyses can enable insight into a collection of texts that can be difficult to spot with the naked eye. Furthermore, text mining tools allow the user to analyze large samples of texts and visualize the results

## Installing and loading relevant libraries
We need to install some libraries that can perform the various steps in text analysis, because the base functions of R are not enough. Then we need to load them


``` r
library(tidyverse)
library(tidytext)
library(tm)
```



``` r
install.packages("tidyverse")
install.packages("tidytext")
install.packages("tm")
library(tidyverse)
library(tidytext)
library(tm)
```

Documentation for each package:

* [tidyverse](https://www.tidyverse.org/packages/)
* [tidytext](https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html)
* [tm](https://cran.r-project.org/web/packages/tm/tm.pdf)

## Delimiting and loading dataset
The dataset that we will load is a collection of all debates in the Danish Parliament (Folketinget) from fall 2009 to spring 2017. In the Danish Parliament, every word from every speech in the debates is written in down in the summary. Furthermore, all speeches are described by useful and thorough metadata that allow for insightful analyses. 
The dataset was originally retrieved at https://repository.clarin.dk/repository/xmlui/handle/20.500.12115/44, and has been prepared for today's course. We are going to work with a filtered dataset that contains all parliament speeches on the topic of China. Similarly, debates about any other country could have been filtered for analysis.

**The steps for delimiting the dataset were the following:
We read the dataset into RStudio and saved it as a tibble

data <- read_delim("C:/Users/swha/Desktop/Mappe/R/Tekstanalyse/Folketinget/1 fil 2009-2017/Folketingsreferater_2009_2017_samlet.txt")

We wanted to convert the text in two of the columns to lowercase and save them in the tibble. Converting to lowercase makes filtering better, because we can find instances where the country name, which is normally in uppercase in Danish, appears as part of a compound noun or compound name, which is a common way that nouns and names are joined together to form new words and names in the Danish language
data$\`Agenda title\` <- tolower(data$\`Agenda title\`)
data$Text <- tolower(data$Text)

Now we needed to filter the data to speeches about China and save it as a tibble. We chose to filter on \`Agenda title\`, because it gives the a complete list of speeches about China. If we were to use the speech text itself, we would have missed speeches about China that did not use the the name China or its derivative adjectives, compound nouns and compound names. str_detect allows us to find instances of speeches about China where the name or the adjective appears either on its own  or as part of other words


``` r
data_kina <- data %>% 
  filter(
    str_detect(`Agenda title`, "kina") | str_detect(`Agenda title`, "kines")
  )
```



To check that all the speeches relate to China, we wanted to have a list of all the different \`Agenda title\`s in the filtered data

``` r
unique(data_kina$`Agenda title`)
```



We saw that one of the \`Agenda title\`s had the work "maskinarbejder" in it. The speeches on this \`Agenda title\` obviously don't relate to China, so we filter the speeches on this \`Agenda title\` away


``` r
data_kina <- data_kina %>% 
  filter(
    !str_detect(`Agenda title`, "maskinarbejder")
  ) 
```


Now that the dataset was properly filtered to parliament speeches about China, we wrote it as a txt.-file, so that it can easily be loaded into RStudio by you


``` r
library(tidyverse)

kina <- read_delim("data/kina.txt")
```

*To easily download the dataset there are a couple of steps.
1. Open an RStudio Project. Click on the blue cube to open the `.Rproj`

2. Create a working directory by using the RStudio interface by clicking on the "New Folder" button in the file pane (bottom right), or directly from R by typing at console

``` r
dir.create("data")
```

3. Download the data-file from GitHub and put it in the `data/` you just created. The download link is https://raw.githubusercontent.com/KUBDatalab/R-textmining/main/data/kina.txt. Place the downloaded file in the `data/` you just created. This can be done by copying and pasting this in your terminal [picture of terminal needed here] 

``` r
download.file("https://raw.githubusercontent.com/KUBDatalab/R-textmining/main/data/kina.txt", "data/kina.txt", mode = "wb")
```

The specific path we are using here is dependent on the specific setup. If you have 
followed the recommendations for structuring your project-folder, it should be 
this command:


``` r
library(tidyverse)

kina <- read_delim("data/kina.txt")
```


::::::::::::::::::::::::::::::::::::: keypoints 

- "Packages must be installed and loaded in, and dataset must be loaded in by typing commands"

::::::::::::::::::::::::::::::::::::::::::::::::
