{{ config(materialized='table', schema='DEV') }}

SELECT column1 AS PROJ_ELEMENT_ID, column2 AS NAME, column3 AS LANGUAGE
FROM VALUES
(9501, 'Design Phase', 'US'),
(9502, 'Build Phase', 'US')
