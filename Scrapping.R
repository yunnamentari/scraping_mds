library(rvest)
library(tidyverse)
library(mongolite)

# Inisialisasi URL dasar
base_url <- "https://sinta.kemdikbud.go.id/authors?page="

# Fungsi untuk scraping data dari satu halaman
scrape_page <- function(url) {
  sinta <- read_html(url)
  
  NAMA <- sinta %>% html_nodes(".profile-name") %>% html_text(trim = TRUE)
  SINTA_ID <- sinta %>% html_nodes("div.profile-id") %>% html_text(trim = TRUE) %>% gsub("SINTA ID : ", "", .)
  DEPT <- sinta %>% html_nodes("div.profile-dept") %>% html_text(trim = TRUE) %>% gsub("DEPT : ", "", .)
  UNIV <- sinta %>% html_nodes("div.profile-affil") %>% html_text(trim = TRUE) %>% gsub("UNIV : ", "", .)                               # Ubah ke numerik jika diperlukan
  
  data <- data.frame(
    time_scraped = Sys.time(),
    NAMA = NAMA,
    SINTA_ID = SINTA_ID,
    DEPT = DEPT,
    UNIV = UNIV,
    stringsAsFactors = FALSE
  )
  
  return(data)
}

# Inisialisasi data frame untuk menampung semua data
all_data <- data.frame()

# Inisialisasi halaman awal dan batas maksimum halaman
page_number <- 1
max_pages <- 5

# Loop untuk scraping dari beberapa halaman
while(page_number <= max_pages) {
  # Buat URL untuk halaman saat ini
  url <- paste0(base_url, page_number)
  
  # Scrape data dari halaman saat ini
  page_data <- scrape_page(url)
  
  # Jika data yang didapat kosong, hentikan loop
  if (nrow(page_data) == 0) {
    break
  }
  
  # Gabungkan data dari halaman ini ke data sebelumnya
  all_data <- bind_rows(all_data, page_data)
  
  # Update nomor halaman
  page_number <- page_number + 1
}

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
atlas_conn$insert(all_data)

# Menutup koneksi setelah selesai
rm(atlas_conn)

message('Scraping and data insertion completed successfully')
