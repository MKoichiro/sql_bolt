# [SQL Lesson 3: Queries with constraints (Pt. 2)](https://sqlbolt.com/lesson/select_queries_with_constraints_pt_2)

<details>
  <summary>課題の表を再現するseedコマンド:</summary>

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

  または以下を実行:

  ```psql
    \i /home/postgres/dataset/sqlbolt/movies.sql
  ```
</details>

## 訳文

文字列データを含むカラムで `WHERE` 句を記述する場合、
SQL は大文字小文字を区別しない文字列比較や
ワイルドカードによるパターンマッチを行うための便利な演算子を数多くサポートしています。
以下に文字列データ特有の演算子をいくつか示します:

| 演算子       | 条件                                                                                       | 例                                                                    |
| ------------ | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------- |
| =            | 文字列の完全一致（大・小文字を区別）                                                       | `col_name = 'abc'`                                                    |
| <> (または !=) | 文字列の不一致（大・小文字を区別）                                                         | `col_name <> 'abcd'`                                                  |
| LIKE         | 文字列の完全一致（大小区別は方言）                                                     | `col_name LIKE 'ABC'`                                                 |
| NOT LIKE     | 文字列の不一致（大小区別は方言）                                                       | `col_name NOT LIKE 'ABCD'`                                            |
| %            | 文字列のどこでも使用でき、0文字以上の任意の文字列とマッチする（LIKE または NOT LIKE のみ） | `col_name LIKE '%AT%'` (例: "AT", "ATTIC", "CAT", "BATS" など)        |
| _            | 文字列のどこでも使用でき、任意の単一文字とマッチする（LIKE または NOT LIKE のみ）          | `col_name LIKE 'AN_'` (例: "AND" はマッチするが、"AN" はマッチしない) |
| IN (…)       | `()`の文字列のどれかと完全一致する                                                                 | `col_name IN ('A', 'B', 'C')`                                         |
| NOT IN (…)   | `()`の文字列のどれとも一致しない                                                               | `col_name NOT IN ('D', 'E', 'F')`                                     |

>**Did you know?**  
クエリ・パーサが文字列内の単語とSQLキーワードを区別できるように、
すべての文字列は引用符で囲む必要があります。

ほとんどのケースでこれらの演算子は非常に効率的ですが、
**全文検索**を行う場合には[Apache Lucene](http://lucene.apache.org)や
[Sphinx](http://sphinxsearch.com)のような専用ライブラリに任せるのがベストでしょう。
これらのライブラリは全文検索を行うために特別に設計されており、
より効率的で、国際化や高度なクエリなど、より幅広い検索機能をサポートしています。

>追記１  
**全文検索**とは、長い文章や大量の文書の中から「単語・フレーズ」を高速かつ賢く探すための専用仕組みです。
記事本文、コメント、商品説明など長文テキストを本気で探したいときに使用する手法であり、
ID やコード、短い文字列の完全一致/前方一致であれば、`LIKE 'abc%'` などで十分です。

>追記２  
引用符のルールはRDBMS間で異なります。
ダブルクォートは方言によっては文字列に使用できません。
文字列表現はシングルクォートの採用が多いので、基本的にシングルクォートを使うのがよいです。
ダブルクォートやバッククォートはテーブル名やカラム名などの表現に割り当てられていることが多いです。
例えばPostgreSQLでは、ダブルクォートはテーブル名やカラム名、シングルクォートが文字列、バッククォートは使用しない、というルールになっています。

>追記３  
詳細は省きますが、同様に互換性の観点から、不一致は`!=`より`<>`が推奨されます。


## 練習問題

上記の演算子を使って、以下のタスクで必要な情報に結果を限定するクエリを書いてみてください。

条件付き `SELECT` クエリ:

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

<details>
  <summary>解答の期待値</summary>

  1. Find all the Toy Story movies
  ```psql
     id |    title    |   director    | year | length_minutes
    ----+-------------+---------------+------+----------------
      1 | Toy Story   | John Lasseter | 1995 |             81
      3 | Toy Story 2 | John Lasseter | 1999 |             93
     11 | Toy Story 3 | Lee Unkrich   | 2010 |            103
  ```
  2. Find all the movies directed by John Lasseter
  ```psql
     id |    title     |   director    | year | length_minutes
    ----+--------------+---------------+------+----------------
      1 | Toy Story    | John Lasseter | 1995 |             81
      2 | A Bug's Life | John Lasseter | 1998 |             95
      3 | Toy Story 2  | John Lasseter | 1999 |             93
      7 | Cars         | John Lasseter | 2006 |            117
     12 | Cars 2       | John Lasseter | 2011 |            120
  ```
  3. Find all the movies (and director) not directed by John Lasseter
  ```psql
            title        |    director
    ---------------------+----------------
     Monsters, Inc.      | Pete Docter
     Finding Nemo        | Andrew Stanton
     The Incredibles     | Brad Bird
     Ratatouille         | Brad Bird
     WALL-E              | Andrew Stanton
     Up                  | Pete Docter
     Toy Story 3         | Lee Unkrich
     Brave               | Brenda Chapman
     Monsters University | Dan Scanlon
  ```
  4. Find all the WALL-* movies
  ```psql
     title
    --------
    WALL-E
  ```
</details>

<details>
  <summary>解答例</summary>

  1. Find all the Toy Story movies
  ```psql
    SELECT * FROM movies WHERE title LIKE 'Toy Story%';
  ```
  2. Find all the movies directed by John Lasseter
  ```psql
    SELECT * FROM movies WHERE director = 'John Lasseter';
  ```
  3. Find all the movies (and director) not directed by John Lasseter
  ```psql
    SELECT title, director FROM movies WHERE director <> 'John Lasseter';
  ```
  4. Find all the WALL-* movies
  ```psql
    SELECT title FROM movies WHERE title LIKE 'WALL-%';
  ```
</details>

<details>
  <summary>原文</summary>

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

  >**Did you know?**  
  All strings must be quoted so that the query parser can distinguish words in the string from SQL keywords.

  We should note that while most database implementations are quite efficient when using these operators, full-text search is best left to dedicated libraries like [Apache Lucene](http://lucene.apache.org/ "Apache Lucene") or [Sphinx](http://sphinxsearch.com/ "Sphinx Search"). These libraries are designed specifically to do full text search, and as a result are more efficient and can support a wider variety of search features including internationalization and advanced queries.

  ## Exercise

  Here's the definition of a query with a `WHERE` clause again, go ahead and try and write some queries with the operators above to limit the results to the information we need in the tasks below.

  Select query with constraints:

  ```SQL
    SELECT column, another_column, … FROM mytable **WHERE _condition_ AND/OR _another_condition_ AND/OR …**;
  ```
</details>
