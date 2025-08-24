# [SQL Lesson 3: Queries with constraints (Pt. 2)](https://sqlbolt.com/lesson/select_queries_with_constraints_pt_2)

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

テキストデータを含むカラムで `WHERE` 節を記述する場合、
SQL は大文字小文字を区別しない文字列比較や
ワイルドカードによるパターンマッチを行うための便利な演算子を数多くサポートしています。
以下にテキストデータ特有の演算子をいくつか示します:

| 演算子       | 条件                                                                                       | 例                                                                    |
| ------------ | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------- |
| =            | 文字列の完全一致（大・小文字を区別）                                                       | `col_name = "abc"`                                                    |
| != または <> | 文字列の不一致（大・小文字を区別）                                                         | `col_name != "abcd"`                                                  |
| LIKE         | 文字列の完全一致（大・小文字は無差別）                                                     | `col_name LIKE "ABC"`                                                 |
| NOT LIKE     | 文字列の不一致（大・小文字は無差別）                                                       | `col_name NOT LIKE "ABCD"`                                            |
| %            | 文字列のどこでも使用でき、0文字以上の任意の文字列とマッチする（LIKE または NOT LIKE のみ） | `col_name LIKE "%AT%"` (例: "AT", "ATTIC", "CAT", "BATS" など)        |
| _            | 文字列のどこでも使用でき、任意の単一文字とマッチする（LIKE または NOT LIKE のみ）          | `col_name LIKE "AN_"` (例: "AND" はマッチするが、"AN" はマッチしない) |
| IN (…)       | リスト内の文字列が存在する                                                                 | `col_name IN ("A", "B", "C")`                                         |
| NOT IN (…)   | リスト内の文字列が存在しない                                                               | `col_name NOT IN ("D", "E", "F")`                                     |

ご存知でしたか？

クエリ・パーサが文字列内の単語とSQLキーワードを区別できるように、
すべての文字列は引用符で囲む必要があります。

これらの演算子を使う場合、ほとんどのデータベース実装は非常に効率的ですが、
全文検索は[Apache Lucene](http://lucene.apache.org)や
[Sphinx](http://sphinxsearch.com)のような専用ライブラリに任せるのがベストであることに注意しなければなりません。
これらのライブラリは全文検索を行うために特別に設計されており、その結果、より効率的で、国際化や高度なクエリなど、より幅広い検索機能をサポートすることができます。

## 練習問題

上記の演算子を使って、以下のタスクで必要な情報に結果を限定するクエリを書いてみてください。

制約付き選択クエリ:

```SQL
  SELECT column, another_column, ... FROM mytable WHERE _condition_ AND/OR _another_condition_ AND/OR ...;
```

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

1. Find all the Toy Story movies
2. Find all the movies directed by John Lasseter
3. Find all the movies (and director) not directed by John Lasseter
4. Find all the WALL-* movies

## 原文

When writing `WHERE` clauses with columns containing text data, SQL supports a number of useful operators to do things like case-insensitive string comparison and wildcard pattern matching. We show a few common text-data specific operators below:

| Operator                                      | Condition                                                                                             | Example                         |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------- |
| =                                             | Case sensitive exact string comparison (notice the single equals)                                     | col_name = "abc"                |
| != or <>                                      | Case sensitive exact string inequality comparison                                                     | col_name != "abcd"              |
| LIKE                                          | Case insensitive exact string comparison                                                              | col_name LIKE "ABC"             |
| NOT LIKE                                      | Case insensitive exact string inequality comparison                                                   | col_name NOT LIKE "ABCD"        |
| %                                             | Used anywhere in a string to match a sequence of zero or more characters (only with LIKE or NOT LIKE) | col_name LIKE "%AT%"            |
| (matches "AT", "ATTIC", "CAT" or even "BATS") |                                                                                                       |                                 |
| _                                             | Used anywhere in a string to match a single character (only with LIKE or NOT LIKE)                    | col_name LIKE "AN_"             |
| (matches "AND", but not "AN")                 |                                                                                                       |                                 |
| IN (…)                                        | String exists in a list                                                                               | col_name IN ("A", "B", "C")     |
| NOT IN (…)                                    | String does not exist in a list                                                                       | col_name NOT IN ("D", "E", "F") |

Did you know?

All strings must be quoted so that the query parser can distinguish words in the string from SQL keywords.

We should note that while most database implementations are quite efficient when using these operators, full-text search is best left to dedicated libraries like [Apache Lucene](http://lucene.apache.org/ "Apache Lucene") or [Sphinx](http://sphinxsearch.com/ "Sphinx Search"). These libraries are designed specifically to do full text search, and as a result are more efficient and can support a wider variety of search features including internationalization and advanced queries.

## Exercise

Here's the definition of a query with a `WHERE` clause again, go ahead and try and write some queries with the operators above to limit the results to the information we need in the tasks below.

Select query with constraints:

```SQL
  SELECT column, another_column, … FROM mytable **WHERE _condition_ AND/OR _another_condition_ AND/OR …**;
```
