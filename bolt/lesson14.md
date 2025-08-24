# [SQL Lesson 14: Updating rows](https://sqlbolt.com/lesson/updating_rows)

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
  (2,  'A Bug''s Life',       'El Directore',   1998, 95),
  (3,  'Toy Story 2',         'John Lasseter',  1899, 93),
  (4,  'Monsters, Inc.',      'Pete Docter',    2001, 92),
  (5,  'Finding Nemo',        'Andrew Stanton', 2003, 107),
  (6,  'The Incredibles',     'Brad Bird',      2004, 116),
  (7,  'Cars',                'John Lasseter',  2006, 117),
  (8,  'Ratatouille',         'Brad Bird',      2007, 115),
  (9,  'WALL-E',              'Andrew Stanton', 2008, 104),
  (10, 'Up',                  'Pete Docter',    2009, 101),
  (11, 'Toy Story 8',         'El Directore',   2010, 103),
  (12, 'Cars 2',              'John Lasseter',  2011, 120),
  (13, 'Brave',               'Brenda Chapman', 2012, 102),
  (14, 'Monsters University', 'Dan Scanlon',    2013, 110);
  ```

  または以下を実行:

  ```psql
    \i /home/postgres/dataset/sqlbolt/wrong-movies.sql
  ```
</details>

## 訳文

新しいデータを追加すること以外にも一般的な操作はあります。
ひとつには既存のデータを更新することです。
`INSERT`文と同様に、更新したいテーブル、カラム、行を正確に指定する必要があります。
さらに、更新後のデータも、テーブルスキーマのカラムのデータ型と一致していなければなりません。

値による更新ステートメント:

```SQL
  UPDATE mytable
  SET column = value_or_expr,
      other_column = another_value_or_expr,
      ...
  WHERE condition;
```

このステートメントは、複数のカラムと値のペアを受け取り、
その変更を `WHERE` 句の制約を満たす行それぞれに適用することで動作します。

## 注意

SQLを扱うほとんどの人は、データの更新で間違いを犯します。
本番環境のデータベースで間違った行を更新してしまったり、
誤って `WHERE` 句を抜けてしまったり（更新がすべての行に適用されてしまいます）、
`UPDATE` ステートメントを作成する際には特に注意が必要です。

失敗しないコツは、
常に最初に制約を記述し、`SELECT`クエリでそれをテストして、
正しい行を更新していることを確認してから、
更新する列と値のペアを記述することです。

## 練習問題

**Movies**データベースのいくつかの情報が間違っています。

| id  | title               | director       | year | length_minutes |
| --- | ------------------- | -------------- | ---- | -------------- |
| 1   | Toy Story           | John Lasseter  | 1995 | 81             |
| 2   | A Bug's Life        | El Directore   | 1998 | 95             |
| 3   | Toy Story 2         | John Lasseter  | 1899 | 93             |
| 4   | Monsters, Inc.      | Pete Docter    | 2001 | 92             |
| 5   | Finding Nemo        | Andrew Stanton | 2003 | 107            |
| 6   | The Incredibles     | Brad Bird      | 2004 | 116            |
| 7   | Cars                | John Lasseter  | 2006 | 117            |
| 8   | Ratatouille         | Brad Bird      | 2007 | 115            |
| 9   | WALL-E              | Andrew Stanton | 2008 | 104            |
| 10  | Up                  | Pete Docter    | 2009 | 101            |
| 11  | Toy Story 8         | El Directore   | 2010 | 103            |
| 12  | Cars 2              | John Lasseter  | 2011 | 120            |
| 13  | Brave               | Brenda Chapman | 2012 | 102            |
| 14  | Monsters University | Dan Scanlon    | 2013 | 110            |

1. The director for A Bug's Life is incorrect, it was actually directed by John Lasseter
2. The year that Toy Story 2 was released is incorrect, it was actually released in 1999
3. Both the title and director for Toy Story 8 is incorrect! The title should be "Toy Story 3" and it was directed by Lee Unkrich

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

  In addition to adding new data, a common task is to update existing data, which can be done using an `UPDATE` statement. Similar to the `INSERT` statement, you have to specify exactly which table, columns, and rows to update. In addition, the data you are updating has to match the data type of the columns in the table schema.

  Update statement with values:

  ```SQL
    UPDATE mytable
    SET column = value_or_expr,
        other_column = another_value_or_expr,
        …
    WHERE condition;
  ```

  The statement works by taking multiple column/value pairs, and applying those changes to each and every row that satisfies the constraint in the `WHERE` clause.

  ## Taking care

  Most people working with SQL **will** make mistakes updating data at one point or another. Whether it's updating the wrong set of rows in a production database, or accidentally leaving out the `WHERE` clause (which causes the update to apply to _all_ rows), you need to be extra careful when constructing `UPDATE` statements.

  One helpful tip is to always write the constraint first and test it in a `SELECT` query to make sure you are updating the right rows, and only then writing the column/value pairs to update.

  ## Exercise

  It looks like some of the information in our **Movies** database might be incorrect, so go ahead and fix them through the exercises below.

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
</details>
