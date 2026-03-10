{{ config(materialized='table', schema='DEV') }}

SELECT column1 AS PROJECT_ID, column2 AS NAME, column3 AS LANGUAGE
FROM VALUES
(9001, 'Alpha Project', 'US'),
(9002, 'Beta Project', 'US')
