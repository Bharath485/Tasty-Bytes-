{{ config(materialized='table', schema='DEV') }}

SELECT column1 AS PROJECT_ID, column2 AS PROJ_ELEMENT_ID, column3 AS ELEMENT_NUMBER
FROM VALUES
(9001, 9501, 'TASK-001'),
(9002, 9502, 'TASK-002')
