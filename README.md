This project simulates six months of multi-channel marketing data and applies a Bayesian Negative Binomial mixed model to understand how spend, impressions, and promotions drive conversions across channels.

Steps I implemented:

1. Data Simulation → Created six months of daily multi-channel marketing data (search, social, display, video, email) with flags for promos and holidays. (Skills: R, tidyverse, random data generation)
2. Database Integration → Designed a schema and loaded the data into SQLite for structured storage and SQL-based exploration. (Skills: SQL, DBI, RSQLite)
3. Data Cleaning & Feature Engineering → Standardized features (scaled spend, impressions, month factors) to prepare inputs for modeling. (Skills: tidyverse, janitor, lubridate)
4. Bayesian Modeling → Fit a Negative Binomial GLMM using rstanarm with partial pooling by channel, capturing spend/impression effects while accounting for channel-level variation. (Skills: Bayesian stats, GLMM, rstanarm, posterior diagnostics)
5. Model Outputs → Exported credible intervals for fixed effects, ranked channels by posterior random intercepts, and generated predictive checks. (Skills: bayesplot, broom.mixed, ggplot2)
6. Insights Visualization → Created clean plots to compare channel performance and visualize effect intervals. (Skills: ggplot2, data visualization)

Tools used: R, tidyverse, SQLite, SQL, rstanarm, bayesplot, broom.mixed, ggplot2.
