# [SQL Lesson 15: Deleting rows](https://sqlbolt.com/lesson/deleting_rows)

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

データベース内のテーブルからデータを削除する必要がある場合、
`DELETE`ステートメントを使用することができます。
このステートメントでは、`WHERE`句で削除するテーブルと行を指定します。

条件付きのDELETE文:

```SQL
  DELETE FROM mytable
  WHERE condition;
```

もし `WHERE` 制約を省略した場合、*すべての*行が削除されます。

## 特に注意すること

前回のレッスンの `UPDATE` ステートメントと同様に、
正しい行を削除していることを確認するために、
最初に `SELECT` クエリで制約を実行することをお勧めします。
適切なバックアップやテストデータベースがないと、
取り返しのつかない形でデータを削除してしまうことがあります。

## 練習問題

データベースを少し整理する必要があるので、以下のタスクでいくつかの行を削除してみましょう。

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

1. This database is getting too big, lets remove all movies that were released before 2005.
2. Andrew Stanton has also left the studio, so please remove all movies directed by him.

<details>
  <summary>解答の期待値</summary>

  1. 
  2. 
  ```psql
  ```
  ```psql
  ```
</details>

<details>
  <summary>解答例</summary>

  1. 
  2. 
  ```psql
  ```
  ```psql
  ```
</details>

<details>
  <summary>原文</summary>

  When you need to delete data from a table in the database, you can use a `DELETE` statement, which describes the table to act on, and the rows of the table to delete through the `WHERE` clause.

  Delete statement with condition:

  ```SQL
    DELETE FROM mytable
    WHERE condition;
  ```

  If you decide to leave out the `WHERE` constraint, then *all* rows are removed, which is a quick and easy way to clear out a table completely (if intentional).

  ## Taking extra care

  Like the `UPDATE` statement from last lesson, it's recommended that you run the constraint in a `SELECT` query first to ensure that you are removing the right rows. Without a proper backup or test database, it is downright easy to irrevocably remove data, so always read your `DELETE` statements twice and execute once.

  ## Exercise

  The database needs to be cleaned up a little bit, so try and delete a few rows in the tasks below.

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
