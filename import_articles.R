require(rvest)
require(tidyverse)

read_html('./Zeitungsartikel/MeToo_NYT_1.html') -> html_src

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
