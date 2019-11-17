##topicmodel für H3 (Regionalzeitungen)
require(rvest)
require(tidyverse)
require(rio)
require(quanteda)
library(readr)
library(dplyr)
require(igraph)
require(stringr)
require(quanteda)
require(stm)
require(tidyverse)
install.packages(c('geometry', 'Rtsne', 'rsvd'))
library(geometry)
library(Rtsne)
library(rsvd)

regional <- readRDS('./Regional_articles.RDS')

regional %>% group_by(source) %>% summarise(n = n()) %>% arrange(desc(n)) %>% print(n = 30)

regional_dfm <- dfm(corpus(regional$content), remove_numbers = TRUE, remove_punct = TRUE, remove_symbols = TRUE, remove = stopwords("english"))
regional_dfm_stem <- dfm_wordstem(regional_dfm)

regional_dfm_processed <- dfm_trim(regional_dfm_stem, min_docfreq = 50)

dfm_tfidf(regional_dfm_processed) %>% textplot_wordcloud(color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'), n = 100)

dfm_stm <- quanteda::convert(regional_dfm_processed, to = "stm")
saveRDS(dfm_stm, "./regional_dfm_stm.RDS")

dfm_stm <- readRDS("./regional_dfm_stm.RDS")

stm_model <- stm(dfm_stm$documents, dfm_stm$vocab, K = 0, data = dfm_stm$meta, init.type = "Spectral", seed = 46709394)
saveRDS(stm_model, "./stm_model.RDS")

labelTopics(stm_model)

#Validation - ich weiß aber nicht was mir das jetzt bringt
set.seed(12901802)
test_sample <- sample(1:49, size = 10)
keywords <- labelTopics(stm_model, n = 4)[[1]][test_sample,]
intruders <- labelTopics(stm_model, n = 321)[[1]][test_sample, 321]

candidates <- cbind(keywords, intruders, rows = 1:15) %>% as_tibble

shuffle_df <- function(x, candidates) {
  res <- candidates[x, sample(1:5)]
  colnames(res) <- c("1", "2", "3", "4", "5")
  return(res)
}
map_dfr(1:10, shuffle_df, candidates = candidates) %>% rio::export("./stm_validate.csv")

#weiter geht:
plot(stm_model, type = "summary")

install.packages('devtools')
install.packages('servr')
library(devtools)
library(servr)
devtools::install_github("cpsievert/LDAvis", force = TRUE)
toLDAvis(stm_model, docs = dfm_stm$documents, reorder.topics = FALSE) ##das ist das coole Schaubild!

theta <- as.data.frame(stm_model$theta) ##if theta for a topic is hight than the article belonged to those topics (0-1)
colnames(theta) <- paste0("topic", 1:49)

regional_theta <- bind_cols(regional, theta)

findTopic(stm_model, c('harass'))
regional_theta %>% arrange(desc(topic48)) %>% select(source, title, topic48, date)
regional_theta %>% filter(source == "Daily Herald") %>% summarise_at(vars(topic1:topic49), mean) %>% t %>% which.max #weiß nicht was das bedeutet

regional_theta %>% filter(str_detect(content, "Me too")) %>% select(topic1:topic49) %>% t %>% which.max -> topic_number
paste0(labelTopics(stm_model)[[1]][topic_number,], collapse = ", ")