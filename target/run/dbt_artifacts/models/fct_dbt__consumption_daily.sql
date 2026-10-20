
  create or replace   view DBT_PROJECTS_TASTY_BYTES_DEV.DEV.fct_dbt__consumption_daily
  
  
  
  
  as (
    with
    detail as (select * from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.fct_dbt__consumption_daily_detail),

    aggregated as (
        select
            date_day
            , meter
            , sum(quantity) as quantity
        from detail
        group by date_day, meter
    ),

    final as (
        select
            
md5(cast(coalesce(cast(date_day as TEXT), '') || '-' || coalesce(cast(meter as TEXT), '') as TEXT))
                as consumption_daily_id
            , date_day
            , meter
            , quantity
        from aggregated
    )

select *
from final
  );

