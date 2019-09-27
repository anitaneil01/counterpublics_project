require(rio)
require(quanteda)
require(tidyverse)
library(readr)

##Step 1.1: importing data (#metoo) & deleting columns I don't need (url & tweet-id)

metoo_part1 <- rio::import("PFAD für das Dokument")
View(metoo_part1)
metoo_1 <- names(metoo_part1) %in% c("url","tweet-id")
newdata <- metoo_part1[!metoo_1]
View(newdata)
metoo_1_new <- newdata
View(metoo_1_new)

metoo_part2 <- rio::import("PFAD für das Dokument")
metoo_2 <- names(metoo_part2) %in% c("url","tweet-id")
newdata_2 <- metoo_part2[!metoo_2]
metoo_2_new <- newdata
View(metoo_2_new)

metoo_part3 <- rio::import("PFAD für das Dokument")
metoo_3 <- names(metoo_part3) %in% c("url","tweet-id")
newdata_3 <- metoo_part3[!metoo_3]
metoo_3_new <- newdata
View(metoo_3_new)

metoo_part1.1 <- rio::import("PFAD für das Dokument")
View(metoo_part1.1)
metoo_1.1 <- names(metoo_part1.1) %in% c("url","tweet-id")
newdata_1.1 <- metoo_part1.1[!metoo_1.1]
View(newdata_1.1)
metoo_1.1_new <- newdata_1.1
View(metoo_1.1_new)

metoo_part2.1 <- rio::import("PFAD für das Dokument")
metoo_2.1 <- names(metoo_part2.1) %in% c("url","tweet-id")
newdata_2.1 <- metoo_part2.1[!metoo_2.1]
metoo_2.1_new <- newdata_2.1
View(metoo_2.1_new)

metoo_part3.1 <- rio::import("PFAD für das Dokument")
metoo_3.1 <- names(metoo_part3.1) %in% c("url","tweet-id")
newdata_3.1 <- metoo_part3.1[!metoo_3.1]
metoo_3.1_new <- newdata_3.1
View(metoo_3.1_new)

##Step 2: Merging the datasets into one (vertically) creating one dataframe with all the tweets with #metoo

hashtag_metoo <- rbind(metoo_1_new, metoo_2_new, metoo_3_new)
View(hashtag_metoo)

MeToo <- rbind(metoo_1.1_new, metoo_2.1_new, metoo_3.1_new)
View(MeToo)

##Step X: Import Text files

