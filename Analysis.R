require(rvest)
require(tidyverse)
require(rio)
require(quanteda)
library(readr)
library(dplyr)

##Step4 : semantische Analyse (H3)

coding <- rio::import('https://docs.google.com/spreadsheets/d/1nlT1_QND2hh_4xFTQ124uStZnZv8yv8AuZsKLmT7d84/edit#gid=1086542994')
afinn <- readRDS('./afinn.RDS') #Validation!
afinn

readRDS('./regional_validation.RDS') %>% mutate(tid = seq_along(text)) %>% rio::export('./regional_validation.csv')
validation <- readRDS('./regional_validation.RDS')
coding <- rio::import("https://docs.google.com/spreadsheets/d/1nlT1_QND2hh_4xFTQ124uStZnZv8yv8AuZsKLmT7d84/edit#gid=1086542994") #import the google doc
coding
coding$Durchschnitt[2:47] #shows pur gold standard, this is how the computer should code aswell
gold_standard <- coding$Durchschnitt[2:47]
gold_standard

##we create a new corpus and a dfm based on our validation

corpus(validation$content) %>% dfm %>% dfm_lookup(dictionary = afinn) -> val_dfm
val_dfm[1,]
val_dfm[2,]
val_dfm %>% quanteda::convert(to = 'data.frame') %>%
  mutate(afinn_score = (neg5 * -5) + (neg4 * -4) + (neg3 * -3) + (neg2 * -2) +
           (neg1 * -1) + (zero * 0) + (pos1 * 1) + (pos2 * 2) + (pos3 * 3) +
           (pos4 * 4) + (pos5 * 5)) %>% select(afinn_score) -> afinn_score


plot(gold_standard, afinn_score$afinn_score[2:47])

#erstellen von matrix
#dfm(coding$content) %>% dfm_lookup(dictionary = afinn) %>% quanteda ::convert (to = 'data.frame') -> afinn_score

#zählen der wörter in den Artikeln
ntoken(coding$content)

##erstellen des scores fem_liste/ wordcount
coding %>% mutate(wc = ntoken(coding$content))%>% mutate(coding = coding$Durchschnitt / wc) ->  afinn_score
afinn_score

#correlation, low p-value 0,05 and high correlation --> our dictionary is working 
cor.test(afinn_score$coding, coding$Durchschnitt) ## p = 0.00659, cor = 0.390912

plot(x = afinn_score$coding, y = coding$Durchschnitt)

## Semantisches Wb auf Regionalzeitungen anwenden

regional_articles <- readRDS('./Regional_articles.RDS')
View(regional_articles)

#regional_afinn <- dfm_lookup(regional_articles, dictionary = afinn)
afinn

quanteda::convert(regional_afinn, to = 'data.frame') %>%
  mutate(afinn_score = (neg5 * -5) + (neg4 * -4) + (neg3 * -3) + (neg2 * -2) +
           (neg1 * -1) + (zero * 0) + (pos1 * 1) + (pos2 * 2) + (pos3 * 3) +
           (pos4 * 4) + (pos5 * 5)) %>% select(afinn_score) -> afinn_score
  
  #mutate(android = str_detect(docvars(trump_afinn, "source"), "Android")) -> afinn_score

#afinn_score %>% summarize(mean_afinn_score = mean(afinn_score), sd_afinn_score = sd(afinn_score))

#cor(afinn_score$afinn_score, trump_tweets$retweet_count, method = 'spearman')

## Step 5: Community Detection

cp_data <- readRDS('./Twitter_Data.rds')
cp_data

### Step 5.1: defining user as nodes
cp_nodes <- cp_data$user
cp_nodes

##Step 5.2: hashtags extrahieren _ Hypothesen bezügl. Hashtags anschauen!
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch')) -> cp_hash

cp_hash

cp_hash %>% group_by(metoo, timesup, womensmarch) %>% tally ##hier hat er die df in Gruppen sortiert

cp_hash %>% group_by(user) %>% summarise(metoo = any(metoo), timesup = any(timesup), womensmarch = any(womensmarch)) %>% 
  select(user, metoo, timesup, womensmarch) %>% ungroup %>%
  group_by(metoo, timesup, womensmarch) %>% tally ##hier hat er geschaut welche Nutzer welche Hashtags benutzt bzw wer keine benutzt

##Retweet Netzwerk (mit Hashtags)
cp_data %>% filter(str_detect(text, '^RT')) -> cp_rt ##RT steht für retweet im Text

cp_rt %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                 timesup = str_detect(lower_text, '#timesup'), 
                 womensmarch = str_detect(lower_text, '#womensmarch')) %>% filter(metoo) %>%
  mutate(src = str_extract(text, 'RT [a-zA-Z0-9_]+'), src = str_remove(src, '^RT ')) %>% 
  select(src, user) %>% group_by(src, user) %>% tally %>% ungroup %>% rename(weight = 'n')-> cp_edge_list

graph_from_data_frame(cp_edge_list) -> cp_graph

##Step 6: community detection (walktrap)
cp_wc <- cluster_walktrap(cp_graph)

membership(cp_wc) %>% table %>% sort %>% tail(8) %>% names -> large_comm ##tail: die 8 größten Communities - waren am Ende der Liste

V(cp_graph)$comm <- membership(cp_wc) ##H meinet nicht wichtig
delete.vertices(cp_graph, which(!V(cp_graph)$comm %in% large_comm)) ##ebd


cp_hash %>% group_by(user) %>% summarise(metoo = any(metoo), timesup = any(timesup), womensmarch = any(womensmarch)) %>% 
  select(user, metoo, timesup, womensmarch) -> user_hash

user_hash
large_comm

##nach Hashtag-Hypothese schauen!
tibble(user= names(membership(cp_wc)), group = membership(cp_wc)) %>% left_join(user_hash) %>% 
  group_by(group, metoo, timesup, womensmarch) %>% tally %>% filter(group == 5) %>% arrange(n)

tibble(user= names(membership(cp_wc)), group = membership(cp_wc)) %>% left_join(user_hash) %>% 
  group_by(group, metoo, timesup, womensmarch) %>% tally %>% filter(group == 51) %>% arrange(n)


tibble(user= names(membership(cp_wc)), group = membership(cp_wc)) %>% left_join(user_hash) %>% 
  group_by(group, metoo, timesup, womensmarch) %>% tally %>% filter(group == 48) %>% arrange(n)

write.graph(cp_graph, "cp_graph.gml", format = "gml")


##betweenness & co - H5
require(igraph)

##edge:betweenness für uns nicht so relevant
eb <- edge_betweenness(cp_graph, weights = E(cp_graph)$weight) ##gives more accurate calculation of betweenness
View(eb)
which.max(eb) ##the most important edges of this network
E(cp_graph)[517] ##shows exactly which one

betweenness(cp_graph, weights = E(cp_graph)$weight) ##shows how often the structural bridge characters interact with each other

neighborhood(cp_graph)

cp_graph[]
constraint(cp_graph) ##Alyssa_Milano 0.33333

## Coreness
tibble(user= names(membership(cp_wc)), group = membership(cp_wc)) %>% left_join(user_hash) %>% 
  group_by(group, metoo, timesup, womensmarch) %>% tally %>% 
  centrality = coreness(user_hash) %>% arrange(desc(centrality) %>% print(n = 50))


##RT Netzwerk (alle Nennungen - für WUNC!)
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, 'metoo'), 
                   timesup = str_detect(lower_text, 'timesup'), 
                   womensmarch = str_detect(lower_text, 'womensmarch')) -> cp_hash_2

cp_hash_2 %>% group_by(metoo, timesup, womensmarch) %>% tally ##hier hat er die df in Gruppen sortiert

cp_hash_2 %>% group_by(user) %>% summarise(metoo = any(metoo), timesup = any(timesup), womensmarch = any(womensmarch)) %>% 
  select(user, metoo, timesup, womensmarch) %>% ungroup %>%
  group_by(metoo, timesup, womensmarch) %>% tally

cp_rt %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, 'metoo'), 
                 timesup = str_detect(lower_text, 'timesup'), 
                 womensmarch = str_detect(lower_text, 'womensmarch')) %>% filter(metoo) %>%
  mutate(src = str_extract(text, 'RT [a-zA-Z0-9_]+'), src = str_remove(src, '^RT ')) %>% 
  select(src, user) %>% group_by(src, user) %>% tally %>% ungroup %>% rename(weight = 'n')-> cp_edge_list_2

graph_from_data_frame(cp_edge_list_2) -> cp_graph_2

cp_wc_2 <- cluster_walktrap(cp_graph_2)
cp_wc_2 ##370 communities

membership(cp_wc_2) %>% table %>% sort %>% tail(8) %>% names -> large_comm_2##tail: die 8 größten Communities - waren am Ende der Liste
large_comm_2

write_graph(large_comm_2, "large_comm.gml", format = "gml")

V(cp_graph_2)$comm <- membership(cp_wc_2) ##H meinet nicht wichtig
delete.vertices(cp_graph_2, which(!V(cp_graph_2)$comm %in% large_comm)) ##ebd

cp_hash_2 %>% group_by(user) %>% summarise(metoo = any(metoo), timesup = any(timesup), womensmarch = any(womensmarch)) %>% 
  select(user, metoo, timesup, womensmarch) -> user_hash_2

##Gruppe 5 - verwendet auch MeToo am häufigsten, dann MeToo und TimesUp in Kombi & dann alle drei zusammen
tibble(user= names(membership(cp_wc_2)), group = membership(cp_wc_2)) %>% left_join(user_hash_2) %>% 
  group_by(group, metoo, timesup, womensmarch) %>% tally %>% filter(group == 5) %>% arrange(n)

##Gruppe 53 - Leute nutzen metoo und timesup und 1 Person alle drei
tibble(user= names(membership(cp_wc)), group = membership(cp_wc)) %>% left_join(user_hash) %>% 
  group_by(group, metoo, timesup, womensmarch) %>% tally %>% filter(group == 53) %>% arrange(n)

tibble(user= names(membership(cp_wc)), group = membership(cp_wc)) %>% left_join(user_hash) %>% 
  group_by(group, metoo, timesup, womensmarch) %>% tally %>% filter(group == 50) %>% arrange(n)


##Politiker Liste
View(cp_data)
cp_data %>% 
install.packages("")
require(dplyr)
ed_exp5 <- select(filter(education, Region == 2),c(State,Minor.Population:Education.Expenditures))


cp_hash %>% group_by(metoo, timesup, womensmarch) %>% tally ##hier hat er die df in Gruppen sortiert

cp_hash %>% group_by(user) %>% summarise(metoo = any(metoo), timesup = any(timesup), womensmarch = any(womensmarch)) %>% 
  select(user, metoo, timesup, womensmarch) %>% ungroup %>%
  group_by(metoo, timesup, womensmarch) %>% tally ##hier hat er geschaut welche Nutzer welche Hashtags benutzt bzw wer keine benutzt
