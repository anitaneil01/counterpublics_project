require(rvest)
require(tidyverse)
require(rio)
require(quanteda)
library(readr)
library(dplyr)

# Step 1: Importing NYT/MeToo

read_html('./Zeitungsartikel/MeToo_NYT_1.html') -> html_src_new
read_html('./Zeitungsartikel/MeToo_NYT_2.html') -> html_src1_new
read_html('./Zeitungsartikel/MeToo_NYT_3.html') -> html_src2_new
read_html('./Zeitungsartikel/MeToo_NYT_4.html') -> html_src3_new
read_html('./Zeitungsartikel/MeToo_NYT_5.html') -> html_src4_new

html_src_new %>% html_nodes('div.enArticle') -> articles_new
html_src1_new %>% html_nodes('div.enArticle') -> articles_1_new
html_src2_new %>% html_nodes('div.enArticle') -> articles_2_new
html_src3_new %>% html_nodes('div.enArticle') -> articles_3_new
html_src4_new %>% html_nodes('div.enArticle') -> articles_4_new

extract_article <- function(article) {
  content <- article %>% html_nodes('p.articleParagraph') %>% html_text %>% paste(collapse = ' ')
  title <- article %>% html_node('span.enHeadline') %>% html_text
  article %>% html_nodes('tr') -> all_tr
  all_tr %>% html_node('td') %>% html_text -> field_names
  all_tr[str_detect(field_names, '^PD')] %>% html_nodes('td') -> alltd
  date <- alltd[2] %>% html_text
  all_tr[str_detect(field_names, '^SN')] %>% html_nodes('td') -> all_td
  source <- all_td[2] %>% html_text
  tibble(source = source, title = title, date = date, content = content)
}

article_df_new <- map_dfr(articles_new, extract_article)
article1_df_new <- map_dfr(articles_1_new, extract_article)
article2_df_new <- map_dfr(articles_2_new, extract_article)
article3_df_new <- map_dfr(articles_3_new, extract_article)
article4_df_new <- map_dfr(articles_4_new, extract_article)

##Step 1.2: Merging all the NYT MeToo articles into one df
NYT_MeToo_df <- rbind(article_df_new, article1_df_new, article2_df_new, article3_df_new, article4_df_new)
View(NYT_MeToo_df)

## Importing NYT/Women's March
read_html('./Zeitungsartikel/Womensmarch_NYT_1.html') -> html_src4
read_html('./Zeitungsartikel/Womensmarch_NYT_2.html') -> html_src5
read_html('./Zeitungsartikel/Womensmarch_NYT_3.html') -> html_src6

html_src4 %>% html_nodes('div.enArticle') -> articles_4.1
html_src5 %>% html_nodes('div.enArticle') -> articles_5.1
html_src6 %>% html_nodes('div.enArticle') -> articles_6.1

article_4.1_df <- map_dfr(articles_4.1, extract_article)
article_5.1_df <- map_dfr(articles_5.1, extract_article)
article_6.1_df <- map_dfr(articles_6.1, extract_article)

NYT_WM_df <-rbind(article_4.1_df, article_5.1_df, article_6.1_df)
View(NYT_WM_df)


## Importing NYT/Time's Up

read_html('./Zeitungsartikel/TimesUp_NYT_1.html') -> html_src20

html_src20 %>% html_nodes('div.enArticle') -> articles_20

NYT_TU_df <- map_dfr(articles_20, extract_article)

View(NYT_TU_df)

##Step 1.3: Importing articles from USA Today/MeToo (no merge df here, cause there is only one file)
read_html('./Zeitungsartikel/MeToo_USA Today_1.html') -> html_src_8
html_src_8 %>% html_nodes('div.enArticle') -> articles_8.1

USAToday_MeToo_df <- map_dfr(articles_8.1, extract_article)
View(USAToday_MeToo_df)

## Importing articles from USA Today/WashingtonPost (no merge df here, cause there is only one file)

read_html('./Zeitungsartikel/Womensmarch_USAToday_1.html') -> html_src_9
html_src_9 %>% html_nodes('div.enArticle') -> articles_9

USAToday_WM_df <- map_dfr(articles_9, extract_article)
View(USAToday_WM_df)

## USAToday TimesUp

read_html('./Zeitungsartikel/TimesUp_USAToday_1.html') -> html_src21

html_src21 %>% html_nodes('div.enArticle') -> articles_21

USAToday_TU_df <- map_dfr(articles_21, extract_article)

View(USAToday_TU_df)

##Step 1.4: Importing articles from The Washington Post/MeToo

read_html('./Zeitungsartikel/MeToo_WP_1.html') -> html_src_1.1
read_html('./Zeitungsartikel/MeToo_WP_2.html') -> html_src_1.2
read_html('./Zeitungsartikel/MeToo_WP_3.html') -> html_src_1.3

html_src_1.1 %>% html_nodes('div.enArticle') -> articles_1.1
html_src_1.2 %>% html_nodes('div.enArticle') -> articles_1.2
html_src_1.3 %>% html_nodes('div.enArticle') -> articles_1.3

articles_1.1 <- map_dfr(articles_1.1, extract_article)
articles_1.2 <- map_dfr(articles_1.2, extract_article)
articles_1.3 <- map_dfr(articles_1.3, extract_article)

##Step 1.5: Merging the dfs into one
WP_MeToo_df <- rbind(articles_1.1, articles_1.2, articles_1.3)
View(WP_MeToo_df)

## Importing articles from The Washington Post/WM

read_html('./Zeitungsartikel/Womensmarch_WP_1.html') -> html_src_10
read_html('./Zeitungsartikel/Womensmarch_WP_2.html') -> html_src_11
read_html('./Zeitungsartikel/Womensmarch_WP_3.html') -> html_src_12

html_src_10 %>% html_nodes('div.enArticle') -> articles_10
html_src_11 %>% html_nodes('div.enArticle') -> articles_11
html_src_12 %>% html_nodes('div.enArticle') -> articles_12

articles_10 <- map_dfr(articles_10, extract_article)
articles_11 <- map_dfr(articles_11, extract_article)
articles_12 <- map_dfr(articles_12, extract_article)

##Step 1.5: Merging the dfs into one
WP_WM_df <- rbind(articles_10, articles_11, articles_12)
View(WP_WM_df)

saveRDS(articles_df, file = "articles.rds")

## WP/TimesUp

read_html('./Zeitungsartikel/TimesUp_WP_1.html') -> html_src22
html_src22 %>% html_nodes('div.enArticle') -> articles_22
WP_TU_df <- map_dfr(articles_22, extract_article)
View(WP_TU_df)

##one big regional df:
articles_df <- rbind(NYT_MeToo_df, NYT_TU_df, NYT_WM_df, WP_MeToo_df, WP_TU_df, WP_WM_df, USAToday_MeToo_df, USAToday_TU_df, USAToday_WM_df)
View(articles_df)

##Importing Regional articles

read_html('./Zeitungsartikel/MeToo_CDH_1.html') -> html_src_13
read_html('./Zeitungsartikel/MeToo_CDH_2.html') -> html_src_14
html_src_13 %>% html_nodes('div.enArticle') -> articles_13
html_src_14 %>% html_nodes('div.enArticle') -> articles_14
articles_13 <- map_dfr(articles_13, extract_article)
articles_14 <- map_dfr(articles_14, extract_article)
CDH_MeToo_df <- rbind(articles_13, articles_14)

read_html('./Zeitungsartikel/Womensmarch_CDH_1.html') -> html_src_15
html_src_15 %>% html_nodes('div.enArticle') -> articles_15
CDH_WM_df <- map_dfr(articles_15, extract_article)

read_html('./Zeitungsartikel/TimesUp_CDH_1.html') -> html_src_16
html_src_16 %>% html_nodes('div.enArticle') -> articles_16
CDH_TU_df <- map_dfr(articles_16, extract_article)

read_html('./Zeitungsartikel/MeToo_CG_1.html') -> html_src_17
html_src_17 %>% html_nodes('div.enArticle') -> articles_17
CG_MeToo_df <- map_dfr(articles_17, extract_article)

read_html('./Zeitungsartikel/Womensmarch_CG_1.html') -> html_src_18
html_src_18 %>% html_nodes('div.enArticle') -> articles_18
CG_WM_df <- map_dfr(articles_18, extract_article)

read_html('./Zeitungsartikel/TimesUp_CG_1.html') -> html_src_19
html_src_19 %>% html_nodes('div.enArticle') -> articles_19
CG_TU_df <- map_dfr(articles_18, extract_article)

##one big regional df:
regional_df <- rbind(CDH_MeToo_df, CDH_WM_df, CDH_TU_df, CG_MeToo_df, CG_WM_df, CG_TU_df)
View(regional_df)

saveRDS(regional_df, file = "Regional_articles.rds")

## Step 2.1: Corpus und Textplot
##Washington Post MeToo
WP_MeToo_corpus <- corpus(WP_MeToo_df$content)
kwic(WP_MeToo_corpus, "#MeToo")

WP_MeToo_dfm <- dfm(WP_MeToo_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
WP_MeToo_dfm
topfeatures(WP_MeToo_dfm, 100)
textplot_wordcloud(WP_MeToo_dfm, min_count = 100, random_order = FALSE)

##Washington Post Womensmarch
WP_WM_corpus <- corpus(WP_WM_df$content)
kwic(WP_WM_corpus, "#Womensmarch")

WP_WM_dfm <- dfm(WP_WM_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
WP_WM_dfm
topfeatures(WP_WM_dfm, 100)
textplot_wordcloud(WP_WM_dfm, min_count = 100, random_order = FALSE)

##TimesUp/WP
WP_TU_corpus <- corpus(WP_TU_df$content)
kwic(WP_TU_corpus, "#TimesUp")

WP_TU_dfm <- dfm(WP_TU_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
WP_TU_dfm
topfeatures(WP_TU_dfm, 100)
textplot_wordcloud(WP_TU_dfm, min_count = 100, random_order = FALSE)


## New York Times MeToo
NYT_MeToo_corpus <- corpus(NYT_MeToo_df$content)
kwic(NYT_MeToo_corpus, "#MeToo")

NYT_MeToo_dfm <- dfm(NYT_MeToo_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
NYT_MeToo_dfm
topfeatures(NYT_MeToo_dfm, 100)
textplot_wordcloud(NYT_MeToo_dfm, min_count = 100, random_order = FALSE)

## New York Times Womensmarch
NYT_WM_corpus <- corpus(NYT_WM_df$content)
kwic(NYT_WM_corpus, "#Womensmarch")

NYT_WM_dfm <- dfm(NYT_WM_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
NYT_WM_dfm
topfeatures(NYT_WM_dfm, 100)
textplot_wordcloud(NYT_WM_dfm, min_count = 100, random_order = FALSE)

## TimesUp/NYT

NYT_TU_corpus <- corpus(NYT_TU_df$content)
kwic(NYT_TU_corpus, "#TimesUp")

NYT_TU_dfm <- dfm(NYT_TU_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
NYT_TU_dfm
topfeatures(NYT_TU_dfm, 100)
textplot_wordcloud(NYT_TU_dfm, min_count = 100, random_order = FALSE)

## USA Today MeToo
USAToday_MeToo_corpus <- corpus(USAToday_MeToo_df$content)
kwic(USAToday_MeToo_corpus, "#MeToo")

USAToday_MeToo_dfm <- dfm(USAToday_MeToo_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
USAToday_MeToo_dfm
topfeatures(USAToday_MeToo_dfm, 100)
textplot_wordcloud(USAToday_MeToo_dfm, random_order = FALSE)

## USA Today Womensmarch
USAToday_WM_corpus <- corpus(USAToday_WM_df$content)
kwic(USAToday_WM_corpus, "#Womensmarch")

USAToday_WM_dfm <- dfm(USAToday_WM_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
USAToday_WM_dfm
topfeatures(USAToday_WM_dfm, 100)
textplot_wordcloud(USAToday_WM_dfm, random_order = FALSE)

## USA Today/TimesUp
USAToday_TU_corpus <- corpus(USAToday_TU_df$content)
kwic(USAToday_TU_corpus, "#TimesUp")

USAToday_TU_dfm <- dfm(USAToday_TU_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
USAToday_TU_dfm
topfeatures(USAToday_TU_dfm, 100)
textplot_wordcloud(USAToday_TU_dfm, min_count = 100, random_order = FALSE)

##one big dfm corpus

articles_corpus <- corpus(articles_df$content)
articles_dfm <- dfm(articles_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))
articles_dfm
topfeatures(articles_dfm, 100)
textplot_wordcloud(articles_dfm, min_count = 300, random_order = FALSE)

##Gold Standard (Validation for regional articles, sentiment analysis - dictionary from course last semester)
regional_df
regional_df %>% sample_n(50) %>% select(content) %>% saveRDS('./regional_validation.RDS')
readRDS('./regional_validation.RDS') %>% mutate(tid = seq_along(content)) %>% rio::export('./regional_validation.csv')

##Gold Standard (Validation - Feminism etc. - all articles)
  
articles_df %>% sample_n(50) %>% select(content) %>% saveRDS('./validation.RDS')
readRDS('./validation.RDS') %>% mutate(tid = seq_along(content)) %>% rio::export('./validation.csv')

##etc.
