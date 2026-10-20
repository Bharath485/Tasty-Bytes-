
  create or replace   view DBT_PROJECTS_TASTY_BYTES_DEV.DEV.fct_dbt__model_executions
  
  
  
  
  as (
    with
    base as (select * from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__model_executions),

    model_executions as (

        select
            model_execution_id,
            command_invocation_id,
            node_id,
            run_started_at,
            was_full_refresh,
            thread_id,
            status,
            compile_started_at,
            query_completed_at,
            total_node_runtime,
            rows_affected
            ,
            materialization,
             schema
            ,
            name,
            alias,
            message
        from base

    )

select *
from model_executions
  );

