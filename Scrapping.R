library(rvest)
library(tidyverse)
library(mongolite)

message('Loading Packages')

message('Scraping Data')

# URL 
url <- "https://sinta.kemdikbud.go.id/authors"

# Membaca halaman HTML
sinta <- read_html(url)

# Selector CSS yang disesuaikan 
NAMA <- sinta %>% html_nodes(".profile-name") %>% html_text(trim = TRUE)
SINTA_ID <- sinta %>% html_nodes("div.profile-id") %>% html_text(trim = TRUE) %>% gsub("SINTA ID : ", "", .)
DEPT <- sinta %>% html_nodes("div.profile-dept") %>% html_text(trim = TRUE) %>% gsub("DEPT : ", "", .)
INDEKS <- sinta %>% html_nodes("div.pr-txt-metric") %>% html_text(trim = TRUE) %>% gsub("DEPT : ", "", .)

# Memeriksa hasil scraping dan mengambil 10 data pertama jika ada
data <- data.frame(
  time_scraped = Sys.time(),
  NAMA = head(NAMA, 10),
  SINTA_ID = head(SINTA_ID, 10),
  DEPT = head(DEPT, 10),
  stringsAsFactors = FALSE
)

# MONGODB
message('Input Data to MongoDB Atlas')

# Connection string dari MongoDB Atlas
conn_string <- Sys.getenv("ATLAS_URL")

# Membuat koneksi ke MongoDB Atlas
atlas_conn <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db = Sys.getenv("ATLAS_DB"),
  url = conn_string
)

# Memasukkan data ke MongoDB Atlas
atlas_conn$insert(data)

# Menutup koneksi setelah selesai
rm(atlas_conn)

message('Scraping and data insertion completed successfully')
