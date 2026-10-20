
  create or replace   view DBT_PROJECTS_TASTY_BYTES_DEV.DEV.fct_dbt__consumption_daily_detail
  
  
  
  
  as (
    with
    model_executions as (
        select
            me.node_id
            , me.status
            , me.materialization
            , cast(me.run_started_at as date)
 as date_day
            , i.target_name
            , i.dbt_command
            , case
            when dbt_cloud_job_id is not null then 'deployment'
            when lower(target_name) in ('prod', 'production', 'ci') then 'deployment'
            else 'development'
        end as billing_class
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__model_executions as me
        inner join DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__invocations as i
            on me.command_invocation_id = i.command_invocation_id
    ),

    smb_detail as (
        select
            date_day
            , 'smb' as meter
            , materialization
            , target_name
            , count(*) as quantity
        from model_executions
        where status = 'success'
            and dbt_command in ('run', 'build', 'retry')
            and billing_class = 'deployment'
        group by date_day, materialization, target_name
    ),

    all_executions as (
        select
            node_id
            , status
            , run_started_at
            , command_invocation_id
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__model_executions
        union all
        select
            node_id
            , status
            , run_started_at
            , command_invocation_id
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__seed_executions
        union all
        select
            node_id
            , status
            , run_started_at
            , command_invocation_id
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__snapshot_executions
        union all
        select
            node_id
            , status
            , run_started_at
            , command_invocation_id
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__test_executions
    ),

    active_executions as (
        select
            ae.node_id
            , ae.status
            , cast(ae.run_started_at as date)
 as date_day
            , i.target_name
            , case
            when dbt_cloud_job_id is not null then 'deployment'
            when lower(target_name) in ('prod', 'production', 'ci') then 'deployment'
            else 'development'
        end as billing_class
        from all_executions as ae
        inner join DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__invocations as i
            on ae.command_invocation_id = i.command_invocation_id
    ),

    active_target_tables_detail as (
        select
            date_day
            , 'active_target_tables' as meter
            , cast(null as TEXT) as materialization
            , target_name
            , count(distinct node_id) as quantity
        from active_executions
        where status = 'success'
            and billing_class = 'deployment'
        group by date_day, target_name
    ),

    combined as (
        select
            date_day
            , meter
            , materialization
            , target_name
            , quantity
        from smb_detail
        union all
        select
            date_day
            , meter
            , materialization
            , target_name
            , quantity
        from active_target_tables_detail
    ),

    final as (
        select
            
md5(cast(coalesce(cast(date_day as TEXT), '') || '-' || coalesce(cast(meter as TEXT), '') || '-' || coalesce(cast(materialization as TEXT), '') || '-' || coalesce(cast(target_name as TEXT), '') as TEXT)) as consumption_daily_detail_id
            , date_day
            , meter
            , materialization
            , target_name
            , quantity
        from combined
    )

select *
from final
  );

