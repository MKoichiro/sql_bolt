-- Ref: https://sqlbolt.com/

-- Run following to apply:
-- * From psql interactive shell
--    \i /home/postgres/datasetsqlbolt/buildings-employees.sql
-- * From bash shell
--    psql -U postgres -f ~/dataset/sqlbolt/buildings-employees.sql

DROP TABLE IF EXISTS buildings;

CREATE TABLE buildings (
  building_name VARCHAR(10) PRIMARY KEY,
  capacity      INTEGER     NOT NULL
);

INSERT INTO buildings (building_name, capacity)
VALUES
('1e', 24),
('1w', 32),
('2e', 16),
('2w', 20);

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
  role           VARCHAR(50)  NOT NULL,
  name           VARCHAR(100) NOT NULL,
  building       VARCHAR(10)  NOT NULL,
  years_employed INTEGER      NOT NULL,
  CONSTRAINT fk_building
    FOREIGN KEY (building)
    REFERENCES  buildings(building_name)
);

INSERT INTO employees (role, name, building, years_employed)
VALUES
('Engineer', 'Becky A.',   '1e', 4),
('Engineer', 'Dan B.',     '1e', 2),
('Engineer', 'Sharon F.',  '1e', 6),
('Engineer', 'Dan M.',     '1e', 4),
('Engineer', 'Malcom S.',  '1e', 1),
('Artist',   'Tylar S.',   '2w', 2),
('Artist',   'Sherman D.', '2w', 8),
('Artist',   'Jakob J.',   '2w', 6),
('Artist',   'Lillia A.',  '2w', 7),
('Artist',   'Brandon J.', '2w', 7),
('Manager',  'Scott K.',   '1e', 9),
('Manager',  'Shirlee M.', '1e', 3),
('Manager',  'Daria O.',   '2w', 6);
