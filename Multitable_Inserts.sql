/*Multitable Inserts
Multitable inserts were introduced in Oracle 9i to allow a single INSERT INTO .. SELECT statement to conditionally, or unconditionally, insert into multiple tables. This statement reduces table scans and PL/SQL code necessary for performing multiple conditional inserts compared to previous versions. It's main use is for the ETL process in data warehouses where it can be parallelized and/or convert non-relational data into a relational format.

 The Oracle documentation uses the term "multitable inserts", but other resources hyphenate the name, so you will also see it written as "multi-table inserts".

Setup
Unconditional INSERT ALL
Conditional INSERT ALL
INSERT FIRST
Restrictions
Related articles.

Multitable Inserts 
SQL New Features In Oracle 9i
Table Values Constructor in Oracle Database 23c
Setup
Create and populate a test table to act as the source of the data for the basic examples, as well as three destination tables based on the source table, but with no rows.
*/
CREATE TABLE source_tab AS
SELECT level AS id,
       'Description of ' || level AS description
FROM   dual
CONNECT BY level <= 10;


CREATE TABLE dest_tab1 AS
SELECT * FROM source_tab WHERE 1=2;

CREATE TABLE dest_tab2 AS
SELECT * FROM source_tab WHERE 1=2;

CREATE TABLE dest_tab3 AS
SELECT * FROM source_tab WHERE 1=2;


SELECT * FROM source_tab;

        ID DESCRIPTION
---------- -------------------------------------------------------
         1 Description of 1
         2 Description of 2
         3 Description of 3
         4 Description of 4
         5 Description of 5
         6 Description of 6
         7 Description of 7
         8 Description of 8
         9 Description of 9
        10 Description of 10

10 rows selected.

SQL>
Create and populate a test table to act as the source for the pivot example, and an empty destination table.

CREATE TABLE pivot_source (
  id       NUMBER,
  mon_val  NUMBER,
  tue_val  NUMBER,
  wed_val  NUMBER,
  thu_val  NUMBER,
  fri_val  NUMBER
);

INSERT INTO pivot_source VALUES (1, 111, 222, 333, 444, 555);
INSERT INTO pivot_source VALUES (2, 111, 222, 333, 444, 555);

CREATE TABLE pivot_dest (
  id   NUMBER,
  day  VARCHAR2(3),
  val  NUMBER
);
Unconditional INSERT ALL
When using an unconditional INSERT ALL statement, each row produced by the driving query results in a new row in each of the tables listed in the INTO clauses. In the example below, the driving query returns 10 rows, which means we will see 30 rows inserted, 10 in each table.

INSERT ALL
  INTO dest_tab1 (id, description) VALUES (id, description)
  INTO dest_tab2 (id, description) VALUES (id, description)
  INTO dest_tab3 (id, description) VALUES (id, description)
SELECT id, description
FROM   source_tab;

30 rows inserted.

SQL>
An unconditional INSERT ALL statement can be used to pivot or split data. In the following example we convert each single row representing a week of data into separate rows for each day.

INSERT ALL
  INTO pivot_dest (id, day, val) VALUES (id, 'mon', mon_val)
  INTO pivot_dest (id, day, val) VALUES (id, 'tue', tue_val)
  INTO pivot_dest (id, day, val) VALUES (id, 'wed', wed_val)
  INTO pivot_dest (id, day, val) VALUES (id, 'thu', thu_val)
  INTO pivot_dest (id, day, val) VALUES (id, 'fri', fri_val)
SELECT *
FROM   pivot_source;

10 rows inserted.

SQL>


SELECT *
FROM   pivot_dest;

        ID DAY        VAL
---------- --- ----------
         1 mon        111
         2 mon        111
         1 tue        222
         2 tue        222
         1 wed        333
         2 wed        333
         1 thu        444
         2 thu        444
         1 fri        555
         2 fri        555

10 rows selected.

SQL>
/*Conditional INSERT ALL
In a conditional INSERT ALL statement, conditions can be added to the INTO clauses, which means the total number of rows inserted may be less that the number of source rows multiplied by the number of INTO clauses. It looks similar to a CASE expression, but each condition is always tested based on the current row from the driving query.

In the following example we insert into into different tables depending on the range of the ID value.
*/
INSERT ALL
  WHEN id <= 3 THEN
    INTO dest_tab1 (id, description) VALUES (id, description)
  WHEN id BETWEEN 4 AND 7 THEN
    INTO dest_tab2 (id, description) VALUES (id, description)
  WHEN id >= 8 THEN
    INTO dest_tab3 (id, description) VALUES (id, description)
SELECT id, description
FROM   source_tab;

10 rows inserted.

SQL>
A single condition can be used for multiple INTO clauses.

INSERT ALL
  WHEN id <= 3 THEN
    INTO dest_tab1 (id, description) VALUES (id, description)
  WHEN id BETWEEN 4 AND 7 THEN
    INTO dest_tab2 (id, description) VALUES (id, description)
    INTO dest_tab3 (id, description) VALUES (id, description)
SELECT id, description
FROM   source_tab;

11 rows inserted.

SQL>
You can use a condition of "1=1" to force all rows into a table.

INSERT ALL
  WHEN id <= 3 THEN
    INTO dest_tab1 (id, description) VALUES (id, description)
  WHEN id BETWEEN 4 AND 7 THEN
    INTO dest_tab2 (id, description) VALUES (id, description)
  WHEN 1=1 THEN
    INTO dest_tab3 (id, description) VALUES (id, description)
SELECT id, description
FROM   source_tab;

17 rows inserted.

SQL>
INSERT FIRST
Using INSERT FIRST makes the multitable insert work like a CASE expression, so the conditions are tested until the first match is found, and no further conditions are tested. We can also include an optional ELSE clause to catch any rows not already cause by a previous condition.

INSERT FIRST
  WHEN id <= 3 THEN
    INTO dest_tab1 (id, description) VALUES (id, description)
  WHEN id <= 5 THEN
    INTO dest_tab2 (id, description) VALUES (id, description)
  ELSE
    INTO dest_tab3 (id, description) VALUES (id, description)
SELECT id, description
FROM   source_tab;

10 rows inserted.

SQL>


INSERT FIRST
  WHEN id <= 3 THEN
    INTO dest_tab1 (id, description) VALUES (id, description)
  ELSE
    INTO dest_tab2 (id, description) VALUES (id, description)
    INTO dest_tab3 (id, description) VALUES (id, description)
SELECT id, description
FROM   source_tab;

17 rows inserted.

SQL>
/*Restrictions
The restrictions on multitable insertss are as follows.

Multitable inserts can only be performed on tables, not on views or materialized views.
You cannot perform a multitable insert via a DB link.
You cannot perform multitable inserts into nested tables.
The sum of all the INTO columns cannot exceed 999.
Sequences cannot be used in the multitable insert statement. It is considered a single statement, so only one sequence value will be generated and used for all rows.
Multitable inserts can't be used with plan stability.
If the PARALLEL hint is used for any target tables, the whole statement will be parallelized. If not, the statement will only be parallelized if the tables have PARALLEL defined.
Multitable statements will not be parallelized if any of the tables are index-organized, or have bitmap indexes defined on them.
*/
