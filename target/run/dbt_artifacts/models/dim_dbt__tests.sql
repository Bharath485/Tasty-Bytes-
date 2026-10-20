
  create or replace   view DBT_PROJECTS_TASTY_BYTES_DEV.DEV.dim_dbt__tests
  
  
  
  
  as (
    with
    base as (

        select *
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__tests

    )

    , tests as (

        select
            test_execution_id
            , command_invocation_id
            , node_id
            , run_started_at
            , name
            , depends_on_nodes
            , package_name
            , test_path
            , tags
        from base

    )

select * from tests
  );

