require(rio)
require(quanteda)
require(tidyverse)
library(readr)
library(dplyr)
require(igraph)

##Step 1: importing data & deleting columns I don't need (url & tweet-id)
##Step 1.1: MeToo
metoo_part1 <- rio::import("./Twitter Daten/#metoo-p1.csv.Rds")
View(metoo_part1)
metoo_1 <- names(metoo_part1) %in% c("url")
newdata <- metoo_part1[!metoo_1]
View(newdata)
metoo_1_new <- newdata
View(metoo_1_new)

metoo_part2 <- rio::import("./Twitter Daten/#metoo-p2.csv.Rds")
metoo_2 <- names(metoo_part2) %in% c("url")
newdata_2 <- metoo_part2[!metoo_2]
metoo_2_new <- newdata
View(metoo_2_new)

metoo_part3 <- rio::import("./Twitter Daten/#metoo-p3.csv.Rds")
metoo_3 <- names(metoo_part3) %in% c("url")
newdata_3 <- metoo_part3[!metoo_3]
metoo_3_new <- newdata
View(metoo_3_new)

metoo_part1.1 <- rio::import("./Twitter Daten/metoo-p1.csv.Rds")
View(metoo_part1.1)
metoo_1.1 <- names(metoo_part1.1) %in% c("url")
newdata_1.1 <- metoo_part1.1[!metoo_1.1]
View(newdata_1.1)
metoo_1.1_new <- newdata_1.1
View(metoo_1.1_new)

metoo_part2.1 <- rio::import("./Twitter Daten/metoo-p2.csv.Rds")
metoo_2.1 <- names(metoo_part2.1) %in% c("url")
newdata_2.1 <- metoo_part2.1[!metoo_2.1]
metoo_2.1_new <- newdata_2.1
View(metoo_2.1_new)

metoo_part3.1 <- rio::import("./Twitter Daten/metoo-p3.csv.Rds")
metoo_3.1 <- names(metoo_part3.1) %in% c("url")
newdata_3.1 <- metoo_part3.1[!metoo_3.1]
metoo_3.1_new <- newdata_3.1
View(metoo_3.1_new)

##Step 1.2: Merging the datasets into one (vertically) creating one dataframe with all the tweets with #metoo

hashtag_metoo <- rbind(metoo_1_new, metoo_2_new, metoo_3_new)
View(hashtag_metoo)

MeToo <- rbind(metoo_1.1_new, metoo_2.1_new, metoo_3.1_new)
View(MeToo)

##Step 1.3: Cleaning the data, i.e. removing duplicates, removing duplicates from the two datasets - hashtag_metoo & MeToo

hashtag_metoo_1 <- as_tibble(hashtag_metoo) ##tibble for easier analysis
hashtag_metoo_1 %>% distinct(text, .keep_all = TRUE) -> hashtag_metoo_clean
View(hashtag_metoo_clean)

MeToo_1 <- as_tibble(MeToo)
MeToo_1
MeToo_1 %>% distinct(text, .keep_all = TRUE) -> MeToo_clean
MeToo_clean
View(MeToo_clean)

##Step 1.4: merging the two datasets so that I have one MeToo dataframe with all the tweets - hashtag & text
MeToo_new <- rbind(hashtag_metoo_clean, MeToo_clean)
View(MeToo_new)
MeToo_new <- as_tibble(MeToo_new)
MeToo_new

##Step 1.5: removing duplicates from the big dataset
MeToo_new %>% distinct(text, .keep_all = TRUE) -> MeToo_complete
MeToo_complete ##final MeToo data
View(MeToo_complete)
MeToo_complete <- as_tibble(MeToo_complete)
View(MeToo_complete)

##Importing Women's March
womensmarch_part1 <- rio::import("./Twitter Daten/#womensmarch-p1.csv.Rds")
View(womensmarch_part1)
womensmarch_1 <- names(womensmarch_part1) %in% c("url")
newdata_wm <- womensmarch_part1[!womensmarch_1]
View(newdata_wm)
womensmarch_1_new <- newdata_wm 
View(womensmarch_1_new)

womensmarch_part2 <- rio::import("./Twitter Daten/#womensmarch-p2.csv.Rds")
View(womensmarch_part2)
womensmarch_2 <- names(womensmarch_part2) %in% c("url")
newdata_wm_2 <- womensmarch_part2[!womensmarch_2]
View(newdata_wm_2)
womensmarch_2_new <- newdata_wm_2
View(womensmarch_2_new)

womensmarch_part3 <- rio::import("./Twitter Daten/#womensmarch-p3.csv.Rds")
View(womensmarch_part3)
womensmarch_3 <- names(womensmarch_part3) %in% c("url")
newdata_wm_3 <- womensmarch_part3[!womensmarch_3]
View(newdata_wm_3)
womensmarch_3_new <- newdata_wm_3
View(womensmarch_3_new)

womensmarch_part1.1 <- rio::import("./Twitter Daten/womensmarch-p1.csv.Rds")
View(womensmarch_part1.1)
womensmarch_1.1 <- names(womensmarch_part1.1) %in% c("url")
newdata_wm_1.1 <- womensmarch_part1.1[!womensmarch_1.1]
View(newdata_wm_1.1)
womensmarch_1.1_new <- newdata_wm_1.1
View(womensmarch_1.1_new)

womensmarch_part1.2 <- rio::import("./Twitter Daten/womensmarch-p2.csv.Rds")
View(womensmarch_part1.2)
womensmarch_1.2 <- names(womensmarch_part1.2) %in% c("url")
newdata_wm_1.2 <- womensmarch_part1.2[!womensmarch_1.2]
View(newdata_wm_1.2)
womensmarch_1.2_new <- newdata_wm_1.2
View(womensmarch_1.2_new)

womensmarch_part1.3 <- rio::import("./Twitter Daten/womensmarch-p3.csv.Rds")
View(womensmarch_part1.3)
womensmarch_1.3 <- names(womensmarch_part1.3) %in% c("url")
newdata_wm_1.3 <- womensmarch_part1.3[!womensmarch_1.3]
View(newdata_wm_1.3)
womensmarch_1.3_new <- newdata_wm_1.3
View(womensmarch_1.3_new)

## Merging the datasets into one (vertically) creating one dataframe with all the tweets with #womensmarch

hashtag_wm <- rbind(womensmarch_1_new, womensmarch_2_new, womensmarch_3_new)
View(hashtag_wm)

WM <- rbind(womensmarch_1.1_new, womensmarch_1.2_new, womensmarch_1.3_new)
View(WM)

##Cleaning the data, i.e. removing duplicates
##removing duplicates from the two datasets - hashtag_wm & WomensMarch

hashtag_wm_1 <- as_tibble(hashtag_wm) ##tibble for easier analysis
hashtag_wm_1 %>% distinct(text, .keep_all = TRUE) -> hashtag_wm_clean
View(hashtag_wm_clean)

WM_1 <- as_tibble(WM)
WM_1
WM_1 %>% distinct(text, .keep_all = TRUE) -> WM_clean
WM_clean
View(WM_clean)

##Merging the two datasets so that I have one MeToo dataframe with all the tweets - hashtag & text
WM_new <- rbind(hashtag_wm_clean, WM_clean)
View(WM_new)
WM_new <- as_tibble(WM_new)
WM_new

## removing duplicates from the big dataset
WM_new %>% distinct(text, .keep_all = TRUE) -> WM_complete
WM_complete ##final MeToo data
View(WM_complete)
WM_complete <- as_tibble(WM_complete)
View(WM_complete)


##Importing Time's Up
timesup_part1 <- rio::import("./Twitter Daten/#timesup-p1.csv.Rds")
View(timesup_part1)
timesup_1 <- names(timesup_part1) %in% c("url")
newdata_tu <- timesup_part1[!timesup_1]
View(newdata_tu)
timesup_1_new <- newdata_tu 
View(timesup_1_new)

timesup_part2 <- rio::import("./Twitter Daten/#timesup-p2.csv.Rds")
View(timesup_part2)
timesup_2 <- names(timesup_part2) %in% c("url")
newdata_tu_2 <- timesup_part2[!timesup_2]
View(newdata_tu_2)
timesup_2_new <- newdata_tu_2 
View(timesup_2_new)

timesup_part3 <- rio::import("./Twitter Daten/#timesup-p3.csv.Rds")
View(timesup_part3)
timesup_3 <- names(timesup_part3) %in% c("url")
newdata_tu_3 <- timesup_part3[!timesup_3]
View(newdata_tu_3)
timesup_3_new <- newdata_tu_3 
View(timesup_3_new)

timesup_part1.1 <- rio::import("./Twitter Daten/timesup-p1.csv.Rds")
View(timesup_part1.1)
timesup_1.1 <- names(timesup_part1.1) %in% c("url")
newdata_tu_1.1 <- timesup_part1.1[!timesup_1.1]
View(newdata_tu_1.1)
timesup_1.1_new <- newdata_tu_1.1 
View(timesup_1.1_new)

timesup_part1.2 <- rio::import("./Twitter Daten/timesup-p2.csv.Rds")
View(timesup_part1.2)
timesup_1.2 <- names(timesup_part1.2) %in% c("url")
newdata_tu_1.2 <- timesup_part1.2[!timesup_1.2]
View(newdata_tu_1.2)
timesup_1.2_new <- newdata_tu_1.2 
View(timesup_1.2_new)

timesup_part1.3 <- rio::import("./Twitter Daten/timesup-p3.csv.Rds")
View(timesup_part1.3)
timesup_1.3 <- names(timesup_part1.3) %in% c("url")
newdata_tu_1.3 <- timesup_part1.3[!timesup_1.3]
View(newdata_tu_1.3)
timesup_1.3_new <- newdata_tu_1.3
View(timesup_1.3_new)

##Merging the datasets into one (vertically) creating one dataframe with all the tweets with #timesup

hashtag_tu <- rbind(timesup_1_new, timesup_2_new, timesup_3_new)
View(hashtag_tu)

TU <- rbind(timesup_1.1_new,timesup_1.2_new, timesup_1.3_new)
View(TU)

##Cleaning the data, i.e. removing duplicates, removing duplicates from the two datasets - hashtag_metoo & MeToo

hashtag_tu_1 <- as_tibble(hashtag_tu) ##tibble for easier analysis
hashtag_tu_1 %>% distinct(text, .keep_all = TRUE) -> hashtag_tu_clean
View(hashtag_tu_clean)

TU_1 <- as_tibble(TU)
TU_1
TU_1 %>% distinct(text, .keep_all = TRUE) -> TU_clean
TU_clean
View(TU_clean)

##Merging the two datasets so that I have one MeToo dataframe with all the tweets - hashtag & text
TU_new <- rbind(hashtag_tu_clean, TU_clean)
View(TU_new)
TU_new <- as_tibble(TU_new)
TU_new

##removing duplicates from the big dataset
TU_new %>% distinct(text, .keep_all = TRUE) -> TU_complete
TU_complete ##final MeToo data
View(TU_complete)
TU_complete <- as_tibble(TU_complete)
View(TU_complete)

## Step 4: Merging all the data

Twitter_Data <- rbind(hashtag_metoo_clean, hashtag_wm_clean, hashtag_tu_clean, MeToo_clean, WM_clean, TU_clean)
View(Twitter_Data)

saveRDS(Twitter_Data, file = "Twitter_Data.rds")


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

##RT Netzwerk (alle Nennungen)
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
  group_by(group, metoo, timesup, womensmarch) %>% tally %>% filter(group == 63) %>% arrange(n)
