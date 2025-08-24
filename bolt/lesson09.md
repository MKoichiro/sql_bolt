# [SQL Lesson 9: Queries with expressions](https://sqlbolt.com/lesson/select_queries_with_expressions)

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

  CREATE TABLE boxoffice (
    movie_id            INTEGER      PRIMARY KEY,
    rating              NUMERIC(3,1) NOT NULL,
    domestic_sales      INTEGER      NOT NULL,
    international_sales INTEGER      NOT NULL,
    CONSTRAINT fk_movie
      FOREIGN KEY (movie_id)
      REFERENCES movies(id)
  );

  INSERT INTO boxoffice (movie_id, rating, domestic_sales, international_sales)
  VALUES
  (5,  8.2, 380843261, 555900000),
  (14, 7.4, 268492764, 475066843),
  (8,  8.0, 206445654, 417277164),
  (12, 6.4, 191452396, 368400000),
  (3,  7.9, 245852179, 239163000),
  (6,  8.0, 261441092, 370001000),
  (9,  8.5, 223808164, 297503696),
  (11, 8.4, 415004880, 648167031),
  (1,  8.3, 191796233, 170162503),
  (7,  7.2, 244082982, 217900167),
  (10, 8.3, 293004164, 438338580),
  (4,  8.1, 289916256, 272900000),
  (2,  7.2, 162798565, 200600000),
  (13, 7.2, 237283207, 301700000);
  ```

  または以下を実行:

  ```psql
    \i /home/postgres/dataset/sqlbolt/movies-boxoffice.sql
  ```
</details>

## 訳文

SQLによる生のカラム・データの照会と参照に加えて、_expression_を使用して、
クエリ内のカラム値に対してより複雑なロジックを記述することもできます。
これらの式は、基本的な算術演算とともに数学関数や文字列関数を使用し、
クエリの実行時に値を変換することができます。

式を使ったクエリの例:

```SQL
  SELECT particle_speed / 2.0 AS half_particle_speed
  FROM physics_data
  WHERE ABS(particle_position) * 10.0 > 500;
```

それぞれのデータベースは、
クエリで使用できる
数学関数、
文字列関数、
日付関数
をサポートしており、
それぞれ公式ドキュメントで詳細を確認できます。

式を使用することで、
結果データの後処理にかかる時間を短縮することができますが、
クエリが読みづらくなる可能性もあります。
特に`SELECT`文の部分では、カラム名が整形した値を適切に表現するように、
`AS`ステートメントで別名を設定することをお勧めします。

式のエイリアスを使用したセレクトクエリ:

```SQL
  SELECT col_expression AS expr_description, ...
  FROM mytable;
```

式によって意味が変わらない場合でも、
カラム、またテーブルも、エイリアスを持つことができ、
出力での参照を容易にしたり、
より複雑なクエリを単純化したりすることができます。

カラム名とテーブル名のエイリアスを使用したクエリの例です:

```SQL
  SELECT a_long_and_complex_column_name AS better_column_name, ...
  FROM a_long_widgets_table_name AS mywidgets
  INNER JOIN widget_sales
    ON mywidgets.id = widget_sales.widget_id;
```

## 練習問題

以下のタスクでは、式を使用して **BoxOffice** データをわかりやすく変換します。

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

| movie_id | rating | domestic_sales | international_sales |
| -------- | ------ | -------------- | ------------------- |
| 5        | 8.2    | 380843261      | 555900000           |
| 14       | 7.4    | 268492764      | 475066843           |
| 8        | 8      | 206445654      | 417277164           |
| 12       | 6.4    | 191452396      | 368400000           |
| 3        | 7.9    | 245852179      | 239163000           |
| 6        | 8      | 261441092      | 370001000           |
| 9        | 8.5    | 223808164      | 297503696           |
| 11       | 8.4    | 415004880      | 648167031           |
| 1        | 8.3    | 191796233      | 170162503           |
| 7        | 7.2    | 244082982      | 217900167           |
| 10       | 8.3    | 293004164      | 438338580           |
| 4        | 8.1    | 289916256      | 272900000           |
| 2        | 7.2    | 162798565      | 200600000           |
| 13       | 7.2    | 237283207      | 301700000           |

1. List all movies and their combined sales in millions of dollars
2. List all movies and their ratings in percent
3. List all movies that were released on even number years

<details>
  <summary>解答の期待値</summary>

  1. 
  2. 
  3. 
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
  ```psql
  ```
  ```psql
  ```
  ```psql
  ```
</details>

<details>
  <summary>原文</summary>

  In addition to querying and referencing raw column data with SQL, you can also use _expressions_ to write more complex logic on column values in a query. These expressions can use mathematical and string functions along with basic arithmetic to transform values when the query is executed, as shown in this physics example.

  Example query with expressions:

  ```SQL
    SELECT particle_speed / 2.0 AS half_particle_speed
    FROM physics_data
    WHERE ABS(particle_position) * 10.0 > 500;
  ```

  Each database has its own supported set of mathematical, string, and date functions that can be used in a query, which you can find in their own respective docs.

  The use of expressions can save time and extra post-processing of the result data, but can also make the query harder to read, so we recommend that when expressions are used in the `SELECT` part of the query, that they are also given a descriptive _alias_ using the `AS` keyword.

  Select query with expression aliases:

  ```SQL
    SELECT col_expression_ AS expr_description, …
    FROM mytable;
  ```

  In addition to expressions, regular columns and even tables can also have aliases to make them easier to reference in the output and as a part of simplifying more complex queries.

  Example query with both column and table name aliases:

  ```SQL
    SELECT column AS better_column_name, …
    FROM a_long_widgets_table_name AS mywidgets
    INNER JOIN widget_sales
      ON mywidgets.id = widget_sales.widget_id;
  ```

  ## Exercise

  You are going to have to use expressions to transform the **BoxOffice** data into something easier to understand for the tasks below.

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

  | movie_id | rating | domestic_sales | international_sales |
  | -------- | ------ | -------------- | ------------------- |
  | 5        | 8.2    | 380843261      | 555900000           |
  | 14       | 7.4    | 268492764      | 475066843           |
  | 8        | 8      | 206445654      | 417277164           |
  | 12       | 6.4    | 191452396      | 368400000           |
  | 3        | 7.9    | 245852179      | 239163000           |
  | 6        | 8      | 261441092      | 370001000           |
  | 9        | 8.5    | 223808164      | 297503696           |
  | 11       | 8.4    | 415004880      | 648167031           |
  | 1        | 8.3    | 191796233      | 170162503           |
  | 7        | 7.2    | 244082982      | 217900167           |
  | 10       | 8.3    | 293004164      | 438338580           |
  | 4        | 8.1    | 289916256      | 272900000           |
  | 2        | 7.2    | 162798565      | 200600000           |
  | 13       | 7.2    | 237283207      | 301700000           |
</details>
