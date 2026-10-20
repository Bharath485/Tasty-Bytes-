with
    test_executions as (
        select
            node_id as test_node_id
            , run_started_at
            , status
            , cast(run_started_at as date)
 as date_day
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__test_executions
    ),

    sequenced as (
        select
            test_node_id
            , run_started_at
            , status
            , date_day
            , lag(status) over (
                partition by test_node_id order by run_started_at
            ) as prev_status
            , lag(run_started_at) over (
                partition by test_node_id order by run_started_at
            ) as prev_run_started_at
            , lag(date_day) over (
                partition by test_node_id order by run_started_at
            ) as prev_date_day
        from test_executions
    ),

    flip_candidates as (
        select
            test_node_id
            , date_day
            , prev_run_started_at as failed_at
            , run_started_at as passed_at
        from sequenced
        where status = 'pass'
            and prev_status in ('fail', 'error')
            and prev_date_day = date_day
    ),

    test_model_parents as (
        select
            child_node_id as test_node_id
            , parent_node_id
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.dim_dbt__lineage_edges
        where child_resource_type = 'test'
            and parent_node_id like 'model.%'
    ),

    candidate_parent_activity as (
        select
            fc.test_node_id
            , fc.date_day
            , fc.failed_at
            , fc.passed_at
            , count(distinct tmp.parent_node_id) as n_parents
            , count(distinct
                case
                    when me.node_id is not null then me.node_id
                end
            ) as n_parents_rebuilt_between
        from flip_candidates as fc
        left join test_model_parents as tmp
            on fc.test_node_id = tmp.test_node_id
        left join DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__model_executions as me
            on me.node_id = tmp.parent_node_id
            and me.status = 'success'
            and me.run_started_at > fc.failed_at
            and me.run_started_at < fc.passed_at
        group by fc.test_node_id, fc.date_day, fc.failed_at, fc.passed_at
    ),

    final as (
        select
            
md5(cast(coalesce(cast(test_node_id as TEXT), '') || '-' || coalesce(cast(failed_at as TEXT), '') || '-' || coalesce(cast(passed_at as TEXT), '') as TEXT))
                as flaky_test_flip_id
            , test_node_id
            , date_day
            , failed_at
            , passed_at
            , case when n_parents = 0 then null else false end as parent_rebuilt_between
        from candidate_parent_activity
        where n_parents_rebuilt_between = 0
    )

select *
from final