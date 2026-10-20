
  create or replace   view DBT_PROJECTS_TASTY_BYTES_DEV.DEV.fct_dbt__model_performance
  
  
  
  
  as (
    with
    executions as (
        select
            node_id
            , cast(run_started_at as date)
 as date_day
            , status
            , total_node_runtime
            , rows_affected
            , was_full_refresh
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.stg_dbt__model_executions
    ),

    daily as (
        select
            date_day
            , node_id
            , count(*) as executions
            , sum(case when status = 'success' then 1 else 0 end) as success_count
            , sum(case when was_full_refresh then 1 else 0 end) as full_refresh_executions
            , 
    percentile_cont(0.5) within group (order by case when status = 'success' and not was_full_refresh then total_node_runtime end)
 as median_runtime
            , 
    
    percentile_cont(0.95) within group (order by case when status = 'success' and not was_full_refresh then total_node_runtime end)

 as p95_runtime
            , sum(
                case when status = 'success' and not was_full_refresh then rows_affected else 0 end
            ) as rows_affected_sum
        from executions
        group by date_day, node_id
    ),

    baseline as (
        select
            cur.date_day
            , cur.node_id
            , 
    percentile_cont(0.5) within group (order by hist.median_runtime)
 as baseline_runtime
            , count(distinct hist.date_day) as baseline_sample_days
        from daily as cur
        left join daily as hist
            on cur.node_id = hist.node_id
            and dayofweekiso(hist.date_day) = dayofweekiso(cur.date_day)
            and hist.date_day < cur.date_day
            and hist.date_day
                >= dateadd('day', -28, cur.date_day)
            and hist.median_runtime is not null
        group by cur.date_day, cur.node_id
    ),

    final as (
        select
            
md5(cast(coalesce(cast(daily.date_day as TEXT), '') || '-' || coalesce(cast(daily.node_id as TEXT), '') as TEXT))
                as model_performance_id
            , daily.date_day
            , daily.node_id
            , daily.executions
            , daily.success_count
            , daily.full_refresh_executions
            , daily.median_runtime
            , daily.p95_runtime
            , daily.rows_affected_sum
            , baseline.baseline_runtime
            , baseline.baseline_sample_days
            , case
                when baseline.baseline_runtime > 0
                    then daily.median_runtime / baseline.baseline_runtime
            end as runtime_regression_ratio
            , case
                when baseline.baseline_runtime > 0
                    and daily.median_runtime / baseline.baseline_runtime
                        > 1.5
                    and baseline.baseline_sample_days
                        >= 3
                    then true
                else false
            end as is_regressed
        from daily
        left join baseline
            on daily.date_day = baseline.date_day
            and daily.node_id = baseline.node_id
    )

select *
from final
  );

