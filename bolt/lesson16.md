# [SQL Lesson 16: Creating tables](https://sqlbolt.com/lesson/creating_tables)

## 訳文

1. 

<details>
  <summary>原文</summary>

When you have new entities and relationships to store in your database, you can create a new database table using the `CREATE TABLE` statement.

Create table statement w/ optional table constraint and default value

`CREATE TABLE IF NOT EXISTS mytable ( column _DataType_ _TableConstraint_ DEFAULT _default_value_, another_column _DataType_ _TableConstraint_ DEFAULT _default_value_, … );`

The structure of the new table is defined by its _table schema_, which defines a series of columns. Each column has a name, the type of data allowed in that column, an _optional_ table constraint on values being inserted, and an optional default value.

If there already exists a table with the same name, the SQL implementation will usually throw an error, so to suppress the error and skip creating a table if one exists, you can use the `IF NOT EXISTS` clause.

## Table data types

Different databases support different data types, but the common types support numeric, string, and other miscellaneous things like dates, booleans, or even binary data. Here are some examples that you might use in real code.

<table><tbody><tr><td>Data type</td><td>Description</td></tr><tr><td><code>INTEGER</code>, <code>BOOLEAN</code></td><td>The integer datatypes can store whole integer values like the count of a number or an age. In some implementations, the boolean value is just represented as an integer value of just 0 or 1.</td></tr><tr><td><code>FLOAT</code>, <code>DOUBLE</code>, <code>REAL</code></td><td>The floating point datatypes can store more precise numerical data like measurements or fractional values. Different types can be used depending on the floating point precision required for that value.</td></tr><tr><td><code>CHARACTER(num_chars)</code>, <code>VARCHAR(num_chars)</code>, <code>TEXT</code></td><td><p>The text based datatypes can store strings and text in all sorts of locales. The distinction between the various types generally amount to underlaying efficiency of the database when working with these columns.</p><p>Both the CHARACTER and VARCHAR (variable character) types are specified with the max number of characters that they can store (longer values may be truncated), so can be more efficient to store and query with big tables.</p></td></tr><tr><td><code>DATE</code>, <code>DATETIME</code></td><td>SQL can also store date and time stamps to keep track of time series and event data. They can be tricky to work with especially when manipulating data across timezones.</td></tr><tr><td><code>BLOB</code></td><td>Finally, SQL can store binary data in blobs right in the database. These values are often opaque to the database, so you usually have to store them with the right metadata to requery them.</td></tr><tr><td colspan="2">Docs: <a href="http://dev.mysql.com/doc/refman/5.6/en/data-types.html" title="MySQL Data Types">MySQL</a>, <a href="http://www.postgresql.org/docs/9.4/static/datatype.html" title="Postgres Data Types">Postgres</a>, <a href="https://www.sqlite.org/datatype3.html" title="SQLite Data Types">SQLite</a>, <a href="https://msdn.microsoft.com/en-us/library/ms187752.aspx" title="Microsoft SQL Server Data Types">Microsoft SQL Server</a></td></tr></tbody></table>

## Table constraints

We aren't going to dive too deep into table constraints in this lesson, but each column can have additional table constraints on it which limit what values can be inserted into that column. This is not a comprehensive list, but will show a few common constraints that you might find useful.

<table><tbody><tr><td>Constraint</td><td>Description</td></tr><tr><td><code>PRIMARY KEY</code></td><td>This means that the values in this column are unique, and each value can be used to identify a single row in this table.</td></tr><tr><td><code>AUTOINCREMENT</code></td><td>For integer values, this means that the value is automatically filled in and incremented with each row insertion. Not supported in all databases.</td></tr><tr><td><code>UNIQUE</code></td><td>This means that the values in this column have to be unique, so you can't insert another row with the same value in this column as another row in the table. Differs from the `PRIMARY KEY` in that it doesn't have to be a key for a row in the table.</td></tr><tr><td><code>NOT NULL</code></td><td>This means that the inserted value can not be `NULL`.</td></tr><tr><td><code>CHECK (expression)</code></td><td>This allows you to run a more complex expression to test whether the values inserted are valid. For example, you can check that values are positive, or greater than a specific size, or start with a certain prefix, etc.</td></tr><tr><td><code>FOREIGN KEY</code></td><td>This is a consistency check which ensures that each value in this column corresponds to another value in a column in another table.<p>For example, if there are two tables, one listing all Employees by ID, and another listing their payroll information, the `FOREIGN KEY` can ensure that every row in the payroll table corresponds to a valid employee in the master Employee list.</p></td></tr></tbody></table>

## An example

Here's an example schema for the _Movies_ table that we've been using in the lessons up to now.

Movies table schema

`CREATE TABLE movies ( id INTEGER PRIMARY KEY, title TEXT, director TEXT, year INTEGER, length_minutes INTEGER );`

## Exercise

In this exercise, you'll need to create a new table for us to insert some new rows into.
