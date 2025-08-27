# [SQL Lesson 4: Filtering and sorting Query results](https://sqlbolt.com/lesson/filtering_sorting_query_results)

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

データベース内のデータは通常、行全体では互いに一意であるように設計されますが、
クエリの結果としては、一部の列に条件をかけて取得するので、必ずしも一意とは限りません。
Movies テーブルを例にとると、同じ監督による作品は複数存在しえます。
（例えば、2000 年以前の映画の監督を取得すると、John Lasseter、John Lasseter、John Lasseter のように重複し得るということです。）
このような場合、SQL では `DISTINCT` キーワードを使うことで、
`SELECT` で指定した列の値（複数列の場合は値の組み合わせ）が同一の行を、
結果からまとめて1行にできます。

一意な結果を持つ `SELECT` クエリ:

```SQL
  SELECT DISTINCT column, another_column, ... FROM mytable WHERE condition(s);
```

なお、`DISTINCT` は指定列の組み合わせが同じなら、
ほかの列が違っても1行に集約されるため、
特定の列だけで重複排除したいときは、今後学ぶ `GROUP BY` を使います。

## 結果のソート

レッスンでは id 順かつ公開年順にある程度きれいに行が並べられていますが、
実際のデータベースでは、
このように特定のカラムの順番に並べられていることはありません。
追加順に行が増えていくだけだからです。
その結果、テーブルのサイズが何千行、何百万行と大きくなるにつれて、
クエリの結果を読み解くことは困難になります。

これを解決するために、SQL には `ORDER BY` 句が用意されています。
これにより、指定したカラムの昇順または降順で、
データ取得後に結果をソートすることができます。

結果を並べ替えた `SELECT` クエリ:

```SQL
  SELECT column, another_column, ... FROM mytable WHERE condition(s) ORDER BY column ASC/DESC;
```

`ORDER BY` 句が指定されると、
各行は指定されたカラムの値に基づいて（文字列ならば）アルファベット順にソートされます。
DBMS によっては、
言語ごとに照合順序が用意されており、
適切な言語を指定することもできます。

>追記１  
>- `ASC` の場合は省略可能。
>- `ORDER BY column1, column2` のように複数指定すると、column1 について比較し並べたあと、決着しない部分は column2 を見て並べる。

>追記２  
NULL の並び位置はDBMSで既定が異なる（例：PostgreSQL/Oracle では **NULL は最後**、MySQL/SQL Server では **NULL は最初**）。必要に応じて `NULLS FIRST/LAST` や `ORDER BY (col IS NULL), col` で明示する対応。

## 結果の件数を指定する

`ORDER BY` 句はしばしば `LIMIT` 句や `OFFSET` 句とセットで使用します。
`LIMIT` は返す行数を制限する指定で、
オプションの `OFFSET` は、さらにどこから行数をカウントし始めるかを指定します。

行数を制限した `SELECT` クエリ:

```SQL
  SELECT column, another_column, ... FROM mytable WHERE condition(s) ORDER BY column ASC/DESC LIMIT num_limit OFFSET num_offset;
```

>追記３  
>- `OFFSET 5` は、**6件目以降**になる。
>- ※ DBMS 方言: 
SQL Server は `TOP / OFFSET … FETCH`、標準 SQL は `FETCH FIRST n ROWS ONLY` も使用されます。

Reddit や Pinterest のようなウェブサイトを考えてみると、
トップページは人気順と時間順に並べ替えられたリンクのリストであり、
それに続く各ページはデータベース内の異なるオフセットにあるリンクのセットで表すことができます。
これらの句を使うことで、データベースはクエリをより速く効率的に実行し、
要求されたコンテンツだけを処理して返すことが可能になります。


>**Did you know?**  
`LIMIT` と `OFFSET` がクエリ内でいつ評価されるかという優先度についてですが、
一般的には、他の句が評価された後、最後に評価されます。
なお、優先度については、
[Lesson 12: 実行順序](https://sqlbolt.com/lesson/select_queries_order_of_execution)
でより詳しく触れることにします。

## 練習問題

このレッスンには新たな概念が複数登場しましたが、そんなに難しいものではありません。
上記で紹介した必要なキーワードや句を使ってクエリを構成してみてください。

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

1. List all directors of Pixar movies (alphabetically), without duplicates
2. List the last four Pixar movies released (ordered from most recent to least)
3. List the first five Pixar movies sorted alphabetically
4. List the next five Pixar movies sorted alphabetically

<details>
  <summary>解答の期待値</summary>

  1. List all directors of Pixar movies (alphabetically), without duplicates
  ```psql
        director
    ----------------
     Andrew Stanton
     Brad Bird
     Brenda Chapman
     Dan Scanlon
     John Lasseter
     Lee Unkrich
     Pete Docter
  ```
  2. List the last four Pixar movies released (ordered from most recent to least)
  ```psql
     id |        title        |    director    | year | length_minutes
    ----+---------------------+----------------+------+----------------
     14 | Monsters University | Dan Scanlon    | 2013 |            110
     13 | Brave               | Brenda Chapman | 2012 |            102
     12 | Cars 2              | John Lasseter  | 2011 |            120
     11 | Toy Story 3         | Lee Unkrich    | 2010 |            103
  ```
  3. List the first five Pixar movies sorted alphabetically
  ```psql
     id |    title     |    director    | year | length_minutes
    ----+--------------+----------------+------+----------------
      2 | A Bug's Life | John Lasseter  | 1998 |             95
     13 | Brave        | Brenda Chapman | 2012 |            102
      7 | Cars         | John Lasseter  | 2006 |            117
     12 | Cars 2       | John Lasseter  | 2011 |            120
      5 | Finding Nemo | Andrew Stanton | 2003 |            107
  ```
  4. List the next five Pixar movies sorted alphabetically
  ```psql
     id |        title        |   director    | year | length_minutes
    ----+---------------------+---------------+------+----------------
      4 | Monsters, Inc.      | Pete Docter   | 2001 |             92
     14 | Monsters University | Dan Scanlon   | 2013 |            110
      8 | Ratatouille         | Brad Bird     | 2007 |            115
      6 | The Incredibles     | Brad Bird     | 2004 |            116
      1 | Toy Story           | John Lasseter | 1995 |             81
  ```
</details>

<details>
  <summary>解答例</summary>

  1. List all directors of Pixar movies (alphabetically), without duplicates
  ```sql
    SELECT DISTINCT director FROM movies ORDER BY director;
  ```
  2. List the last four Pixar movies released (ordered from most recent to least)
  ```sql
    SELECT * FROM movies ORDER BY year DESC LIMIT 4;
  ```
  3. List the first five Pixar movies sorted alphabetically
  ```sql
    SELECT * FROM movies ORDER BY title ASC LIMIT 5;
  ```
  4. List the next five Pixar movies sorted alphabetically
  ```sql
    SELECT * FROM movies ORDER BY title ASC LIMIT 5 OFFSET 5;
  ```
</details>

<details>
  <summary>原文</summary>

  Even though the data in a database may be unique, the results of any particular query may not be – take our Movies table for example, many different movies can be released the same year. In such cases, SQL provides a convenient way to discard rows that have a duplicate column value by using the `DISTINCT` keyword.

  Select query with unique results:

  ```SQL
    SELECT DISTINCT column, another_column, … FROM mytable WHERE condition(s);
  ```

  Since the `DISTINCT` keyword will blindly remove duplicate rows, we will learn in a future lesson how to discard duplicates based on specific columns using grouping and the `GROUP BY` clause.

  ## Ordering results

  Unlike our neatly ordered table in the last few lessons, most data in real databases are added in no particular column order. As a result, it can be difficult to read through and understand the results of a query as the size of a table increases to thousands or even millions rows.

  To help with this, SQL provides a way to sort your results by a given column in ascending or descending order using the `ORDER BY` clause.

  Select query with ordered results:

  ```SQL
    SELECT column, another_column, … FROM mytable WHERE condition(s) ORDER BY column ASC/DESC;
  ```

  When an `ORDER BY` clause is specified, each row is sorted alpha-numerically based on the specified column's value. In some databases, you can also specify a collation to better sort data containing international text.

  ## Limiting results to a subset

  Another clause which is commonly used with the `ORDER BY` clause are the `LIMIT` and `OFFSET` clauses, which are a useful optimization to indicate to the database the subset of the results you care about.  
  The `LIMIT` will reduce the number of rows to return, and the optional `OFFSET` will specify where to begin counting the number rows from.

  Select query with limited rows:

  ```SQL
    SELECT column, another_column, … FROM mytable WHERE condition(s) ORDER BY column ASC/DESC LIMIT num_limit OFFSET num_offset;
  ```

  If you think about websites like Reddit or Pinterest, the front page is a list of links sorted by popularity and time, and each subsequent page can be represented by sets of links at different offsets in the database. Using these clauses, the database can then execute queries faster and more efficiently by processing and returning only the requested content.

  >**Did you know?**  
  If you are curious about when the `LIMIT` and `OFFSET` are applied relative to the other parts of a query, they are generally done last after the other clauses have been applied. We'll touch more on this in [Lesson 12: Order of execution](https://sqlbolt.com/lesson/select_queries_order_of_execution) after introducting a few more parts of the query.

  ## Exercise

  There are a few concepts in this lesson, but all are pretty straight-forward to apply. To spice things up, we've gone and scrambled the **Movies** table for you in the exercise to better mimic what kind of data you might see in real life. Try and use the necessary keywords and clauses introduced above in your queries.
</details>