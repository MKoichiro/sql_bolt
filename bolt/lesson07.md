# [SQL Lesson 7: OUTER JOINs](https://sqlbolt.com/lesson/select_queries_with_outer_joins)

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

データをどのように分析したいかによって、
前回のレッスンで使用した `INNER JOIN` では不十分な場合があります。

2つのテーブルが非対称なデータを持っている場合、
これはデータが異なる段階で入力された場合に起こりやすいので、
必要なデータが結果から取り残されないようにするためには、
代わりに`LEFT JOIN`、`RIGHT JOIN`、`FULL JOIN`を使用する必要があります。

複数のテーブルに LEFT/RIGHT/FULL JOIN を使用した選択クエリ:

```SQL
  SELECT column, another_column, ...
  FROM table_A INNER/LEFT/RIGHT/FULL JOIN table_B
    ON table_A.id = table_B.matching_id
  WHERE condition(s)
  ORDER BY column, ... ASC/DESC
  LIMIT num_limit OFFSET num_offset;
```

`INNER JOIN`と同様に、これら3つの新しい`JOIN`クエリでも、
どのカラムでデータを結合するかを指定しなければなりません。
テーブルAとテーブルBを結合する場合を考えてそれぞれのクエリを解説します。
まず、`LEFT JOIN` は、Bにマッチする行が無くても、NULLで補完してAの行は保持します。
次に、`RIGHT JOIN`も似ていますが、逆にAにマッチする行がない場合に、Bの行を保持します。
最後に、`FULL JOIN`は、A, Bの全ての行を保存して結合します。

これらの新しい`JOIN`クエリを使用する場合、
結果と制約の`NULL`を処理するために追加のロジックを書く必要があるでしょう（これについては次のレッスンで詳しく説明します）。

Did you know?

これらのクエリはそれぞれ、
`LEFT OUTER JOIN`、`RIGHT OUTER JOIN`、`FULL OUTER JOIN`
と表記されることもありますが、
`OUTER` キーワードは SQL-92 との互換性のために残しているもので、
単に `LEFT JOIN`、`RIGHT JOIN`、`FULL JOIN` とするのと等価です。

## 練習問題

この演習では、映画スタジオの**Employees**と割り当てられたオフィスの**Buildings**に関する架空のデータを格納する新しいテーブルを扱います。
いくつかのビルは新しいので、まだ従業員はいませんが、それらに関係なく、いくつかの情報を見つける必要があります。

私たちのブラウザSQLデータベースはやや限られているので、以下の演習では`LEFT JOIN`だけがサポートされています。

1. Find the list of all buildings that have employees
2. Find the list of all buildings and their capacity
3. List all buildings and the distinct employee roles in each building (including empty buildings)

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

Depending on how you want to analyze the data, the `INNER JOIN` we used last lesson might not be sufficient because the resulting table only contains data that belongs in both of the tables.

If the two tables have asymmetric data, which can easily happen when data is entered in different stages, then we would have to use a `LEFT JOIN`, `RIGHT JOIN` or `FULL JOIN` instead to ensure that the data you need is not left out of the results.

Select query with LEFT/RIGHT/FULL JOINs on multiple tables

```SQL
  SELECT column, another_column, …
  FROM mytable INNER/LEFT/RIGHT/FULL JOIN another_table
    ON mytable.id = another_table.matching_id
  WHERE condition(s)
  ORDER BY column, … ASC/DESC
  LIMIT num_limit OFFSET num_offset;
```

Like the `INNER JOIN` these three new joins have to specify which column to join the data on.  
When joining table A to table B, a `LEFT JOIN` simply includes rows from A regardless of whether a matching row is found in B. The `RIGHT JOIN` is the same, but reversed, keeping rows in B regardless of whether a match is found in A. Finally, a `FULL JOIN` simply means that rows from both tables are kept, regardless of whether a matching row exists in the other table.

When using any of these new joins, you will likely have to write additional logic to deal with `NULL`s in the result and constraints (more on this in the next lesson).

Did you know?

You might see queries with these joins written as `LEFT OUTER JOIN`, `RIGHT OUTER JOIN`, or `FULL OUTER JOIN`, but the `OUTER` keyword is really kept for SQL-92 compatibility and these queries are simply equivalent to `LEFT JOIN`, `RIGHT JOIN`, and `FULL JOIN` respectively.

## Exercise

In this exercise, you are going to be working with a new table which stores fictional data about **Employees** in the film studio and their assigned office **Buildings**. Some of the buildings are new, so they don't have any employees in them yet, but we need to find some information about them regardless.

Since our browser SQL database is somewhat limited, only the `LEFT JOIN` is supported in the exercise below.

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
