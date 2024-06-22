# Mengatur variabel lingkungan untuk koneksi MongoDB
Sys.setenv(ATLAS_COLLECTION = "mds1")
Sys.setenv(ATLAS_DB = "scraping1")
Sys.setenv(ATLAS_URL = "mongodb+srv://yunnamentari:12345@cluster0.yumxaky.mongodb.net/")

# Memuat pustaka yang diperlukan
library(rvest)
library(tidyverse)
library(mongolite)

# Fungsi untuk melakukan scraping pada halaman tertentu
scrape_page <- function(page_number) {
  message(paste('Mengambil Data untuk Halaman', page_number))
  
  base_url <- "https://sinta.kemdikbud.go.id/authors?page="
  url <- paste0(base_url, page_number)
  
  sinta <- read_html(url)
  
  NAMA <- sinta %>% html_nodes(".profile-name") %>% html_text(trim = TRUE)
  SINTA_ID <- sinta %>% html_nodes("div.profile-id") %>% html_text(trim = TRUE) %>% gsub("SINTA ID : ", "", .)
  DEPT <- sinta %>% html_nodes("div.profile-dept") %>% html_text(trim = TRUE) %>% gsub("DEPT : ", "", .)
  INDEKS <- sinta %>% html_nodes("div.pr-txt-metric") %>% html_text(trim = TRUE)
  
  data <- data.frame(
    time_scraped = Sys.time(),
    NAMA = NAMA,
    SINTA_ID = SINTA_ID,
    DEPT = DEPT,
    stringsAsFactors = FALSE
  )
  
  return(data)
}

# Membaca halaman terakhir yang di-scrape dari file
read_last_scraped_page <- function() {
  if (file.exists("last_page.txt")) {
    last_page <- as.integer(readLines("last_page.txt"))
  } else {
    last_page <- 0
  }
  return(last_page)
}

# Menyimpan halaman terakhir yang di-scrape ke file
write_last_scraped_page <- function(page) {
  writeLines(as.character(page), "last_page.txt")
}

# Memproses argumen baris perintah untuk halaman saat ini
last_page <- read_last_scraped_page()
current_page <- last_page + 1

# Batas maksimal halaman yang akan di-scrape
max_page <- 5

if (current_page > max_page) {
  message('Proses scraping telah mencapai halaman maksimal.')
  quit()
}

# Menghubungkan ke MongoDB
connection_string <- Sys.getenv("ATLAS_URL")
db <- mongo(collection = Sys.getenv("ATLAS_COLLECTION"), db = Sys.getenv("ATLAS_DB"), url = connection_string)

# Melakukan scraping dan menyimpan data
data <- scrape_page(current_page)
db$insert(data)

# Menyimpan halaman terakhir yang di-scrape
write_last_scraped_page(current_page)

message('Proses Scraping Selesai')
