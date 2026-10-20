
  create or replace   view DBT_PROJECTS_TASTY_BYTES_DEV.DEV.dim_dbt__snapshots
  
  
  
  
  as (
    with
    base as (select * from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__snapshots),

    snapshots as (

        select
            snapshot_execution_id,
            command_invocation_id,
            node_id,
            run_started_at,
            name,
             database
            ,
             schema
            ,
            depends_on_nodes,
            package_name,
            path,
            checksum,
            strategy,
            meta,
            alias
        from base

    )

select *
from snapshots
  );

