# [SQL Lesson 6: Multi-table queries with JOINs](https://sqlbolt.com/lesson/select_queries_with_joins)

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

ここまでは１つのテーブルを扱ってきましたが、
現実世界ではエンティティデータは、
[正規化](http://en.wikipedia.org/wiki/Database_normalization)
と呼ばれる処理によって、
複数の直交するテーブルに分割されて格納されることがよくあります。

## データベースの正規化

データベースが正規化されていると、
１つのテーブル内の重複データを最小化され、
データは互いに独立に累積することができます。
（例えば、自動車テーブルにひとまとめにするのではなく、
エンジンに対しては別途エンジンテーブルを用意すれば、
エンジンの種類が、自動車の（名前の）種類とは
独立して追加することができるようになります）。
トレードオフとして、クエリは若干複雑になります。

正規化データベースの複数のテーブルにまたがるデータを持つエンティティにを扱うには、
複数テーブルのデータを一度結合してから、
必要な情報を正確に引き出すようなクエリを書く必要があります。

１つのエンティティに関する情報を共有するテーブルには、
データベース全体でそのエンティティを一意に識別する主キーが必要です。
なお、一般的な主キーの型は（メモリ効率がよいので）自動インクリメントの整数ですが、
一意であれば文字列やハッシュ値でもかまいません。

クエリの `JOIN` 句を使うと、
この一意なキーを使って２つの別々のテーブルの行データを結合することができます。
最初に紹介する結合は `INNER JOIN` です。

`INNER JOIN` でのテーブル結合処理を含む `SELECT` クエリ:

```SQL
  SELECT column, another_table_column, ...
  FROM mytable
  INNER JOIN another_table
    ON mytable.id = another_table.id
  WHERE condition(s)
  ORDER BY column, ... ASC/DESC
  LIMIT num_limit OFFSET num_offset;
```

`INNER JOIN` は、
(`ON` 条件で定義された)同じキーを持つ最初のテーブルと２番目のテーブルの行をマッチさせ、
両方のテーブルのカラムを結合した結果の行集合を作成する処理です。
テーブルが結合された後、以前に学んだ他の句が適用されます。

>**Did you know?**  
`INNER JOIN` が単に `JOIN` と書かれているクエリを見かけることがあります。
この2つは同じ意味ですが、次のレッスンで紹介する他のタイプの結合を使い始めると、
クエリが読みやすくなるので、このような結合は内部結合と呼ぶことにします。

## 練習問題

ピクサーのデータベースに新しいテーブルを追加しました。
このテーブルの _Movie_id_ カラムは、
**Movies** テーブルの_Id_カラムと1対1で対応します。
上で紹介した `INNER JOIN` を使って、以下のタスクを解いてみてください。

>追記１  
テーブル名は最初が **movies**、２つ目が **boxoffice** です。
なお、"box office" は映画の文脈で「興行収入」の意味です。

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

1. Find the domestic and international sales for each movie
2. Show the sales numbers for each movie that did better internationally rather than domestically
3. List all the movies by their ratings in descending order

<details>
  <summary>解答の期待値</summary>

  1. Find the domestic and international sales for each movie
  ```psql
            title        | domestic_sales | international_sales
    ---------------------+----------------+---------------------
     Finding Nemo        |      380843261 |           555900000
     Monsters University |      268492764 |           475066843
     Ratatouille         |      206445654 |           417277164
     Cars 2              |      191452396 |           368400000
     Toy Story 2         |      245852179 |           239163000
     The Incredibles     |      261441092 |           370001000
     WALL-E              |      223808164 |           297503696
     Toy Story 3         |      415004880 |           648167031
     Toy Story           |      191796233 |           170162503
     Cars                |      244082982 |           217900167
     Up                  |      293004164 |           438338580
     Monsters, Inc.      |      289916256 |           272900000
     A Bug's Life        |      162798565 |           200600000
     Brave               |      237283207 |           301700000
  ```
  2. Show the sales numbers for each movie that did better internationally rather than domestically
  ```psql
            title        | domestic_sales | international_sales
    ---------------------+----------------+---------------------
     Finding Nemo        |      380843261 |           555900000
     Monsters University |      268492764 |           475066843
     Ratatouille         |      206445654 |           417277164
     Cars 2              |      191452396 |           368400000
     The Incredibles     |      261441092 |           370001000
     WALL-E              |      223808164 |           297503696
     Toy Story 3         |      415004880 |           648167031
     Up                  |      293004164 |           438338580
     A Bug's Life        |      162798565 |           200600000
     Brave               |      237283207 |           301700000
  ```
  3. List all the movies by their ratings in descending order
  ```psql
            title        | rating
    ---------------------+--------
     WALL-E              |    8.5
     Toy Story 3         |    8.4
     Up                  |    8.3
     Toy Story           |    8.3
     Finding Nemo        |    8.2
     Monsters, Inc.      |    8.1
     The Incredibles     |    8.0
     Ratatouille         |    8.0
     Toy Story 2         |    7.9
     Monsters University |    7.4
     Brave               |    7.2
     Cars                |    7.2
     A Bug's Life        |    7.2
     Cars 2              |    6.4
  ```
</details>

<details>
  <summary>解答例</summary>

  1. Find the domestic and international sales for each movie
  ```sql
    SELECT title, domestic_sales, international_sales
    FROM movies INNER JOIN boxoffice ON movies.id = boxoffice.movie_id;
  ```
  2. Show the sales numbers for each movie that did better internationally rather than domestically
  ```sql
    SELECT title, domestic_sales, international_sales
    FROM movies INNER JOIN boxoffice ON movies.id = boxoffice.movie_id
    WHERE international_sales > domestic_sales;
  ```
  3. List all the movies by their ratings in descending order
  ```sql
    SELECT title, rating
    FROM movies INNER JOIN boxoffice ON movies.id = boxoffice.movie_id
    ORDER BY rating DESC;
  ```
</details>

<details>
  <summary>原文</summary>

Up to now, we've been working with a single table, but entity data in the real world is often broken down into pieces and stored across multiple orthogonal tables using a process known as [normalization](http://en.wikipedia.org/wiki/Database_normalization).

## Database normalization

Database normalization is useful because it minimizes duplicate data in any single table, and allows for data in the database to grow independently of each other (ie. Types of car engines can grow independent of each type of car). As a trade-off, queries get slightly more complex since they have to be able to find data from different parts of the database, and performance issues can arise when working with many large tables.

In order to answer questions about an entity that has data spanning multiple tables in a normalized database, we need to learn how to write a query that can combine all that data and pull out exactly the information we need.

Tables that share information about a single entity need to have a _primary key_ that identifies that entity _uniquely_ across the database. One common primary key type is an auto-incrementing integer (because they are space efficient), but it can also be a string, hashed value, so long as it is unique.

Using the `JOIN` clause in a query, we can combine row data across two separate tables using this unique key. The first of the joins that we will introduce is the `INNER JOIN`.

Select query with INNER JOIN on multiple tables

```SQL
  SELECT column, another_table_column, …
  FROM mytable
  INNER JOIN another_table
    ON mytable.id = another_table.id
  WHERE condition(s)
  ORDER BY column, … ASC/DESC
  LIMIT num_limit OFFSET num_offset;
```

The `INNER JOIN` is a process that matches rows from the first table and the second table which have the same key (as defined by the `ON` constraint) to create a result row with the combined columns from both tables. After the tables are joined, the other clauses we learned previously are then applied.

>**Did you know?**  
You might see queries where the `INNER JOIN` is written simply as a `JOIN`. These two are equivalent, but we will continue to refer to these joins as inner-joins because they make the query easier to read once you start using other types of joins, which will be introduced in the following lesson.

## Exercise

We've added a new table to the Pixar database so that you can try practicing some joins. The **BoxOffice** table stores information about the ratings and sales of each particular Pixar movie, and the _Movie\_id_ column in that table corresponds with the _Id_ column in the **Movies** table 1-to-1. Try and solve the tasks below using the `INNER JOIN` introduced above.

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
