{{ config(materialized='table', schema='DEV') }}

SELECT column1 AS VENDOR_ID, column2 AS SUPPLIER_NAME
FROM VALUES
(2001, 'Texas Instruments'),
(2002, 'Murata Manufacturing')
