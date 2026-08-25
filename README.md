# PostgreSQL / SQL Practicum

A collection of SQL exercises built around a relational railway/logistics database. The repository starts with schema/data work and progresses to analytical queries, views, window functions, recursive queries and database-side logic.

`PostgreSQL` · `SQL` · `Window Functions` · `Views` · `CTE / Recursion` · `Query Analysis`

## What is demonstrated

The repository contains examples of:

- relational schema and table creation;
- loading and working with tabular data;
- filtering, string/date processing and regular expressions;
- aggregation with `GROUP BY` / `HAVING`;
- scalar and correlated subqueries;
- `JOIN`, `LEFT/RIGHT/FULL JOIN`, `CROSS JOIN` and `NATURAL JOIN`;
- set operations: `UNION`, `INTERSECT`, `EXCEPT`;
- window functions such as `ROW_NUMBER`, `RANK`, `DENSE_RANK` and `COUNT OVER`;
- database views, including view-based task logic;
- foreign keys and referential actions;
- query-plan experiments with `EXPLAIN ANALYZE`;
- recursive traversal of hierarchical data.

## Repository structure

```text
laba_1/      schema/data files and database design materials
laba_2/      subsequent database exercises
laba_3.sql   filtering, expressions, regex, grouping and basic subqueries
laba_4.sql   aggregates, subqueries, joins, constraints and EXPLAIN ANALYZE
laba_5.sql   advanced joins, windows, views, set operations and recursion
```

## Selected examples

### Window functions

The advanced tasks use window functions to rank and limit records inside groups, for example selecting a limited number of routes per station or ranking repair prices without collapsing rows through aggregation.

```sql
ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)
RANK()       OVER (PARTITION BY ... ORDER BY ...)
DENSE_RANK() OVER (ORDER BY ...)
COUNT(*)     OVER (PARTITION BY ...)
```

### Set operations

Several tasks combine logically different query results with PostgreSQL set operators:

```sql
UNION
INTERSECT
EXCEPT
```

This includes finding common route sets and locating identifiers that exist in one relation but not another.

### Views and database-side logic

The repository contains regular views as well as examples of working with updateable/join-based views and PostgreSQL rules. More complex views are used to build derived route and station information instead of repeating the same query logic.

### Recursive query

One of the advanced tasks constructs an employee-subordination chain through a recursive view, demonstrating hierarchical traversal rather than a fixed-depth self-join.

### Query analysis

`laba_4.sql` also contains a large generated test table and compares alternative aggregation/filtering forms with `EXPLAIN ANALYZE`.

## Why this repository is in the portfolio

The goal is not to present the individual assignments as a standalone production database. It is a compact demonstration that my SQL experience goes beyond basic `SELECT / WHERE / GROUP BY` queries and includes **relational reasoning, analytical SQL, window functions, views, recursion and query-plan inspection**.

For applied ML/Data Science work, these are the SQL patterns I consider most relevant when preparing datasets, constructing aggregates and investigating data directly in a database.
