-- Ref: https://sqlbolt.com/

-- Run following to apply:
-- * From psql interactive shell
--    \i /home/postgres/dataset/sqlbolt/wrong-movies.sql
-- * From bash shell
--    psql -U postgres -f ~/dataset/sqlbolt/wrong-movies.sql

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
(2,  'A Bug''s Life',       'El Directore',   1998, 95),
(3,  'Toy Story 2',         'John Lasseter',  1899, 93),
(4,  'Monsters, Inc.',      'Pete Docter',    2001, 92),
(5,  'Finding Nemo',        'Andrew Stanton', 2003, 107),
(6,  'The Incredibles',     'Brad Bird',      2004, 116),
(7,  'Cars',                'John Lasseter',  2006, 117),
(8,  'Ratatouille',         'Brad Bird',      2007, 115),
(9,  'WALL-E',              'Andrew Stanton', 2008, 104),
(10, 'Up',                  'Pete Docter',    2009, 101),
(11, 'Toy Story 8',         'El Directore',   2010, 103),
(12, 'Cars 2',              'John Lasseter',  2011, 120),
(13, 'Brave',               'Brenda Chapman', 2012, 102),
(14, 'Monsters University', 'Dan Scanlon',    2013, 110);
