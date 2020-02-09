require(rvest)
require(tidyverse)
require(rio)
require(quanteda)
library(readr)
library(dplyr)
library(stringr)
library(igraph)


## kann raus bei dir
cp_data <- readRDS('./Twitter_Data.rds')
cp_data

###H2: The more similar social movements are in terms of their topic, the more likely their hashtags are used in combination on social network media.

#defining our nodes as twitter userrs
cp_nodes <- cp_data$user

#Combination: #metoo, #timesup #womensmarch --> H2
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch')) -> cp_hash
cp_hash %>% group_by(metoo, timesup, womensmarch) %>% tally #df sorted in groups 




##Testing other possible combinations with other movement related Hashtags

#Combination 1: #metoo, #timesup #womensmarch, whywewearblack 
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), whywewearblack = str_detect(lower_text, '#whywewearblack')) -> cp_hash1
cp_hash1 %>% group_by(metoo, timesup, womensmarch, whywewearblack) %>% tally 


#Combination 2: #metoo, #timesup #womensmarch, #blacklivesmatter 
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), blm = str_detect(lower_text, '#blacklivesmatter')) -> cp_hash2
cp_hash2 %>% group_by(metoo, timesup, womensmarch, blm) %>% tally 


#Combination 3: #metoo, #timesup #womensmarch,#imstillwithher 
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), imstillwithher = str_detect(lower_text, '#imstillwithher')) -> cp_hash3
cp_hash3 %>% group_by(metoo, timesup, womensmarch, imstillwithher) %>% tally 


#Combination 4: #metoo, #timesup #womensmarch,#bluewave 
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), bluewave = str_detect(lower_text, '#bluewave')) -> cp_hash4
cp_hash4 %>% group_by(metoo, timesup, womensmarch, bluewave) %>% tally 


#Combination 5: #metoo, #timesup #womensmarch, #marchforourlives 
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), marchforourlives = str_detect(lower_text, '#marchforourlives')) -> cp_hash5

cp_hash5 %>% group_by(metoo, timesup, womensmarch, marchforourlives) %>% tally 




##Testing other possible combinations with feminist hashtags

#Combination 6: #metoo, #timesup #womensmarch, #resist
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), resist = str_detect(lower_text, '#resist')) -> cp_hash6
cp_hash6 %>% group_by(metoo, timesup, womensmarch, resist) %>% tally 


#Combination 7: #metoo, #timesup #womensmarch, #theresistance
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), theresistance = str_detect(lower_text, '#theresistance')) -> cp_hash7
cp_hash7 %>% group_by(metoo, timesup, womensmarch, theresistance) %>% tally 


##Combination 8: #metoo, #timesup #womensmarch, #oprah
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), oprah = str_detect(lower_text, '#oprah')) -> cp_hash8
cp_hash8 %>% group_by(metoo, timesup, womensmarch, oprah) %>% tally 

#Combination 9: #metoo, #timesup #womensmarch, #oktosay
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), oktosay = str_detect(lower_text, '#oktosay')) -> cp_hash9
cp_hash9 %>% group_by(metoo, timesup, womensmarch, oktosay) %>% tally 

##Combination 10: #metoo, #timesup #womensmarch, #iwd
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), iwd = str_detect(lower_text, '#iwd')) -> cp_hash10
cp_hash10 %>% group_by(metoo, timesup, womensmarch, iwd) %>% tally 


#Combination 11: #metoo, #timesup #womensmarch, #feminism 
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), feminism = str_detect(lower_text, '#feminism')) -> cp_hash11
cp_hash11 %>% group_by(metoo, timesup, womensmarch, feminism) %>% tally 


#Combination 12: #metoo, #timesup #womensmarch,#sexualharassment  
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), sexualharassment = str_detect(lower_text, '#sexualharassment ')) -> cp_hash12
cp_hash12 %>% group_by(metoo, timesup, womensmarch, sexualharassment) %>% tally 


#Combination 13: #metoo, #timesup #womensmarch, #womensrights  
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), womensrights = str_detect(lower_text, '#womensrights ')) -> cp_hash13
cp_hash13 %>% group_by(metoo, timesup, womensmarch, womensrights) %>% tally 



#Combination 14: #metoo, #timesup #womensmarch, #equality  
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), equality = str_detect(lower_text, '#equality ')) -> cp_hash14
cp_hash14 %>% group_by(metoo, timesup, womensmarch, equality) %>% tally 


#Combination 15: #metoo, #timesup #womensmarch, #neveragain  
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), neveragain = str_detect(lower_text, '#neveragain ')) -> cp_hash15
cp_hash15 %>% group_by(metoo, timesup, womensmarch, neveragain) %>% tally 


#Combination 16: #metoo, #timesup #womensmarch, #werise  
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), werise = str_detect(lower_text, '#werise ')) -> cp_hash16
cp_hash16 %>% group_by(metoo, timesup, womensmarch, werise) %>% tally 


#Combination 17: #metoo, #timesup #womensmarch, #ewomensday  
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), womensday = str_detect(lower_text, '#womensday ')) -> cp_hash17
cp_hash17 %>% group_by(metoo, timesup, womensmarch, womensday) %>% tally 


#Combination 18: #metoo, #timesup #womensmarch, #nastywomanvote  
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), nastywomanvote = str_detect(lower_text, '#nastywomanvote ')) -> cp_hash18
cp_hash18 %>% group_by(metoo, timesup, womensmarch, nastywomanvote) %>% tally 




##Testing other possible combinations with political hashtags

#Combination 19: #metoo, #timesup #womensmarch, #maga, #imstillwithher 

cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), maga = str_detect(lower_text, '#maga '), imstillwithher = str_detect(lower_text, '#imstillwithher ')) -> cp_hash19
cp_hash19 %>% group_by(metoo, timesup, womensmarch, maga, imstillwithher) %>% tally




##Testing other possible combinations with social concern hashtags

#Combination 20: #metoo, #timesup #womensmarch, #lgbtq

cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), lgbtq = str_detect(lower_text, '#lgbtq ')) -> cp_hash20
cp_hash20 %>% group_by(metoo, timesup, womensmarch, lgbtq) %>% tally 


#Combination 21: #metoo, #timesup #womensmarch, #mentalhealth
cp_data %>% mutate(lower_text = tolower(text), metoo = str_detect(lower_text, '#metoo'), 
                   timesup = str_detect(lower_text, '#timesup'), 
                   womensmarch = str_detect(lower_text, '#womensmarch'), mentalhealth = str_detect(lower_text, '#mentalhealth ')) -> cp_hash21
cp_hash21 %>% group_by(metoo, timesup, womensmarch, mentalhealth) %>% tally 
