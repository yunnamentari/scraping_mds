# Load required packages
library(rvest)
library(tidyverse)
library(mongolite)

# Parse command line arguments for current page
args <- commandArgs(trailingOnly = TRUE)
current_page <- as.integer(args[1])

# Base URL for scraping
base_url <- "https://sinta.kemdikbud.go.id/authors?page="

# Function to scrape data from one page
scrape_page <- function(page_number) {
  url <- paste0(base_url, page_number)
  sinta <- read_html(url)
  
  # Extract data using CSS selectors and clean it
  NAMA <- sinta %>% html_nodes(".profile-name") %>% html_text(trim = TRUE)
  SINTA_ID <- sinta %>% html_nodes("div.profile-id") %>% html_text(trim = TRUE) %>% gsub("SINTA ID : ", "", .)
  DEPT <- sinta %>% html_nodes("div.profile-dept") %>% html_text(trim = TRUE) %>% gsub("DEPT : ", "", .)
  UNIV <- sinta %>% html_nodes("div.profile-affil") %>% html_text(trim = TRUE) %>% gsub("UNIV : ", "", .)
  SCORE <- sinta %>% html_nodes("div.pr-num") %>% html_text(trim = TRUE) %>% .[seq(2, length(.), 2)]
  
  data <- data.frame(
    NAMA = NAMA,
    SINTA_ID = SINTA_ID,
    DEPT = DEPT,
    UNIV = UNIV,
    SCORE = SCORE,
    stringsAsFactors = FALSE
  )
  
  return(data)
}

# Function to scrape and insert data into MongoDB
scrape_and_insert <- function() {
  # Initialize an empty data frame to hold all data
  all_data <- data.frame()
  
  # Scrape data from 3 pages
  for (page_number in 1:3) {
    page_data <- scrape_page(page_number)
    
    # Combine data from current page with all_data
    all_data <- bind_rows(all_data, page_data)
  }
  
  # Print the combined data
  print(all_data)
  
  # Connect to MongoDB and insert the data
  connection_string <- Sys.getenv("ATLAS_URL")
  db <- mongo(collection = Sys.getenv("ATLAS_COLLECTION"), db = Sys.getenv("ATLAS_DB"), url = connection_string)
  db$insert(all_data)
}

# Execute the scraping and insertion process
scrape_and_insert()
