suppressPackageStartupMessages({
  library(readr); library(dplyr); library(ggplot2)
})

rand <- read_csv("outputs/model/channel_ranking.csv")

p <- rand %>%
  mutate(level = factor(level, levels = level[order(estimate)])) %>%
  ggplot(aes(level, estimate)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Channel baseline performance (posterior estimates)",
    x = NULL,
    y = "Relative baseline effect"
  ) +
  theme_minimal()

ggsave("outputs/figs/channel_ranking.png", p, width = 6, height = 4, dpi = 150)

print(rand)

file.exists(
  c("data_clean/marketing_clean.csv",
    "outputs/figs/ppc_dens.png",
    "outputs/model/channel_ranking.csv")
)

readr::read_csv("outputs/model/channel_ranking.csv")
