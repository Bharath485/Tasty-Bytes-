with
    detail as (select * from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.fct_dbt__dag_bottlenecks_detail),

    gating as (
        select *
        from detail
        where stall_seconds > 0
    ),

    final as (
        select
            
md5(cast(coalesce(cast(date_day as TEXT), '') || '-' || coalesce(cast(binding_parent_node_id as TEXT), '') as TEXT))
                as dag_bottleneck_id
            , date_day
            , binding_parent_node_id as parent_node_id
            , count(distinct child_node_id) as blocked_children
            , sum(stall_seconds) as total_stall_seconds
            , max(stall_seconds) as max_stall_seconds
            , count(distinct command_invocation_id) as invocations_observed
        from gating
        group by date_day, binding_parent_node_id
    )

select *
from final