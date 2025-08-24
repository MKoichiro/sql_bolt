# [SQL Lesson 1: SELECT queries 101](https://sqlbolt.com/lesson/select_queries_introduction)

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
```

```psql
  \i ~/dataset/sqlbolt/movies.sql
```

## 本文

SQLデータベースからデータを取り出すには、`SELECT`文を書く必要があります。
クエリ自体は、どのようなデータを探しているのか、データベースのどこにあるのか、
そしてオプションとして、データを返す前にどのように変換するのかを宣言する文に過ぎません。
しかし、クエリには特有の構文があり、それを以下のレッスンで学んで行きます。

冒頭で述べたように、SQLのテーブルをエンティティの型（例：犬）、
テーブルの各行をその型の特定のインスタンス（例：パグ、ビーグル、色違いのパグなど）と考えることができます。
つまり、列はそのエンティティのすべてのインスタンスに共通するプロパティ（毛の色、尻尾の長さなど）を表します。

そして、データのテーブルが与えられた場合、最も基本的なクエリは、
テーブルのすべての行（インスタンス）から、いくつかの列（プロパティ）を選択するものです。

特定のカラムを選択するクエリ:

```SQL
  SELECT column, another_column, ... FROM mytable;
```

このクエリの結果は、2次元の行と列のセットとなり、
事実上テーブルのコピーとなりますが、要求した列のみが含まれます。

テーブルから完全にすべての列のデータを取得したい場合は、
すべての列名を列挙する代わりに、アスタリスク (`*`) の省略記法を使用することができます。

全カラムの選択クエリ:

```SQL
  SELECT * FROM mytable;
```

このようなクエリはテーブル全体をガバっと取得できるので便利です。

## 練習問題

この演習では、ピクサーの名作映画に関するデータを含むデータベースを使用します。
この最初の演習では、**Movies**テーブルのみを使用し、
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

## 原文

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
