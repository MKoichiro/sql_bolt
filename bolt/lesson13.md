# [SQL Lesson 13: Inserting rows](https://sqlbolt.com/lesson/inserting_rows)

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
(3,  'Toy Story 2',         'John Lasseter',  1999, 93);

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
(3,  7.9, 245852179, 239163000),
(1,  8.3, 191796233, 170162503),
(2,  7.2, 162798565, 200600000);
```

```psql
  \i /home/postgres/dataset/sqlbolt/incomplete-movies-boxoffice.sql
```

## 本文

データベースのデータを照会する方法について、
かなり多くのレッスンを費やしてきましたので、
そろそろSQLスキーマと新しいデータを追加する方法について少し学び始めましょう。

## スキーマとは？

以前、データベースのテーブルは行と列の2次元の集合であり、
列はプロパティ、行はテーブル内のエンティティのインスタンスであると説明しました。
SQLでは、各テーブルの構造と、テーブルの各カラムが含むことのできるデータ型を記述したものが
*データベース・スキーマ*です。

> **例: 相関サブクエリ**  
> 例えば、**Movies**テーブルでは、
> *Year*カラムの値は`Integer`でなければならず、
> *Title*カラムの値は`String`でなければなりません。

このような固定的な構造が、何百万、何十億という行を格納するにもかかわらず、
データベースを効率的で一貫性のあるものにしているのです。

## 新しいデータの挿入

このステートメントでは、
どのテーブルに書き込むか、
どのカラムにデータを入れるか、
そして1行以上のデータを挿入するかを宣言します。
一般的に、挿入するデータの各行には、
テーブルの対応するすべての列の値を含める必要があります。
一度に複数の行を挿入するには、行を順番に並べればよい。

すべてのカラムの値を含む挿入文:

```SQL
  INSERT INTO mytable
  VALUES  (value_or_expr, another_value_or_expr, ...)、
          (value_or_expr_2, another_value_or_expr_2, ...)、
          ...;
```

場合によっては、不完全なデータがあり、
テーブルにデフォルト値をサポートするカラムが含まれている場合、
それらを明示的に指定することで、
データのあるカラムのみで行を挿入することができます。

特定のカラムを指定した挿入文:

```SQL
  INSERT INTO mytable (column, another_column, ...)
  VALUES  (value_or_expr, another_value_or_expr, ...)、
          (value_or_expr_2, another_value_or_expr_2, ...)、
          ...;
```

これらの場合、値の数は指定された列の数と一致する必要がある。
より冗長な記述になりますが、この方法で値を挿入すると、
前方互換性があるという利点があります。
例えば、デフォルト値を持つ新しいカラムをテーブルに追加する場合、
ハードコードされた `INSERT` ステートメントを変更する必要はありません。

さらに、挿入する値に数式や文字列式を使用することができます。
これは、挿入されるすべてのデータが特定の方法でフォーマットされることを保証するのに便利です。

式を使った挿入文の例:

```SQL
  INSERT INTO boxoffice (movie_id, rating, sales_in_millions)
  VALUES (1, 9.9, 283742034 / 1000000);
```

## 練習問題

この演習では、スタジオの重役を演じ、
**Movies**にいくつかの映画をポートフォリオに追加します。
このテーブルでは、**Id**は自動インクリメントの整数なので、
他のカラムだけを定義して行を挿入してみてください。

以下のレッスンではデータベースを変更するので、
準備ができたら各クエリを手動で実行する必要があります。

1. Add the studio's new production, Toy Story 4 to the list of movies (you can use any director)
2. Toy Story 4 has been released to critical acclaim! It had a rating of 8.7, and made 340 million domestically and 270 million internationally. Add the record to the BoxOffice table.

| id  | title               | director       | year | length_minutes |
| --- | ------------------- | -------------- | ---- | -------------- |
| 1   | Toy Story           | John Lasseter  | 1995 | 81             |
| 2   | A Bug's Life        | John Lasseter  | 1998 | 95             |
| 3   | Toy Story 2         | John Lasseter  | 1999 | 93             |

| movie_id | rating | domestic_sales | international_sales |
| -------- | ------ | -------------- | ------------------- |
| 3        | 7.9    | 245852179      | 239163000           |
| 1        | 8.3    | 191796233      | 170162503           |
| 2        | 7.2    | 162798565      | 200600000           |

## 原文

We've spent quite a few lessons on how to query for data in a database, so it's time to start learning a bit about SQL schemas and how to add new data.

## What is a Schema?

We previously described a table in a database as a two-dimensional set of rows and columns, with the columns being the properties and the rows being instances of the entity in the table. In SQL, the *database schema* is what describes the structure of each table, and the datatypes that each column of the table can contain.

Example: Correlated subquery

For example, in our **Movies** table, the values in the *Year* column must be an Integer, and the values in the *Title* column must be a String.

This fixed structure is what allows a database to be efficient, and consistent despite storing millions or even billions of rows.

## Inserting new data

When inserting data into a database, we need to use an `INSERT` statement, which declares which table to write into, the columns of data that we are filling, and one or more rows of data to insert. In general, each row of data you insert should contain values for every corresponding column in the table. You can insert multiple rows at a time by just listing them sequentially.

Insert statement with values for all columns:

```SQL
  INSERT INTO mytable
  VALUES  (value_or_expr, another_value_or_expr, …),
          (value_or_expr_2, another_value_or_expr_2, …),
          …;
```

In some cases, if you have incomplete data and the table contains columns that support default values, you can insert rows with only the columns of data you have by specifying them explicitly.

Insert statement with specific columns:

```SQL
  INSERT INTO mytable (column, another_column, …)
  VALUES  (value_or_expr, another_value_or_expr, …),
          (value_or_expr_2, another_value_or_expr_2, …),
          …;
```

In these cases, the number of values need to match the number of columns specified. Despite this being a more verbose statement to write, inserting values this way has the benefit of being forward compatible. For example, if you add a new column to the table with a default value, no hardcoded `INSERT` statements will have to change as a result to accommodate that change.

In addition, you can use mathematical and string expressions with the values that you are inserting.  
This can be useful to ensure that all data inserted is formatted a certain way.

Example Insert statement with expressions:

```SQL
  INSERT INTO boxoffice (movie_id, rating, sales_in_millions)
  VALUES (1, 9.9, 283742034 / 1000000);
```

## Exercise

In this exercise, we are going to play studio executive and add a few movies to the **Movies** to our portfolio. In this table, the **Id** is an auto-incrementing integer, so you can try inserting a row with only the other columns defined.

Since the following lessons will modify the database, you'll have to manually run each query once they are ready to go.

| id  | title               | director       | year | length_minutes |
| --- | ------------------- | -------------- | ---- | -------------- |
| 1   | Toy Story           | John Lasseter  | 1995 | 81             |
| 2   | A Bug's Life        | John Lasseter  | 1998 | 95             |
| 3   | Toy Story 2         | John Lasseter  | 1999 | 93             |

| movie_id | rating | domestic_sales | international_sales |
| -------- | ------ | -------------- | ------------------- |
| 3        | 7.9    | 245852179      | 239163000           |
| 1        | 8.3    | 191796233      | 170162503           |
| 2        | 7.2    | 162798565      | 200600000           |
