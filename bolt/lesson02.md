# [SQL Lesson 2: Queries with constraints (Pt. 1)](https://sqlbolt.com/lesson/select_queries_with_constraints)

課題の表を再現するschema兼seedクエリ:

```SQL
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
(3,  'Toy Story 2',         'John Lasseter',  1999, 93),
(4,  'Monsters, Inc.',      'Pete Docter',    2001, 92),
(5,  'Finding Nemo',        'Andrew Stanton', 2003, 107),
(6,  'The Incredibles',     'Brad Bird',      2004, 116),
(7,  'Cars',                'John Lasseter',  2006, 117),
(8,  'Ratatouille',         'Brad Bird',      2007, 115),
(9,  'WALL-E',              'Andrew Stanton', 2008, 104),
(10, 'Up',                  'Pete Docter',    2009, 101),
(11, 'Toy Story 3',         'Lee Unkrich',    2010, 103),
(12, 'Cars 2',              'John Lasseter',  2011, 120),
(13, 'Brave',               'Brenda Chapman', 2012, 102),
(14, 'Monsters University', 'Dan Scanlon',    2013, 110);
```

```psql
  \i /home/postgres/dataset/sqlbolt/movies.sql
```

## 本文

テーブルから特定の列のデータを選択する方法はわかったが、
もし1億行のデータを持つテーブルがあったとしたら、
すべての行に目を通すことは非効率的であり、おそらく不可能だろう。

特定の結果を返さないようにフィルタリングするには、
クエリで `WHERE` 句を使用する必要があります。
この句は、特定のカラムの値をチェックすることで、
データの各行に適用され、結果に含めるかどうかを決定する。

制約付きSELECTクエリ:

```SQL
  SELECT column, another_column, ... FROM mytable WHERE condition AND/OR another_condition AND/OR ...;
```

より複雑な句は、複数の`AND`または`OR`論理キーワードを結合することで構築できる
（例えば、num_wheels &gt;= 4 AND doors &lt;= 2）。
また、数値データ（整数や浮動小数点など）に使える便利な演算子を以下に示す:

| 演算子              | 条件                                      | SQL の例                        |
| ------------------- | ----------------------------------------- | ------------------------------- |
| =, !=, <, <=, >, >= | 標準的な数値演算子                        | `col_name != 4`                 |
| BETWEEN … AND …     | 数値が 2 つの値の範囲（両端を含む）にある | `col_name BETWEEN 1.5 AND 10.5` |
| NOT BETWEEN … AND … | 数値が 2 つの値の範囲（両端を含む）にない | `col_name NOT BETWEEN 1 AND 10` |
| IN ( … )            | 数値がリストに含まれる                    | `col_name IN (2, 4, 6)`         |
| NOT IN ( … )        | 数値がリストに含まれない                  | `col_name NOT IN (1, 3, 5)`     |

結果をより理解しやすくすることに加え、返される行のセットを制約する節を書くことで、
返される不要なデータが減るため、クエリの実行が速くなります。

ご存知でしたか？

もうお気づきかもしれませんが、SQLはキーワードをすべて大文字で書くことを必須とはしていません。
しかし、慣習として、SQLキーワードとカラム名やテーブル名を区別しやすくし、クエリを読みやすくしています。

## 練習問題

正しい制約を使用して、以下の各タスクについて、**Movies**テーブルから必要な情報を見つけてください。

| id  | title               | director       | year | length_minutes |
| --- | ------------------- | -------------- | ---- | -------------- |
| 1   | Toy Story           | John Lasseter  | 1995 | 81             |
| 2   | A Bug's Life        | John Lasseter  | 1998 | 95             |
| 3   | Toy Story 2         | John Lasseter  | 1999 | 93             |
| 4   | Monsters, Inc.      | Pete Docter    | 2001 | 92             |
| 5   | Finding Nemo        | Andrew Stanton | 2003 | 107            |
| 6   | The Incredibles     | Brad Bird      | 2004 | 116            |
| 7   | Cars                | John Lasseter  | 2006 | 117            |
| 8   | Ratatouille         | Brad Bird      | 2007 | 115            |
| 9   | WALL-E              | Andrew Stanton | 2008 | 104            |
| 10  | Up                  | Pete Docter    | 2009 | 101            |
| 11  | Toy Story 3         | Lee Unkrich    | 2010 | 103            |
| 12  | Cars 2              | John Lasseter  | 2011 | 120            |
| 13  | Brave               | Brenda Chapman | 2012 | 102            |
| 14  | Monsters University | Dan Scanlon    | 2013 | 110            |

1. Find the movie with a row id of 6
2. Find the movies released in the years between 2000 and 2010
3. Find the movies not released in the years between 2000 and 2010
4. Find the first 5 Pixar movies and their release year

## 原文

Now we know how to select for specific columns of data from a table, but if you had a table with a hundred million rows of data, reading through all the rows would be inefficient and perhaps even impossible.

In order to filter certain results from being returned, we need to use a `WHERE` clause in the query. The clause is applied to each row of data by checking specific column values to determine whether it should be included in the results or not.

Select query with constraints

`SELECT column, another_column, … FROM mytable **WHERE _condition_ AND/OR _another_condition_ AND/OR …**;`

More complex clauses can be constructed by joining numerous `AND` or `OR` logical keywords (ie. num\_wheels >= 4 AND doors <= 2). And below are some useful operators that you can use for numerical data (ie. integer or floating point):

| Operator            | Condition                                            | SQL Example                   |
| ------------------- | ---------------------------------------------------- | ----------------------------- |
| =, !=, <, <=, >, >= | Standard numerical operators                         | col_name != 4                 |
| BETWEEN … AND …     | Number is within range of two values (inclusive)     | col_name BETWEEN 1.5 AND 10.5 |
| NOT BETWEEN … AND … | Number is not within range of two values (inclusive) | col_name NOT BETWEEN 1 AND 10 |
| IN (…)              | Number exists in a list                              | col_name IN (2, 4, 6)         |
| NOT IN (…)          | Number does not exist in a list                      | col_name NOT IN (1, 3, 5)     |

In addition to making the results more manageable to understand, writing clauses to constrain the set of rows returned also allows the query to run faster due to the reduction in unnecessary data being returned.

Did you know?

As you might have noticed by now, SQL doesn't _require_ you to write the keywords all capitalized, but as a convention, it helps people distinguish SQL keywords from column and tables names, and makes the query easier to read.

## Exercise

Using the right constraints, find the information we need from the **Movies** table for each task below.
