


    

/* Bigquery won't let us `where` without `from` so we use this workaround */
with dummy_cte_node_columns as (
    select 1 as foo
) 

select 
    cast(null as TEXT) as node_unique_id,
    cast(null as TEXT) as name,
    cast(null as TEXT) as description,
    cast(null as TEXT) as data_type,
    cast(null as TEXT) as constraints,
    cast(1 as boolean) as has_not_null_constraint,
    cast(0 as integer) as constraints_count,
    cast(null as TEXT) as quote

from dummy_cte_node_columns
where 1=0