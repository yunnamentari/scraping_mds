library(rvest)
library(tidyverse)
library(mongolite)

# Fungsi untuk scraping data dari satu halaman
scrape_page <- function(page_number) {
  base_url <- paste0("https://sinta.kemdikbud.go.id/authors?page=", page_number)
  sinta <- read_html(base_url)
  
  NAMA <- sinta %>% html_nodes(".profile-name") %>% html_text(trim = TRUE)
  SINTA_ID <- sinta %>% html_nodes("div.profile-id") %>% html_text(trim = TRUE) %>% gsub("SINTA ID : ", "", .)
  DEPT <- sinta %>% html_nodes("div.profile-dept") %>% html_text(trim = TRUE) %>% gsub("DEPT : ", "", .)
  UNIV <- sinta %>% html_nodes("div.profile-affil") %>% html_text(trim = TRUE) %>% gsub("UNIV : ", "", .) 
  
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

# Inisialisasi halaman awal
page_number <- 1

# Loop untuk scraping dari beberapa halaman
while(TRUE) {
  # Buat URL untuk halaman saat ini
  url <- paste0("https://sinta.kemdikbud.go.id/authors?page=", page_number)
  
  # Scrape data dari halaman saat ini
  page_data <- scrape_page(page_number)
  
  # Jika data yang didapat kosong, hentikan loop
  if (nrow(page_data) == 0) {
    break
  }
  
  # Memasukkan data ke MongoDB Atlas
  atlas_conn$insert(page_data)
  
  # Update nomor halaman untuk halaman berikutnya
  page_number <- page_number + 1
  
  # Menunggu 1 menit sebelum menjalankan lagi (jika ingin interval 1 menit sekali)
  Sys.sleep(60)
}

# Menutup koneksi setelah selesai
rm(atlas_conn)

message('Scraping and data insertion completed successfully')
