require(rvest)
require(tidyverse)
require(rio)
require(quanteda)
library(readr)
library(dplyr)
library(stringr)
library(igraph)


## Daten laden 
cp_data <- readRDS('./Twitter_Data.rds')
cp_data

#H5Je konzentrierter die Hashtag-Verwendung einer sozialen Bewegung ist, desto öfter werden ihre Inhalte geteilt.

#ohne Zeitpunkt
cp_data %>% mutate(hashtag_count = str_count(text, "#[[:alpha:]]+")) %>% summarise(cor = cor(retweets, hashtag_count))

#mit Zeitpunkt
cp_data %>% mutate(hashtag_count = str_count(text, "#[[:alpha:]]+"),
                   timestamp = lubridate::ymd_hms(timestamp), time_diff =
                     as.double(lubridate::ymd_hms("2019-10-01 00:00:00") - timestamp, units ="days"))  %>% select(retweets, time_diff, hashtag_count, user) %>% MASS::glm.nb(retweets~offset(log(time_diff))+hashtag_count, data = .) -> glm_nb_mod
summary(glm_nb_mod)

# 0-RTs rausnehmen, dann twiterrate erstellen mithilfe von plot() 



#ggf. user-identity hong fragen 







#H4 Je konzentrierter die Hashtag-Verwendung einer sozialen Bewegung ist, desto öfter werden ihre Inhalte geteilt.

cp_nodes <- cp_data$user


##whywewearblack extrahieren Hash1
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), whywewearblack = str_detect(lower_text, '#whywewearblack')) -> cp_hash1

cp_hash1 %>% group_by(metoo, timesup, womensmarch, whywewearblack) %>% tally #df in Gruppen sortiert


##blacklivesmatter extrahieren Hash2
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), blm = str_detect(lower_text, '#blacklivesmatter')) -> cp_hash2

cp_hash2 %>% group_by(metoo, timesup, womensmarch, blm) %>% tally 


##imstillwithher extrahieren Hash3
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), imstillwithher = str_detect(lower_text, '#imstillwithher')) -> cp_hash3

cp_hash3 %>% group_by(metoo, timesup, womensmarch, imstillwithher) %>% tally 

##bluewave extrahieren Hash4
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), bluewave = str_detect(lower_text, '#bluewave')) -> cp_hash4

cp_hash4 %>% group_by(metoo, timesup, womensmarch, bluewave) %>% tally 

##marchforourlives extrahieren Hash5
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), marchforourlives = str_detect(lower_text, '#marchforourlives')) -> cp_hash5

cp_hash5 %>% group_by(metoo, timesup, womensmarch, marchforourlives) %>% tally 


##aufschrei extrahieren Hash6
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), aufschrei = str_detect(lower_text, '#aufschrei')) -> cp_hash6

cp_hash6 %>% group_by(metoo, timesup, womensmarch, aufschrei) %>% tally 


##outcry extrahieren Hash7
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), outcry = str_detect(lower_text, '#outcry')) -> cp_hash7

cp_hash7 %>% group_by(metoo, timesup, womensmarch, outcry) %>% tally 

