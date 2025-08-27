# [SQL Review: Simple SELECT Queries](https://sqlbolt.com/lesson/select_queries_review)

<details>
  <summary>課題の表を再現するseedコマンド:</summary>

  ```SQL
  DROP TABLE IF EXISTS north_american_cities;

  CREATE TABLE IF NOT EXISTS north_american_cities (
    id          SERIAL       PRIMARY KEY,
    city        VARCHAR(255) NOT NULL,
    country     VARCHAR(100) NOT NULL,
    population  INTEGER      NOT NULL CHECK (population > 0),
    latitude    DECIMAL(9,6) NOT NULL CHECK (latitude BETWEEN -90 AND 90),
    longitude   DECIMAL(9,6) NOT NULL CHECK (longitude BETWEEN -180 AND 180),
    UNIQUE (city, country)
  );

  INSERT INTO north_american_cities (city, country, population, latitude, longitude)
  VALUES
  ('Guadalajara', 'Mexico', 1500800, 20.659699, -103.349609),
  ('Toronto', 'Canada', 2795060, 43.653226, -79.383184),
  ('Houston', 'United States', 2195914, 29.760427, -95.369803),
  ('New York', 'United States', 8405837, 40.712784, -74.005941),
  ('Philadelphia', 'United States', 1553165, 39.952584, -75.165222),
  ('Havana', 'Cuba', 2106146, 23.054070, -82.345189),
  ('Mexico City', 'Mexico', 8555500, 19.432608, -99.133208),
  ('Phoenix', 'United States', 1513367, 33.448377, -112.074037),
  ('Los Angeles', 'United States', 3884307, 34.052234, -118.243685),
  ('Ecatepec de Morelos', 'Mexico', 1742000, 19.601841, -99.050674),
  ('Montreal', 'Canada', 1717767, 45.501689, -73.567256),
  ('Chicago', 'United States', 2718782, 41.878114, -87.629798);
  ```

  または以下を実行:

  ```psql
    \i /home/postgres/dataset/sqlbolt/north_american_cities.sql
  ```
</details>

## 訳文

ここまででひと区切りです！基本的なクエリの書き方を学んだところで、
より実践的なクエリを書く練習をしましょう。

`SELECT` クエリ:

```SQL
  SELECT column, another_column, ... FROM mytable WHERE condition(s) ORDER BY column ASC/DESC LIMIT num_limit OFFSET num_offset;
```

## 練習問題

以下の演習では、別のテーブルを扱います。
このテーブルには、
[北米で最も人口の多い都市](http://en.wikipedia.org/wiki/List_of_North_American_cities_by_population)
の人口や地理的な位置などの情報が含まれています。

>**Did you know?**  
北半球は正の緯度(latitude)、東半球は正の経度(longitude)です。
リストにある都市はすべて北アメリカです。
北アメリカは赤道より北、本初子午線より西にあるため、
すべて正の緯度と負の経度となっています。

以下のタスクにしたがってクエリを書いてみてください。
異なる句の組み合わせを使用する必要があるかもしれません。
なお、次のレッスンでは複数のテーブルにまたがるクエリについて学習します。

>追記１  
テーブル名は、**"north_american_cities"** です。

| city                | country       | population | latitude  | longitude   |
| ------------------- | ------------- | ---------- | --------- | ----------- |
| Guadalajara         | Mexico        | 1500800    | 20.659699 | -103.349609 |
| Toronto             | Canada        | 2795060    | 43.653226 | -79.383184  |
| Houston             | United States | 2195914    | 29.760427 | -95.369803  |
| New York            | United States | 8405837    | 40.712784 | -74.005941  |
| Philadelphia        | United States | 1553165    | 39.952584 | -75.165222  |
| Havana              | Cuba          | 2106146    | 23.05407  | -82.345189  |
| Mexico City         | Mexico        | 8555500    | 19.432608 | -99.133208  |
| Phoenix             | United States | 1513367    | 33.448377 | -112.074037 |
| Los Angeles         | United States | 3884307    | 34.052234 | -118.243685 |
| Ecatepec de Morelos | Mexico        | 1742000    | 19.601841 | -99.050674  |
| Montreal            | Canada        | 1717767    | 45.501689 | -73.567256  |
| Chicago             | United States | 2718782    | 41.878114 | -87.629798  |

1. List all the Canadian cities and their populations
2. Order all the cities in the United States by their latitude from north to south
3. List all the cities west of Chicago, ordered from west to east
>追記２  
この時点では、シカゴの経度は -87.629798 をそのまま使いましょう。
あとの lesson で**サブクエリ**を学習すると、このようなマジックナンバーは回避できます。
4. List the two largest cities in Mexico (by population)
5. List the third and fourth largest cities (by population) in the United States and their population

<details>
  <summary>解答の期待値</summary>

  1. List all the Canadian cities and their populations
  ```psql
      city   | population
    ----------+------------
     Toronto  |    2795060
     Montreal |    1717767
  ```
  2. Order all the cities in the United States by their latitude from north to south
  ```psql
     id |     city     |    country    | population | latitude  |  longitude
    ----+--------------+---------------+------------+-----------+-------------
     12 | Chicago      | United States |    2718782 | 41.878114 |  -87.629798
      4 | New York     | United States |    8405837 | 40.712784 |  -74.005941
      5 | Philadelphia | United States |    1553165 | 39.952584 |  -75.165222
      9 | Los Angeles  | United States |    3884307 | 34.052234 | -118.243685
      8 | Phoenix      | United States |    1513367 | 33.448377 | -112.074037
      3 | Houston      | United States |    2195914 | 29.760427 |  -95.369803
  ```
  3. List all the cities west of Chicago, ordered from west to east
  ```psql
     id |        city         |    country    | population | latitude  |  longitude
    ----+---------------------+---------------+------------+-----------+-------------
      9 | Los Angeles         | United States |    3884307 | 34.052234 | -118.243685
      8 | Phoenix             | United States |    1513367 | 33.448377 | -112.074037
      1 | Guadalajara         | Mexico        |    1500800 | 20.659699 | -103.349609
      7 | Mexico City         | Mexico        |    8555500 | 19.432608 |  -99.133208
     10 | Ecatepec de Morelos | Mexico        |    1742000 | 19.601841 |  -99.050674
      3 | Houston             | United States |    2195914 | 29.760427 |  -95.369803
  ```
  4. List the two largest cities in Mexico (by population)
  ```psql
     id |        city         | country | population | latitude  | longitude
    ----+---------------------+---------+------------+-----------+------------
      7 | Mexico City         | Mexico  |    8555500 | 19.432608 | -99.133208
     10 | Ecatepec de Morelos | Mexico  |    1742000 | 19.601841 | -99.050674
  ```
  5. List the third and fourth largest cities (by population) in the United States and their population
  ```psql
   id |  city   |    country    | population | latitude  | longitude
  ----+---------+---------------+------------+-----------+------------
   12 | Chicago | United States |    2718782 | 41.878114 | -87.629798
    3 | Houston | United States |    2195914 | 29.760427 | -95.369803
  ```
</details>

<details>
  <summary>解答例</summary>

  1. List all the Canadian cities and their populations
  ```sql
    SELECT city, population FROM north_american_cities WHERE country = 'Canada';
  ```
  2. Order all the cities in the United States by their latitude from north to south
  ```sql
    SELECT * FROM north_american_cities WHERE country = 'United States' ORDER BY latitude DESC;
  ```
  3. List all the cities west of Chicago, ordered from west to east
  ```sql
    SELECT * FROM north_american_cities WHERE longitude < -87.629798 ORDER BY longitude ASC;
  ```
  4. List the two largest cities in Mexico (by population)
  ```sql
    SELECT * FROM north_american_cities WHERE country = 'Mexico' ORDER BY population DESC LIMIT 2;
  ```
  5. List the third and fourth largest cities (by population) in the United States and their population
  ```sql
    SELECT * FROM north_american_cities WHERE country = 'United States' ORDER BY population DESC LIMIT 2 OFFSET 2;
  ```
</details>

<details>
  <summary>原文</summary>

  You've done a good job getting to this point! Now that you've gotten a taste of how to write a basic query, you need to practice writing queries that solve actual problems.

  SELECT query

  ```SQL
    SELECT column, another_column, … FROM mytable WHERE condition(s) ORDER BY column ASC/DESC LIMIT num_limit OFFSET num_offset;
  ```

  ## Exercise

  In the exercise below, you will be working with a different table. This table instead contains information about a few of [the most populous cities of North America](http://en.wikipedia.org/wiki/List_of_North_American_cities_by_population) including their population and geo-spatial location in the world.

  >**Did you know?**  
  Positive latitudes correspond to the northern hemisphere, and positive longitudes correspond to the eastern hemisphere. Since North America is north of the equator and west of the prime meridian, all of the cities in the list have positive latitudes and negative longitudes.

  Try and write some queries to find the information requested in the tasks below. You may have to use a different combination of clauses in your query for each task. Once you're done, continue onto the next lesson to learn about queries that span multiple tables.
</details>
