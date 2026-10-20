
  create or replace   view DBT_PROJECTS_TASTY_BYTES_DEV.DEV.dim_dbt__sources
  
  
  
  
  as (
    with
    base as (select * from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__sources),

    sources as (

        select
            source_execution_id,
            command_invocation_id,
            node_id,
            run_started_at,
             database
            ,
             schema
            ,
            source_name,
            loader,
            name,
            identifier,
            loaded_at_field,
            freshness
        from base

    )

select *
from sources
  );

