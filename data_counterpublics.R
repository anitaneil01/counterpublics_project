## This one is great!
raw_data <- rio::import(file.choose())


require(quanteda)

corpus <- readtext::readtext('/Users/anitaneil/Documents/UniMa/HWS 1920/PS II Gegenöffentlichkeiten/Twitter_Counterpublics/Zeitungsartikel/The New York Times/txt/*')
require(stringr)

brokentext <- str_split(corpus$text[1], '[:space:]')[[1]]

idx <- min(which(str_detect(brokentext, '[bB]ody')))

body <- paste0(brokentext[(idx+1):length(brokentext)], collapse = ' ')      

idx_doc <- min(which(str_detect(brokentext, 'Dokument')))
idx_zit <- min(which(str_detect(brokentext, 'Zitation')))

paste(brokentext[(idx_doc+1):(idx_zit-1)], collapse = ' ')

extrtact_body <- function(text) {
    brokentext <- str_split(text, '[:space:]')[[1]]
    idx <- min(which(str_detect(brokentext, '[bB]ody')))
    body <- paste0(brokentext[(idx+1):length(brokentext)], collapse = ' ')
    return(body)
}

extrtact_title <- function(text) {
    brokentext <- str_split(text, '[:space:]')[[1]]
    idx_doc <- min(which(str_detect(brokentext, 'Dokument')))
    idx_zit <- min(which(str_detect(brokentext, 'Zitation')))
    title <- paste(brokentext[(idx_doc+1):(idx_zit-1)], collapse = ' ')
    return(title)
}