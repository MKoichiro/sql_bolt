# [SQL Lesson 12: Order of execution of a Query](https://sqlbolt.com/lesson/select_queries_order_of_execution)

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

```psql
  \i /home/postgres/dataset/sqlbolt/movies-boxoffice.sql
```

## 本文

さて、クエリのすべての部分について理解したところで、
次にそれらが完全なクエリという文脈の中でどのように組み合わされるのかについて説明します。

完全な`SELECT`クエリ:

```SQL
  SELECT DISTINCT column, AGG_FUNC(column_or_expression), ...
  FROM mytable
  JOIN another_table
    ON mytable.column = another_table.column
  WHERE constraint_expression
  GROUP BY column
  HAVING constraint_expression
  ORDER BY column ASC/DESC
  LIMIT count OFFSET COUNT;
```

それぞれのクエリは、データベースから必要なデータを探し出し、
そのデータを可能な限り素早く処理し理解できるようにフィルタリングすることから始まります。
クエリの各部分は順番に実行されるため、実行順序を理解することが重要である。

## クエリの実行順

### 1. `FROM` と `JOIN`s

最初に `FROM` 節とそれに続く `JOIN` 節が実行され、
クエリを実行するデータセットの合計が決定されます。
この節にはサブクエリも含まれ、
結合されるテーブルのすべての列と行を含む一時テーブルが作成される可能性がある。

### 2. `WHERE`

データの作業セットが揃うと、
ファーストパスの `WHERE` 制約が個々の行に適用され、
制約を満たさない行は破棄されます。
各制約は、`FROM`句で要求されたテーブルから直接列にアクセスすることしかできません。
問い合わせの `SELECT` 部分のエイリアスには、
まだ実行されていない問い合わせの一部に依存する式が含まれている可能性があるため、
ほとんどのデータベースではアクセスできません。

### 3. `GROUP BY`

`WHERE`制約が適用された後の残りの行は、
`GROUP BY`句で指定されたカラムの共通の値に基づいてグループ化されます。
グループ化の結果、その列の一意な値の数だけ行が存在することになります。
暗黙のうちに、これはクエリに集計関数がある場合にのみ使用する必要があることを意味します。

### 4. `HAVING`

クエリに `GROUP BY` 節がある場合、
`HAVING` 節の制約がグループ化された行に適用され、
制約を満たさないグループ化された行は破棄されます。
`WHERE`句と同様に、
エイリアスもほとんどのデータベースではこのステップからアクセスできません。

### 5. `SELECT`

クエリの `SELECT` 部分に含まれるすべての式が最終的に計算される。

### 6. `DISTINCT`

残りの行のうち、`DISTINCT`とマークされた列の値が重複している行は破棄される。

### 7. `ORDER BY`

`ORDER BY` 節で順序を指定すると、
行は指定されたデータで昇順または降順にソートされる。
クエリの `SELECT` 部分の式はすべて計算されているので、
この句でエイリアスを参照することができます。

### 8. `LIMIT` / `OFFSET`

最後に、 `LIMIT` と `OFFSET` で指定された範囲外の行は破棄され、
クエリから返される最終的な行のセットが残ります。

## まとめ

しかし、SQLが非常に柔軟である理由の1つは、
開発者やデータアナリストが追加のコードを書くことなく、
上記の句を使用するだけでデータを素早く操作できることです。

## 練習問題

ここまでで`SELECT`クエリについてのレッスンは終了です！
この演習では、あなたのクエリに対する理解度を試します。
ベストを尽くしてください。

1. Find the number of movies each director has directed
2. Find the total domestic and international sales that can be attributed to each director

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

## 原文

Now that we have an idea of all the parts of a query, we can now talk about how they all fit together in the context of a complete query.

Complete SELECT query:

```SQL
  SELECT DISTINCT column, AGG_FUNC(column_or_expression), …
  FROM mytable
  JOIN another_table
    ON mytable.column = another_table.column
  WHERE constraint_expression
  GROUP BY column
  HAVING constraint_expression
  ORDER BY column ASC/DESC
  LIMIT count OFFSET COUNT;
```

Each query begins with finding the data that we need in a database, and then filtering that data down into something that can be processed and understood as quickly as possible. Because each part of the query is executed sequentially, it's important to understand the order of execution so that you know what results are accessible where.

## Query order of execution

### 1. `FROM` and `JOIN`s

The `FROM` clause, and subsequent `JOIN`s are first executed to determine the total working set of data that is being queried. This includes subqueries in this clause, and can cause temporary tables to be created under the hood containing all the columns and rows of the tables being joined.

### 2. `WHERE`

Once we have the total working set of data, the first-pass `WHERE` constraints are applied to the individual rows, and rows that do not satisfy the constraint are discarded. Each of the constraints can only access columns directly from the tables requested in the `FROM` clause. Aliases in the `SELECT` part of the query are not accessible in most databases since they may include expressions dependent on parts of the query that have not yet executed.

### 3. `GROUP BY`

The remaining rows after the `WHERE` constraints are applied are then grouped based on common values in the column specified in the `GROUP BY` clause. As a result of the grouping, there will only be as many rows as there are unique values in that column. Implicitly, this means that you should only need to use this when you have aggregate functions in your query.

### 4. `HAVING`

If the query has a `GROUP BY` clause, then the constraints in the `HAVING` clause are then applied to the grouped rows, discard the grouped rows that don't satisfy the constraint. Like the `WHERE` clause, aliases are also not accessible from this step in most databases.

### 5. `SELECT`

Any expressions in the `SELECT` part of the query are finally computed.

### 6. `DISTINCT`

Of the remaining rows, rows with duplicate values in the column marked as `DISTINCT` will be discarded.

### 7. `ORDER BY`

If an order is specified by the `ORDER BY` clause, the rows are then sorted by the specified data in either ascending or descending order. Since all the expressions in the `SELECT` part of the query have been computed, you can reference aliases in this clause.

### 8. `LIMIT` / `OFFSET`

Finally, the rows that fall outside the range specified by the `LIMIT` and `OFFSET` are discarded, leaving the final set of rows to be returned from the query.

## Conclusion

Not every query needs to have all the parts we listed above, but a part of why SQL is so flexible is that it allows developers and data analysts to quickly manipulate data without having to write additional code, all just by using the above clauses.

## Exercise

Here ends our lessons on `SELECT` queries, congrats of making it this far! This exercise will try and test your understanding of queries, so don't be discouraged if you find them challenging. Just try your best.

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
