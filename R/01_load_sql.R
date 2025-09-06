suppressPackageStartupMessages({
  library(DBI); library(RSQLite); library(readr)
})

if (!dir.exists("data_sqlite")) dir.create("data_sqlite", recursive = TRUE)
con <- dbConnect(SQLite(), "data_sqlite/marketing.db")

schema <- readr::read_file("sql/schema.sql")
dbExecute(con, schema)

df <- readr::read_csv("data_raw/marketing_sim.csv")
dbWriteTable(con, "fact_marketing", df, append = TRUE)

chk <- dbGetQuery(con, "
  SELECT channel, COUNT(*) AS rows, ROUND(SUM(spend),2) AS total_spend
  FROM fact_marketing
  GROUP BY channel
  ORDER BY total_spend DESC
")
print(chk)

chk2 <- dbGetQuery(con, "
  SELECT date, SUM(conversions) AS conv, SUM(spend) AS spend
  FROM fact_marketing
  GROUP BY date
  ORDER BY date
  LIMIT 5
")
print(chk2)

dbDisconnect(con)
