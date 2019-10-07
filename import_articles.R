require(rvest)
require(tidyverse)
require(rio)
require(quanteda)
library(readr)
library(dplyr)

# Step 1: Importing NYT

read_html('./Zeitungsartikel/MeToo_NYT_1.html') -> html_src
read_html('./Zeitungsartikel/MeToo_NYT_2.html') -> html_src1
read_html('./Zeitungsartikel/MeToo_NYT_3.html') -> html_src2
read_html('./Zeitungsartikel/MeToo_NYT_4.html') -> html_src3
read_html('./Zeitungsartikel/MeToo_NYT_5.html') -> html_src4

html_src %>% html_nodes('div.enArticle') -> articles


extract_article <- function(article) {
  content <- article %>% html_nodes('p.articleParagraph') %>% html_text %>% paste(collapse = ' ')
  title <- article %>% html_node('span.enHeadline') %>% html_text
  article %>% html_nodes('tr') -> all_tr
  all_tr %>% html_node('td') %>% html_text -> field_names
  all_tr[str_detect(field_names, '^PD')] %>% html_nodes('td') -> alltd
  date <- alltd[2] %>% html_text
  tibble(title = title, date = date, content = content)
}

article_df <- map_dfr(articles, extract_article)
article1_df <- map_dfr(articles1, extract_article)
article2_df <- map_dfr(articles2, extract_article)
article3_df <- map_dfr(articles3, extract_article)
article4_df <- map_dfr(articles4, extract_article)

##Step 1.2: Merging all the NYT MeToo articles into one df
NYT_MeToo_df <- rbind(article_df, article1_df, article2_df, article3_df, article4_df)
View(NYT_MeToo_df)

##Step 1.3: Importing articles from USA Today/MeToo (no merge df here, cause there is only one file)
read_html('./Zeitungsartikel/MeToo_USA Today_1.html') -> html_src_1

html_src_1 %>% html_nodes('div.enArticle') -> articles_1

extract_article <- function(article) {
  content <- article %>% html_nodes('p.articleParagraph') %>% html_text %>% paste(collapse = ' ')
  title <- article %>% html_node('span.enHeadline') %>% html_text
  article %>% html_nodes('tr') -> all_tr
  all_tr %>% html_node('td') %>% html_text -> field_names
  all_tr[str_detect(field_names, '^PD')] %>% html_nodes('td') -> alltd
  date <- alltd[2] %>% html_text
  tibble(title = title, date = date, content = content)
}

USAToday_MeToo_df <- map_dfr(articles_1, extract_article)
View(USAToday_MeToo_df)

##Step 1.4: Importing articles from The Washington POst/MeToo

read_html('./Zeitungsartikel/MeToo_WP_1.html') -> html_src_1.1
read_html('./Zeitungsartikel/MeToo_WP_2.html') -> html_src_1.2
read_html('./Zeitungsartikel/MeToo_WP_3.html') -> html_src_1.3

html_src_1.1 %>% html_nodes('div.enArticle') -> articles_1.1
html_src_1.2 %>% html_nodes('div.enArticle') -> articles_1.2
html_src_1.3 %>% html_nodes('div.enArticle') -> articles_1.3

extract_article <- function(article) {
  content <- article %>% html_nodes('p.articleParagraph') %>% html_text %>% paste(collapse = ' ')
  title <- article %>% html_node('span.enHeadline') %>% html_text
  article %>% html_nodes('tr') -> all_tr
  all_tr %>% html_node('td') %>% html_text -> field_names
  all_tr[str_detect(field_names, '^PD')] %>% html_nodes('td') -> alltd
  date <- alltd[2] %>% html_text
  tibble(title = title, date = date, content = content)
}

articles_1.1 <- map_dfr(articles_1.1, extract_article)
articles_1.2 <- map_dfr(articles_1.2, extract_article)
articles_1.3 <- map_dfr(articles_1.3, extract_article)

##Step 1.5: Merging the dfs into one
WP_MeToo_df <- rbind(articles_1.1, articles_1.2, articles_1.3)
View(WP_MeToo_df)

##Step 2: Corpus erstellen & Topfeatures auswerten lassen
##Step 2.1: Washington Post MeToo
WP_MeToo_corpus <- corpus(WP_MeToo_df$content)
kwic(WP_MeToo_corpus, "#MeToo")

WP_MeToo_dfm <- dfm(WP_MeToo_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
WP_MeToo_dfm
topfeatures(WP_MeToo_dfm, 100)
textplot_wordcloud(WP_MeToo_dfm, min_count = 300, random_order = FALSE)

##Step 2.2: New York Times MeToo
NYT_MeToo_corpus <- corpus(NYT_MeToo_df$content)
kwic(NYT_MeToo_corpus, "#MeToo")

NYT_MeToo_dfm <- dfm(NYT_MeToo_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
NYT_MeToo_dfm
topfeatures(NYT_MeToo_dfm, 100)
textplot_wordcloud(NYT_MeToo_dfm, min_count = 300, random_order = FALSE)

##Step 2.3: USA Today MeToo
USAToday_MeToo_corpus <- corpus(USAToday_MeToo_df$content)
kwic(USAToday_MeToo_corpus, "#MeToo")

USAToday_MeToo_dfm <- dfm(USAToday_MeToo_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
USAToday_MeToo_dfm
topfeatures(USAToday_MeToo_dfm, 100)
textplot_wordcloud(USAToday_MeToo_dfm, min_count = 300, random_order = FALSE)

###For Dictionary - Lena
##Step4, extracting 100 top words of WP
WP_Womensmarch_corpus <- corpus(WP_Womensmarch_df$content)

WP_Womensmarch_dfm <- dfm(WP_Womensmarch_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
WP_Womensmarch_dfm
topfeatures(WP_Womensmarch_dfm, 100)
textplot_wordcloud(WP_Womensmarch_dfm, min_count = 300, random_order = FALSE)

##Extracting top 100 words NYT
NYT_Womensmarch_corpus <- corpus(NYT_Womensmarch_df$content)
NYT_Womensmarch_dfm <- dfm(NYT_Womensmarch_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
NYT_Womensmarch_dfm
topfeatures(NYT_Womensmarch_dfm, 100)
textplot_wordcloud(WP_Womensmarch_dfm, min_count = 300, random_order = FALSE)

##Extracting top 100 words USAToday
USAToday_Womensmarch_corpus <- corpus(USAToday_Womensmarch_df$content)
USAToday_Womensmarch_dfm <- dfm(USAToday_Womensmarch_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
USAToday_Womensmarch_dfm
topfeatures(USAToday_Womensmarch_dfm, 100)
textplot_wordcloud(USAToday_Womensmarch_dfm, min_count = 300, random_order = FALSE)

