set.seed(42)
suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
})

channels <- c("search","social","display","video","email")
dates <- seq(as.Date("2024-01-01"), as.Date("2024-06-30"), by = "day")

df <- tidyr::expand_grid(date = dates, channel = channels) |>
  mutate(
    promo_flag   = rbinom(n(), 1, 0.15),
    holiday_flag = as.integer(wday(date) %in% c(1, 7)),
    base_spend = case_when(
      channel == "search"  ~ 1200,
      channel == "social"  ~ 800,
      channel == "display" ~ 600,
      channel == "video"   ~ 700,
      TRUE                 ~ 300
    ),
    spend = pmax(0, round(rlnorm(n(), log(base_spend), 0.4) * (1 + 0.3 * promo_flag), 2)),
    impressions = round(spend * runif(n(), 30, 60)),
    ctr = rbeta(n(), 2.5, 180),
    clicks = pmin(impressions, rbinom(n(), size = pmax(1, impressions), prob = pmin(0.25, ctr))),
    ch_eff = case_when(
      channel == "search"  ~ 0.25,
      channel == "social"  ~ 0.15,
      channel == "video"   ~ 0.12,
      channel == "display" ~ 0.08,
      TRUE                 ~ 0.05
    ),
    linpred = -2.0 + 0.0006 * spend + 0.00003 * impressions + 0.25 * promo_flag + ch_eff,
    mu = exp(linpred),
    conversions = rpois(n(), lambda = mu),
    revenue = round(conversions * runif(n(), 800, 2000), 2)
  ) |>
  select(date, channel, spend, impressions, clicks, conversions, revenue, promo_flag, holiday_flag)

if (!dir.exists("data_raw")) dir.create("data_raw", recursive = TRUE)
readr::write_csv(df, "data_raw/marketing_sim.csv")

message("Simulated dataset written to data_raw/marketing_sim.csv with ", nrow(df), " rows.")
