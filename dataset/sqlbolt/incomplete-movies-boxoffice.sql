-- Ref: https://sqlbolt.com/

-- Run following to apply:
-- * From psql interactive shell
--    \i /home/postgres/dataset/sqlbolt/incomplete-movies-boxoffice.sql
-- * From bash shell
--    psql -U postgres -f ~/dataset/sqlbolt/incomplete-movies-boxoffice.sql

DROP TABLE IF EXISTS movies;

CREATE TABLE IF NOT EXISTS movies (
  id              INTEGER         PRIMARY KEY,
  title           VARCHAR(255)    NOT NULL,
  director        VARCHAR(255)    NOT NULL,
  year            INTEGER         NOT NULL,
  length_minutes  INTEGER         NOT NULL
);

INSERT INTO movies (id, title, director, year, length_minutes)
VALUES
(1,  'Toy Story',           'John Lasseter',  1995, 81),
(2,  'A Bug''s Life',       'John Lasseter',  1998, 95),
(3,  'Toy Story 2',         'John Lasseter',  1999, 93);

CREATE TABLE boxoffice (
  movie_id            INTEGER      PRIMARY KEY,
  rating              NUMERIC(3,1) NOT NULL,
  domestic_sales      INTEGER      NOT NULL,
  international_sales INTEGER      NOT NULL,
  CONSTRAINT fk_movie
    FOREIGN KEY (movie_id)
    REFERENCES movies(id)
);

INSERT INTO boxoffice (movie_id, rating, domestic_sales, international_sales)
VALUES
(3,  7.9, 245852179, 239163000),
(1,  8.3, 191796233, 170162503),
(2,  7.2, 162798565, 200600000);