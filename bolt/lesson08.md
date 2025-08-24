# [SQL Lesson 8: A short note on NULLs](https://sqlbolt.com/lesson/select_queries_with_nulls)

課題の表を再現するschema兼seedクエリ:

```SQL
DROP TABLE IF EXISTS buildings

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

DROP TABLE IF EXISTS employees

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
```

```psql
  \i /home/postgres/dataset/sqlbolt/buildings-employees.sql
```

## 本文

前回少し触れましたが、
SQLデータベースにおける`NULL`値について早速ここで取り上げます。
とはいえ、通常`NULL`はできる限り取り除かれるべきです。
なぜなら、クエリや制約（ある種の関数は`NULL`値に対して異なる動作をします）を作成するときや結果を処理するときに、
特別な注意を払う必要があるからです。

`NULL`に対するひとつの代替案としては、
数値データには `0`、テキストデータには空の文字列`''`など、
データ型に応じたデフォルト値を設定する方法があります。
しかし、そのような不完全なデータを保存してしまうと、
値を用いて分析（例えば、数値データの平均）する時に困ります。
何らかの分析を念頭に置くケースでは、最初から`NULL`値を使用しておくのが適切です。

また、前回のレッスンで非対称データを持つ2つのテーブルを外部結合する際に見たように、
`NULL`値を避けることができない場合もあります。
このような場合は、`IS NULL` または `IS NOT NULL` 制約を使用して、
`WHERE` 句で `NULL` 値があるかどうかで絞り込みができます。。

`NULL` 値に対する制約を持つクエリを選択してください:

```SQL
  SELECT column, another_column, ...
  FROM mytable
  WHERE column IS(/IS NOT) NULL
  AND/OR another_condition
  AND/OR ...;
```

## 練習問題

この演習は、ここ数回のレッスンの復習を兼ねています。
前回のレッスンと同じ**Employees**と**Buildings**テーブルを使います。
ビルを割り当てられていない従業員がイルことに注意してください。

1. Find the name and role of all employees who have not been assigned to a building
2. Find the names of the buildings that hold no employees

| building_name | capacity |
| ------------- | -------- |
| 1e            | 24       |
| 1w            | 32       |
| 2e            | 16       |
| 2w            | 20       |

| role     | name       | building | years_employed |
| -------- | ---------- | -------- | -------------- |
| Engineer | Becky A.   | 1e       | 4              |
| Engineer | Dan B.     | 1e       | 2              |
| Engineer | Sharon F.  | 1e       | 6              |
| Engineer | Dan M.     | 1e       | 4              |
| Engineer | Malcom S.  | 1e       | 1              |
| Artist   | Tylar S.   | 2w       | 2              |
| Artist   | Sherman D. | 2w       | 8              |
| Artist   | Jakob J.   | 2w       | 6              |
| Artist   | Lillia A.  | 2w       | 7              |
| Artist   | Brandon J. | 2w       | 7              |
| Manager  | Scott K.   | 1e       | 9              |
| Manager  | Shirlee M. | 1e       | 3              |
| Manager  | Daria O.   | 2w       | 6              |

## 原文

As promised in the last lesson, we are going to quickly talk about `NULL` values in an SQL database. It's always good to reduce the possibility of `NULL` values in databases because they require special attention when constructing queries, constraints (certain functions behave differently with null values) and when processing the results.

An alternative to `NULL` values in your database is to have _data-type appropriate default values_, like 0 for numerical data, empty strings for text data, etc. But if your database needs to store incomplete data, then `NULL` values can be appropriate if the default values will skew later analysis (for example, when taking averages of numerical data).

Sometimes, it's also not possible to avoid `NULL` values, as we saw in the last lesson when outer-joining two tables with asymmetric data. In these cases, you can test a column for `NULL` values in a `WHERE` clause by using either the `IS NULL` or `IS NOT NULL` constraint.

Select query with constraints on NULL values:

```SQL
  SELECT column, another_column, …
  FROM mytable
  WHERE column IS/IS NOT NULL
  AND/OR another_condition
  AND/OR …;
```

## Exercise

This exercise will be a sort of review of the last few lessons. We're using the same **Employees** and **Buildings** table from the last lesson, but we've hired a few more people, who haven't yet been assigned a building.

| building_name | capacity |
| ------------- | -------- |
| 1e            | 24       |
| 1w            | 32       |
| 2e            | 16       |
| 2w            | 20       |

| role     | name       | building | years_employed |
| -------- | ---------- | -------- | -------------- |
| Engineer | Becky A.   | 1e       | 4              |
| Engineer | Dan B.     | 1e       | 2              |
| Engineer | Sharon F.  | 1e       | 6              |
| Engineer | Dan M.     | 1e       | 4              |
| Engineer | Malcom S.  | 1e       | 1              |
| Artist   | Tylar S.   | 2w       | 2              |
| Artist   | Sherman D. | 2w       | 8              |
| Artist   | Jakob J.   | 2w       | 6              |
| Artist   | Lillia A.  | 2w       | 7              |
| Artist   | Brandon J. | 2w       | 7              |
| Manager  | Scott K.   | 1e       | 9              |
| Manager  | Shirlee M. | 1e       | 3              |
| Manager  | Daria O.   | 2w       | 6              |
