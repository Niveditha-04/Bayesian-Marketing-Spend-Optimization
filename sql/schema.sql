-- Drop table if it exists
DROP TABLE IF EXISTS fact_marketing;

-- Create table
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

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_marketing_date ON fact_marketing(date);
CREATE INDEX IF NOT EXISTS idx_marketing_channel ON fact_marketing(channel);

