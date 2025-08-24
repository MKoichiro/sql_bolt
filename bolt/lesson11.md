# [SQL Lesson 11: Queries with aggregates (Pt. 2)](https://sqlbolt.com/lesson/select_queries_with_aggregates_pt_2)

<details>
  <summary>課題の表を再現するseedコマンド:</summary>

  ```SQL
  DROP TABLE IF EXISTS employees

  CREATE TABLE employees (
    role           VARCHAR(50)  NOT NULL,
    name           VARCHAR(100) NOT NULL,
    building       VARCHAR(10)  NOT NULL,
    years_employed INTEGER      NOT NULL,
    CONSTRAINT fk_building
      FOREIGN KEY (building)
      REFERENCES  buildings(building_name)
  );

  INSERT INTO employees (role, name, building, years_employed)
  VALUES
  ('Engineer', 'Becky A.',   '1e', 4),
  ('Engineer', 'Dan B.',     '1e', 2),
  ('Engineer', 'Sharon F.',  '1e', 6),
  ('Engineer', 'Dan M.',     '1e', 4),
  ('Engineer', 'Malcom S.',  '1e', 1),
  ('Artist',   'Tylar S.',   '2w', 2),
  ('Artist',   'Sherman D.', '2w', 8),
  ('Artist',   'Jakob J.',   '2w', 6),
  ('Artist',   'Lillia A.',  '2w', 7),
  ('Artist',   'Brandon J.', '2w', 7),
  ('Manager',  'Scott K.',   '1e', 9),
  ('Manager',  'Shirlee M.', '1e', 3),
  ('Manager',  'Daria O.',   '2w', 6);
  ```

  または以下を実行:

  ```psql
    \i /home/postgres/dataset/sqlbolt/employees.sql
  ```
</details>

## 訳文

クエリはかなり複雑になってきましたが、
`SELECT`クエリの勘どころはおおむね紹介を終えました。
しかし、あと一つ気になる点があります。
`GROUP BY` 節は `WHERE` 節によるフィルタリング後に実行され、
その結果も複数行になり得ますが、
グループ化後の行はどのようにフィルタリングするのでしょうか？

幸いSQLにはこのような場合に使える`HAVING`句があります。
これにより、グループ化後の結果セットからフィルタリングできます。

`HAVING`制約付き`SELECT`クエリ:

```SQL
  SELECT group_by_column, AGG_FUNC(column_expression) AS aggregate_result_alias, ...
  FROM mytable
  WHERE condition
  GROUP BY column
  HAVING group_condition;
```

`HAVING`句は、`WHERE`句と同じように記述できますが、
グループ化後の行に適用されます。
この例では、これは特に便利な構成には見えないかもしれませんが、
異なるプロパティを持つ何百万もの行を持つデータを想像した場合、
追加の制約を適用できることは、データを素早く理解するためにしばしば必要になります。

>**Did you know?**  
`GROUP BY` 節を使用しない場合は、単純な `WHERE` 節で十分です。

## 練習問題

この演習では、映画スタジオの **employees** データを深く掘り下げていきます。
各タスクに適用したいさまざまな句を考えてください。

| role     | name       | building | years_employed |
| -------- | ---------- | -------- | -------------- |
| Engineer | Becky A.   | 1e       | 4              |
| Engineer | Dan B.     | 1e       | 2              |
| Engineer | Sharon F.  | 1e       | 6              |
| Engineer | Dan M.     | 1e       | 4              |
| Engineer | Malcom S.  | 1e       | 1              |
| Artist   | Tylar S.   | 2w       | 2              |
| Artist   | Sherman D. | 2w       | 8              |
| Artist   | Jakob J.   | 2w       | 6              |
| Artist   | Lillia A.  | 2w       | 7              |
| Artist   | Brandon J. | 2w       | 7              |
| Manager  | Scott K.   | 1e       | 9              |
| Manager  | Shirlee M. | 1e       | 3              |
| Manager  | Daria O.   | 2w       | 6              |

1. Find the number of Artists in the studio (without a HAVING clause)
2. Find the number of Employees of each role in the studio
3. Find the total number of years employed by all Engineers

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

  Our queries are getting fairly complex, but we have nearly introduced all the important parts of a `SELECT` query. One thing that you might have noticed is that if the `GROUP BY` clause is executed after the `WHERE` clause (which filters the rows which are to be grouped), then how exactly do we filter the grouped rows?

  Luckily, SQL allows us to do this by adding an additional `HAVING` clause which is used specifically with the `GROUP BY` clause to allow us to filter grouped rows from the result set.

  Select query with HAVING constraint

  ```SQL
    SELECT group_by_column, AGG_FUNC(column_expression) AS aggregate_result_alias, …
    FROM mytable
    WHERE condition
    GROUP BY column
    HAVING group_condition;
  ```

  The `HAVING` clause constraints are written the same way as the `WHERE` clause constraints, and are applied to the grouped rows. With our examples, this might not seem like a particularly useful construct, but if you imagine data with millions of rows with different properties, being able to apply additional constraints is often necessary to quickly make sense of the data.

  >**Did you know?**  
  If you aren't using the `GROUP BY` clause, a simple `WHERE` clause will suffice.

  ## Exercise

  For this exercise, you are going to dive deeper into **Employee** data at the film studio. Think about the different clauses you want to apply for each task.

  | role     | name       | building | years_employed |
  | -------- | ---------- | -------- | -------------- |
  | Engineer | Becky A.   | 1e       | 4              |
  | Engineer | Dan B.     | 1e       | 2              |
  | Engineer | Sharon F.  | 1e       | 6              |
  | Engineer | Dan M.     | 1e       | 4              |
  | Engineer | Malcom S.  | 1e       | 1              |
  | Artist   | Tylar S.   | 2w       | 2              |
  | Artist   | Sherman D. | 2w       | 8              |
  | Artist   | Jakob J.   | 2w       | 6              |
  | Artist   | Lillia A.  | 2w       | 7              |
  | Artist   | Brandon J. | 2w       | 7              |
  | Manager  | Scott K.   | 1e       | 9              |
  | Manager  | Shirlee M. | 1e       | 3              |
  | Manager  | Daria O.   | 2w       | 6              |
</details>
