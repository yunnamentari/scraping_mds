library(rvest)
library(tidyverse)
library(mongolite)

args <- commandArgs(trailingOnly = TRUE)
current_page <- as.integer(args[1])

message('Loading Packages')

message('Scraping Data')

base_url <- "https://sinta.kemdikbud.go.id/authors?page="

url <- paste0(base_url, current_page)

sinta <- read_html(url)

NAMA <- sinta %>% html_nodes(".profile-name") %>% html_text(trim = TRUE)
SINTA_ID <- sinta %>% html_nodes("div.profile-id") %>% html_text(trim = TRUE) %>% gsub("SINTA ID : ", "", .)
DEPT <- sinta %>% html_nodes("div.profile-dept") %>% html_text(trim = TRUE) %>% gsub("DEPT : ", "", .)
INDEKS <- sinta %>% html_nodes("div.pr-txt-metric") %>% html_text(trim = TRUE) %>% gsub("DEPT : ", "", .)

data <- data.frame(
  time_scraped = Sys.time(),
  NAMA = NAMA,
  SINTA_ID = SINTA_ID,
  DEPT = DEPT,
  stringsAsFactors = FALSE
)

connection_string <- Sys.getenv("ATLAS_URL")
db <- mongo(collection = Sys.getenv("ATLAS_COLLECTION"), db = Sys.getenv("ATLAS_DB"), url = connection_string)

db$insert(data)
