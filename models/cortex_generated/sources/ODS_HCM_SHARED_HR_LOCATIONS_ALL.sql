{{ config(materialized='table', schema='DEV') }}

SELECT column1 AS LOCATION_ID, column2 AS LOCATION_CODE
FROM VALUES
(4001, 'PHX-AZ-PLANT1'),
(4002, 'POCATELLO-ID'),
(4003, 'GRESHAM-OR')
