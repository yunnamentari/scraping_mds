# Set environment variables for MongoDB connection
Sys.setenv(ATLAS_COLLECTION = "mds1")
Sys.setenv(ATLAS_DB = "scraping1")
Sys.setenv(ATLAS_URL = "mongodb+srv://yunnamentari:12345@cluster0.yumxaky.mongodb.net/")

# Load required packages
library(rvest)
library(tidyverse)
library(mongolite)

# Parse command line arguments for current page
args <- commandArgs(trailingOnly = TRUE)
current_page <- as.integer(args[1])

# Log messages
message('Loading Packages')
message('Scraping Data')

# Base URL for scraping
base_url <- "https://sinta.kemdikbud.go.id/authors?page=1"
url <- paste0(base_url, current_page)

# Read the HTML content from the URL
sinta <- read_html(url)

# Extract data using CSS selectors and clean it
NAMA <- sinta %>% html_nodes(".profile-name") %>% html_text(trim = TRUE)
SINTA_ID <- sinta %>% html_nodes("div.profile-id") %>% html_text(trim = TRUE) %>% gsub("SINTA ID : ", "", .)
DEPT <- sinta %>% html_nodes("div.profile-dept") %>% html_text(trim = TRUE) %>% gsub("DEPT : ", "", .)
UNIV <- sinta %>% html_nodes("div.profile-affil") %>% html_text(trim = TRUE) %>% gsub("UNIV : ", "", .)


Create a data frame with the scraped data
data <- data.frame(
  time_scraped = Sys.time(),
  NAMA = NAMA,
  SINTA_ID = SINTA_ID,
  DEPT = DEPT,
  UNIV = UNIV,
  stringsAsFactors = FALSE
)

# Connect to MongoDB and insert the data
connection_string <- Sys.getenv("ATLAS_URL")
db <- mongo(collection = Sys.getenv("ATLAS_COLLECTION"), db = Sys.getenv("ATLAS_DB"), url = connection_string)
db$insert(data)
