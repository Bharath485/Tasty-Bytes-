{{ config(materialized='table', schema='DEV') }}

SELECT column1 AS PERSON_ID, column2 AS FULL_NAME
FROM VALUES
(501, 'John Smith'),
(502, 'Jane Doe')
