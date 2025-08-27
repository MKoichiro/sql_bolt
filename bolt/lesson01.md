# [SQL Lesson 1: SELECT queries 101](https://sqlbolt.com/lesson/select_queries_introduction)

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

SQL データベースからデータを取り出すには、`SELECT` 文を使います。
① どのようなデータを探しているのか、
② データベースのどこにあるのか、
またオプションとして、
③ データを返す前にどのように変換するのか、
クエリ自体はこれらを宣言しているに過ぎません。
しかし、クエリには特有の構文があるので、それらを以下のレッスンで学んで行きます。

イントロダクションで述べたように、SQL のテーブル＝エンティティ（例：犬）、
テーブルの各行＝特定のインスタンス（例：パグ、ビーグル、色違いのパグなど）
と考えることができます。
よっておのずと列は、そのエンティティのすべてのインスタンスに共通するプロパティ（毛の色、尻尾の長さなど）を表すことになります。

そして、データのテーブルが与えられた場合、最も基本的なクエリは、
テーブルの**すべての行（インスタンス）から、いくつかの列（プロパティ）を選択する**ものです。

特定のカラムを指定する `SELECT` クエリ:

```SQL
  SELECT column, another_column, ... FROM mytable;
```

このクエリの結果は、2次元の行列となり、
事実上テーブルのコピーとなりますが、要求した列のみが含まれます。

テーブル全体のデータを取得したい場合は、
すべての列名を列挙する代わりに、
アスタリスク (`*`) の省略記法が使用できます。

全カラムの `SELECT` クエリ:

```SQL
  SELECT * FROM mytable;
```

テーブル全体をガバっと取得するのに便利です。

## 練習問題

この演習では、ピクサーの名作映画に関するデータを含むデータベースを使用します。
この最初の演習では、**movies** テーブルのみを使用し、
以下のデフォルトクエリは現在、各映画のすべてのプロパティを表示します。
次のレッスンに進むには、クエリを変更して、各タスクに必要な情報を探します。

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

1. Find the title of each film
2. Find the director of each film
3. Find the title and director of each film
4. Find the title and year of each film
5. Find all the information about each film

<details>
  <summary>解答の期待値</summary>

  1. Find the title of each film
  ```psql
            title        
    ---------------------
     Toy Story
     A Bug's Life
     Toy Story 2
     Monsters, Inc.
     Finding Nemo
     The Incredibles
     Cars
     Ratatouille
     WALL-E
     Up
     Toy Story 3
     Cars 2
     Brave
     Monsters University
  ```
  2. Find the director of each film
  ```psql
        director    
    ----------------
     John Lasseter
     John Lasseter
     John Lasseter
     Pete Docter
     Andrew Stanton
     Brad Bird
     John Lasseter
     Brad Bird
     Andrew Stanton
     Pete Docter
     Lee Unkrich
     John Lasseter
     Brenda Chapman
     Dan Scanlon
  ```
  3. Find the title and director of each film
  ```psql
            title        |    director    
    ---------------------+----------------
     Toy Story           | John Lasseter
     A Bug's Life        | John Lasseter
     Toy Story 2         | John Lasseter
     Monsters, Inc.      | Pete Docter
     Finding Nemo        | Andrew Stanton
     The Incredibles     | Brad Bird
     Cars                | John Lasseter
     Ratatouille         | Brad Bird
     WALL-E              | Andrew Stanton
     Up                  | Pete Docter
     Toy Story 3         | Lee Unkrich
     Cars 2              | John Lasseter
     Brave               | Brenda Chapman
     Monsters University | Dan Scanlon
  ```
  4. Find the title and year of each film
  ```psql
            title        | year 
    ---------------------+------
     Toy Story           | 1995
     A Bug's Life        | 1998
     Toy Story 2         | 1999
     Monsters, Inc.      | 2001
     Finding Nemo        | 2003
     The Incredibles     | 2004
     Cars                | 2006
     Ratatouille         | 2007
     WALL-E              | 2008
     Up                  | 2009
     Toy Story 3         | 2010
     Cars 2              | 2011
     Brave               | 2012
     Monsters University | 2013
  ```
  5. Find all the information about each film
  ```psql
     id |        title        |    director    | year | length_minutes 
    ----+---------------------+----------------+------+----------------
      1 | Toy Story           | John Lasseter  | 1995 |             81
      2 | A Bug's Life        | John Lasseter  | 1998 |             95
      3 | Toy Story 2         | John Lasseter  | 1999 |             93
      4 | Monsters, Inc.      | Pete Docter    | 2001 |             92
      5 | Finding Nemo        | Andrew Stanton | 2003 |            107
      6 | The Incredibles     | Brad Bird      | 2004 |            116
      7 | Cars                | John Lasseter  | 2006 |            117
      8 | Ratatouille         | Brad Bird      | 2007 |            115
      9 | WALL-E              | Andrew Stanton | 2008 |            104
     10 | Up                  | Pete Docter    | 2009 |            101
     11 | Toy Story 3         | Lee Unkrich    | 2010 |            103
     12 | Cars 2              | John Lasseter  | 2011 |            120
     13 | Brave               | Brenda Chapman | 2012 |            102
     14 | Monsters University | Dan Scanlon    | 2013 |            110
  ```
</details>

<details>
  <summary>解答例</summary>

  1. Find the title of each film
  ```sql
    SELECT title FROM movies;
  ```
  2. Find the director of each film
  ```sql
    SELECT director FROM movies;
  ```
  3. Find the title and director of each film
  ```sql
    SELECT title, director FROM movies;
  ```
  4. Find the title and year of each film
  ```sql
    SELECT title, year FROM movies;
  ```
  5. Find all the information about each film
  ```sql
    SELECT * FROM movies;
  ```
</details>

<details>
  <summary>原文</summary>

  To retrieve data from a SQL database, we need to write `SELECT` statements, which are often colloquially refered to as _queries_. A query in itself is just a statement which declares what data we are looking for, where to find it in the database, and optionally, how to transform it before it is returned. It has a specific syntax though, which is what we are going to learn in the following exercises.

  As we mentioned in the introduction, you can think of a table in SQL as a type of an entity (ie. Dogs), and each row in that table as a specific _instance_ of that type (ie. A pug, a beagle, a different colored pug, etc). This means that the columns would then represent the common properties shared by all instances of that entity (ie. Color of fur, length of tail, etc).

  And given a table of data, the most basic query we could write would be one that selects for a couple columns (properties) of the table with all the rows (instances).

  Select query for a specific columns

  `SELECT column, another_column, … FROM mytable;`

  The result of this query will be a two-dimensional set of rows and columns, effectively a copy of the table, but only with the columns that we requested.

  If we want to retrieve absolutely all the columns of data from a table, we can then use the asterisk (`*`) shorthand in place of listing all the column names individually.

  Select query for all columns

  `SELECT * FROM mytable;`

  This query, in particular, is really useful because it's a simple way to inspect a table by dumping all the data at once.

  ## Exercise

  We will be using a database with data about some of Pixar's classic movies for most of our exercises. This first exercise will only involve the **Movies** table, and the default query below currently shows all the properties of each movie. To continue onto the next lesson, alter the query to find the exact information we need for each task.

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

  1. Find the title of each film
  2. Find the director of each film
  3. Find the title and director of each film
  4. Find the title and year of each film
  5. Find all the information about each film
