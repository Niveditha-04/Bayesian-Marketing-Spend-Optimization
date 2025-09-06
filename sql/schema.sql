# from your repo root
mkdir -p sql
cat > sql/schema.sql <<'SQL'
DROP TABLE IF EXISTS fact_marketing;

CREATE TABLE fact_marketing (
  date TEXT NOT NULL,
  channel TEXT NOT NULL,
  spend REAL,
  impressions INTEGER,
  clicks INTEGER,
  conversions INTEGER,
  revenue REAL,
  promo_flag INTEGER DEFAULT 0,
  holiday_flag INTEGER DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_marketing_date ON fact_marketing(date);
CREATE INDEX IF NOT EXISTS idx_marketing_channel ON fact_marketing(channel);
SQL

git add sql/schema.sql
git commit -m "Add SQL schema (fact_marketing)"
git push
