{{ config(materialized='table', schema='DEV') }}

SELECT column1 AS PROJECT_ID, column2 AS SEGMENT1
FROM VALUES
(9001, 'PRJ-001'),
(9002, 'PRJ-002')
