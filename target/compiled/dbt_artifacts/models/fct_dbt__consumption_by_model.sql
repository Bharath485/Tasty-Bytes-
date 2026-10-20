with
    model_executions as (
        select
            me.node_id
            , me.name
            , me.status
            , me.total_node_runtime
            , cast(me.run_started_at as date)
 as date_day
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

    smb_executions as (
        select
            node_id
            , name
            , total_node_runtime
            , date_day
            , date_trunc('month', date_day) as billing_month
        from model_executions
        where status = 'success'
            and dbt_command in ('run', 'build', 'retry')
            and billing_class = 'deployment'
    ),

    by_model as (
        select
            billing_month
            , node_id
            , max(name) as name
            , count(*) as smb_quantity
            , count(distinct date_day) as distinct_days_built
            , sum(total_node_runtime) as total_runtime_seconds
        from smb_executions
        group by billing_month, node_id
    ),

    final as (
        select
            
md5(cast(coalesce(cast(billing_month as TEXT), '') || '-' || coalesce(cast(node_id as TEXT), '') as TEXT))
                as consumption_by_model_id
            , billing_month
            , node_id
            , name
            , smb_quantity
            , smb_quantity
                / sum(smb_quantity) over (partition by billing_month)
                as pct_of_month_smb
            , smb_quantity / nullif(distinct_days_built, 0) as builds_per_day_avg
            , distinct_days_built
            , total_runtime_seconds
            , distinct_days_built * 0.094
                as estimated_monthly_datt_cost_if_reused
        from by_model
    )

select *
from final