# [SQL Lesson 10: Queries with aggregates (Pt. 1)](https://sqlbolt.com/lesson/select_queries_with_aggregates)

課題の表を再現するschema兼seedクエリ:

```SQL
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
  \i /home/postgres/dataset/sqlbolt/employees.sql
```

## 本文

前回のレッスンで紹介した単純な式だけでなく、
SQLではデータ行のグループに関する情報を要約できる集計式（または関数）の使用もサポートしています。
これまで使用してきたPixarデータベースを使用すると、
集計関数を使用して
「Pixarは何本の映画を制作したのか」、
「毎年最も興行収入の高いPixar映画は何か」
といった質問に答えることができます。

全行に対する集計関数を使用したSelectクエリ:

```SQL
  SELECT AGG_FUNC(column_or_expression) AS aggregate_description, ...
  FROM mytable
  WHERE constraint_expression;
```

グループ化を指定しないと、
各集計関数は結果行のセット全体に対して実行され、単一の値を返します。
そして、通常の式と同様に、集計関数に別名を与えることで、
結果を読みやすく、処理しやすくすることができます。

## 一般的な集計関数

この例で使用する一般的な集計関数をいくつか示します:

| 関数                        | 解説                                                                                                                                 |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `COUNT(*)`, `COUNT(column)` | 特定のcolumnを指定しない場合、グループ内の行数をすべてカウント。columnを指定した場合、NULL以外の値を持つグループ内の行数をカウント。 |
| `MIN(column)`               | グループ内のすべての行について、指定された列で最小値を見つける。                                                                     |
| `MAX(column)`               | グループ内のすべての行について、指定された列で最大値を見つける。                                                                     |
| `AVG(column)`               | グループ内のすべての行について、指定された列の平均値を求めます。                                                                     |
| `SUM(column)`               | グループ内の行について、指定された列の合計値を求めます。                                                                             |

公式ドキュメント:
[MySQL](https://dev.mysql.com/doc/refman/5.6/en/group-by-functions.html),
[PostgreSQL](http://www.postgresql.org/docs/9.4/static/functions-aggregate.html),
[SQLite](http://www.sqlite.org/lang_aggfunc.html),
[Microsoft SQL Server](https://msdn.microsoft.com/en-us/library/ms173454.aspx),

## グループ化された集計関数

すべての行を集計するだけでなく、グループ内の個々のデータグループ
（例えば、コメディー映画の興行収入とアクション映画の興行収入）
に集計関数を適用することもできます。
これは、`GROUP BY`句で定義されたユニークなグループの数だけ結果を作成します。

グループに対する集計関数を使用したSelectクエリ:

```SQL
  SELECT AGG_FUNC(column_or_expression) AS aggregate_description, ...
  FROM mytable
  WHERE constraint_expression
  GROUP BY column;
```

`GROUP BY`句は、指定されたカラムに同じ値を持つ行をグループ化することで機能します。

## 練習問題

この演習では、**Employees** テーブルを使用します。
このテーブルの行がどのように共有データを持っているかに注目し、
集計関数を使用してチームに関する高レベルのメトリクスを要約する機会を得ます。
さっそく試してみましょう。

1. Find the longest time that an employee has been at the studio
2. For each role, find the average number of years employed by employees in that role
3. Find the total number of employee years worked in each building

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

In addition to the simple expressions that we introduced last lesson, SQL also supports the use of aggregate expressions (or functions) that allow you to summarize information about a group of rows of data. With the Pixar database that you've been using, aggregate functions can be used to answer questions like, "How many movies has Pixar produced?", or "What is the highest grossing Pixar film each year?".

Select query with aggregate functions over all rows

```SQL
  SELECT AGG_FUNC(column_or_expression) AS aggregate_description, …
  FROM mytable
  WHERE constraint_expression;
```

Without a specified grouping, each aggregate function is going to run on the whole set of result rows and return a single value. And like normal expressions, giving your aggregate functions an alias ensures that the results will be easier to read and process.

## Common aggregate functions

Here are some common aggregate functions that we are going to use in our examples:

| Function                | Description                                                                                                                                                                                     |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| COUNT(*), COUNT(column) | A common function used to counts the number of rows in the group if no column name is specified. Otherwise, count the number of rows in the group with non-NULL values in the specified column. |
| MIN(column)             | Finds the smallest numerical value in the specified column for all rows in the group.                                                                                                           |
| MAX(column)             | Finds the largest numerical value in the specified column for all rows in the group.                                                                                                            |
| AVG(column)             | Finds the average numerical value in the specified column for all rows in the group.                                                                                                            |
| SUM(column)             | Finds the sum of all numerical values in the specified column for the rows in the group.                                                                                                        |

Docs:
[MySQL](https://dev.mysql.com/doc/refman/5.6/en/group-by-functions.html),
[PostgreSQL](http://www.postgresql.org/docs/9.4/static/functions-aggregate.html),
[SQLite](http://www.sqlite.org/lang_aggfunc.html),
[Microsoft SQL Server](https://msdn.microsoft.com/en-us/library/ms173454.aspx),

## Grouped aggregate functions

In addition to aggregating across all the rows, you can instead apply the aggregate functions to individual groups of data within that group (ie. box office sales for Comedies vs Action movies).  
This would then create as many results as there are unique groups defined as by the `GROUP BY` clause.

Select query with aggregate functions over groups

```SQL
  SELECT AGG_FUNC(column_or_expression) AS aggregate_description, …
  FROM mytable
  WHERE constraint_expression
  GROUP BY column;
```

The `GROUP BY` clause works by grouping rows that have the same value in the column specified.

## Exercise

For this exercise, we are going to work with our **Employees** table. Notice how the rows in this table have shared data, which will give us an opportunity to use aggregate functions to summarize some high-level metrics about the teams. Go ahead and give it a shot.

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
