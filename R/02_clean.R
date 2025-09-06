suppressPackageStartupMessages({
  library(DBI); library(RSQLite); library(dplyr); library(readr); library(lubridate); library(janitor)
})

con <- dbConnect(RSQLite::SQLite(), "data_sqlite/marketing.db")

df <- dbReadTable(con, "fact_marketing") |>
  as_tibble() |>
  clean_names() |>
  mutate(
    date = as.Date(date),
    channel = as.character(channel)
  ) |>
  arrange(date, channel)

dbDisconnect(con)

if (!dir.exists("data_clean")) dir.create("data_clean", recursive = TRUE)
readr::write_csv(df, "data_clean/marketing_clean.csv")
message("Clean data written to data_clean/marketing_clean.csv (", nrow(df), " rows).")
