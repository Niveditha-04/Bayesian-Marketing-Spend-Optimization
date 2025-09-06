suppressPackageStartupMessages({
  library(readr); library(dplyr); library(lubridate); library(tidyverse)
  library(rstanarm)
  library(posterior); library(bayesplot)
  library(broom.mixed); library(ggplot2)
})

options(mc.cores = max(1, parallel::detectCores() - 1))

df <- readr::read_csv("data_clean/marketing_clean.csv") %>%
  mutate(
    month = factor(month(date)),
    channel = factor(channel),
    spend_s = as.numeric(scale(spend)),
    impr_s  = as.numeric(scale(impressions))
  )

set.seed(42)
fit <- stan_glmer.nb(
  conversions ~ 1 + spend_s + impr_s + promo_flag + month + (1 | channel),
  data = df,
  prior_intercept = student_t(3, 0, 2.5),
  prior = normal(0, 1, autoscale = TRUE),
  chains = 4,
  iter = 3000,
  warmup = 1500,
  control = list(adapt_delta = 0.99, max_treedepth = 12)
)

if (!dir.exists("outputs/model")) dir.create("outputs/model", recursive = TRUE)
saveRDS(fit, "outputs/model/fit_negbin_rstanarm.rds")

print(summary(fit), digits = 2)

if (!dir.exists("outputs/figs")) dir.create("outputs/figs", recursive = TRUE)
png("outputs/figs/ppc_dens.png", width = 1000, height = 500)
rstanarm::pp_check(fit, plotfun = "dens_overlay")
dev.off()

fx <- broom.mixed::tidy(fit, effects = "fixed", conf.int = TRUE, conf.level = 0.90)
readr::write_csv(fx, "outputs/model/fixed_effects_ci.csv")

p_spend <- fx %>%
  filter(term == "spend_s") %>%
  ggplot(aes(x = estimate, y = term)) +
  geom_point() +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.2) +
  labs(title = "Spend Effect (standardized) — 90% Credible Interval",
       x = "Estimate", y = NULL) +
  theme_minimal()

ggsave("outputs/figs/spend_effect_ci.png", p_spend, width = 6, height = 3.5, dpi = 150)

rand <- broom.mixed::tidy(fit, effects = "ran_vals") %>%
  filter(group == "channel", term == "(Intercept)") %>%
  select(level, estimate) %>%
  arrange(desc(estimate))
readr::write_csv(rand, "outputs/model/channel_ranking.csv")

message("Model trained. Artifacts saved to outputs/model and outputs/figs.")
