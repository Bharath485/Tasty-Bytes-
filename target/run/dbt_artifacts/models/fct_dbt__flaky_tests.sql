
  create or replace   view DBT_PROJECTS_TASTY_BYTES_DEV.DEV.fct_dbt__flaky_tests
  
  
  
  
  as (
    with
    test_executions as (
        select
            node_id as test_node_id
            , date_trunc('month', cast(run_started_at as date)
)
                as month
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__test_executions
    ),

    executions_monthly as (
        select
            test_node_id
            , month
            , count(*) as executions
        from test_executions
        group by test_node_id, month
    ),

    flips_monthly as (
        select
            test_node_id
            , date_trunc('month', date_day) as month
            , count(*) as flips
            , max(passed_at) as last_flip_at
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.fct_dbt__flaky_tests_detail
        group by test_node_id, date_trunc('month', date_day)
    ),

    final as (
        select
            
md5(cast(coalesce(cast(em.test_node_id as TEXT), '') || '-' || coalesce(cast(em.month as TEXT), '') as TEXT))
                as flaky_test_id
            , em.test_node_id
            , em.month
            , coalesce(fm.flips, 0) as flips
            , em.executions
            , coalesce(fm.flips, 0) / nullif(em.executions, 0) as flake_rate
            , fm.last_flip_at
            , case
                when coalesce(fm.flips, 0) >= 2
                    then true
                else false
            end as is_flaky
        from executions_monthly as em
        left join flips_monthly as fm
            on em.test_node_id = fm.test_node_id
            and em.month = fm.month
    )

select *
from final
  );

