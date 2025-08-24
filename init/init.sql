-- Run following to bulk insert from dataset/seed/*.csv
-- \copy sample_users(name, age, email, mobile_phone) FROM '~/dataset/seeds/sample_users.csv' WITH CSV HEADER;

-- Uncomment if necessary
-- DROP TABLE IF EXISTS sample_users;

-- CREATE TABLE IF NOT EXISTS sample_users(
--   id    SERIAL             PRIMARY KEY,
--   name  VARCHAR(255)       NOT NULL,
--   age   INTEGER            NOT NULL CHECK (age >= 18),
--   email VARCHAR(254)       NOT NULL UNIQUE CHECK (email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'),
--   mobile_phone VARCHAR(13) NOT NULL UNIQUE CHECK (mobile_phone ~ '^[0-9]{3}-[0-9]{4}-[0-9]{4}$')
-- );
