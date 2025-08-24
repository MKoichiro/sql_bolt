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

データベース内のデータが一意であっても、
特定のクエリの結果が一意でない場合があります。
例えば、Moviesテーブルを例にとると、
同じ年に多くの異なる映画が公開される可能性があります。
このような場合、SQLでは`DISTINCT`キーワードを使用することで、
重複したカラム値を持つ行を破棄することができます。

一意な結果を持つ選択クエリ:

```SQL
  SELECT DISTINCT column, another_column, ... FROM mytable WHERE condition(s);
```

`DISTINCT`キーワードは重複行をやみくもに削除してしまうので、
グループ化と`GROUP BY`句を使用して、
特定のカラムに基づいて重複行を破棄する方法を今後のレッスンで学びます。

## 結果の順序付け

ここ数回のレッスンで整然と並べられたテーブルとは異なり、
実際のデータベースのほとんどのデータは、
特定のカラムの順番に追加されることはありません。
その結果、テーブルのサイズが何千行、何百万行と大きくなるにつれて、
クエリの結果を読み解くことが難しくなります。

これを解決するために、SQLでは`ORDER BY`句を使って、
指定したカラムの昇順または降順で結果を並べ替えることができます。

結果を並べ替えたセレクトクエリ:

```SQL
  SELECT column, another_column, ... FROM mytable WHERE condition(s) ORDER BY column ASC/DESC;
```

`ORDER BY`句が指定されると、各行は指定されたカラムの値に基づいてアルファベット順にソートされます。
データベースによっては、国際的なテキストを含むデータをより適切にソートするために照合順序を指定することもできます。

## 結果をサブセットに限定する

`ORDER BY` 節と一緒によく使われるもうひとつの節は `LIMIT` 節と `OFFSET` 節です。
`LIMIT` は返す行数を減らし、オプションの `OFFSET` はどこから行数をカウントし始めるかを指定します。

行数を制限したセレクトクエリ:

```SQL
  SELECT column, another_column, ... FROM mytable WHERE condition(s) ORDER BY column ASC/DESC LIMIT num_limit OFFSET num_offset;
```

RedditやPinterestのようなウェブサイトを考えてみると、
トップページは人気順と時間順に並べ替えられたリンクのリストであり、
それに続く各ページはデータベース内の異なるオフセットにあるリンクのセットで表すことができます。
これらの句を使うことで、データベースはクエリをより速く効率的に実行し、
要求されたコンテンツだけを処理して返すことができる。

>**Did you know?**  
`LIMIT`と`OFFSET`がいつクエリの他の部分と相対的に適用されるのか気になる方は、
一般的に他の句が適用された後に最後に適用されます。
これについては、[Lesson 12: 実行順序](https://sqlbolt.com/lesson/select_queries_order_of_execution)で、
もう少しクエリの部分を紹介した後に触れることにします。

## 練習問題

このレッスンにはいくつかのコンセプトがありますが、
どれも適用するのはとても簡単です。
練習問題では、実際にどのようなデータを見ることができるかをよりよく模倣するために、
**Movies**テーブルをスクランブルしてみました。
上記で紹介した必要なキーワードと句をクエリに使ってみてください。

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

  1. 
  2. 
  3. 
  4. 
  5. 
  ```psql
  ```
  ```psql
  ```
  ```psql
  ```
  ```psql
  ```
  ```psql
  ```
</details>

<details>
  <summary>解答例</summary>

  1. 
  2. 
  3. 
  4. 
  5. 
  ```psql
  ```
  ```psql
  ```
  ```psql
  ```
  ```psql
  ```
  ```psql
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