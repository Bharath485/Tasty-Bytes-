
  create or replace   view DBT_PROJECTS_TASTY_BYTES_DEV.DEV.fct_dbt__consumption_forecast
  
  
  
  
  as (
    with
    daily as (
        select
            date_day
            , meter
            , quantity
        from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.fct_dbt__consumption_daily
    ),

    month_anchors as (
        select
            meter
            , date_trunc('month', date_day) as billing_month
            , last_day(date_trunc('month', date_day)) as month_end
            , least(current_date(), last_day(date_trunc('month', date_day))) as as_of_date
            , datediff(
                'day', least(current_date(), last_day(date_trunc('month', date_day))),
                last_day(date_trunc('month', date_day))
            ) as days_remaining
        from daily
        group by meter, date_trunc('month', date_day)
    ),

    month_to_date as (
        select
            ma.meter
            , ma.billing_month
            , sum(
                case when daily.date_day <= ma.as_of_date then daily.quantity else 0 end
            ) as month_to_date_quantity
        from month_anchors as ma
        inner join daily
            on daily.meter = ma.meter
            and date_trunc('month', daily.date_day) = ma.billing_month
        group by ma.meter, ma.billing_month
    ),

    offsets as (
        select 0 as day_offset
        union all
        select 1 as day_offset
        union all
        select 2 as day_offset
        union all
        select 3 as day_offset
        union all
        select 4 as day_offset
        union all
        select 5 as day_offset
        union all
        select 6 as day_offset
        union all
        select 7 as day_offset
        union all
        select 8 as day_offset
        union all
        select 9 as day_offset
        union all
        select 10 as day_offset
        union all
        select 11 as day_offset
        union all
        select 12 as day_offset
        union all
        select 13 as day_offset
        union all
        select 14 as day_offset
        union all
        select 15 as day_offset
        union all
        select 16 as day_offset
        union all
        select 17 as day_offset
        union all
        select 18 as day_offset
        union all
        select 19 as day_offset
        union all
        select 20 as day_offset
        union all
        select 21 as day_offset
        union all
        select 22 as day_offset
        union all
        select 23 as day_offset
        union all
        select 24 as day_offset
        union all
        select 25 as day_offset
        union all
        select 26 as day_offset
        union all
        select 27 as day_offset
    ),

    trailing_days as (
        select
            ma.meter
            , ma.billing_month
            , dayofweekiso(dateadd('day', -offsets.day_offset, ma.as_of_date)) as dow
            , coalesce(daily.quantity, 0) as quantity
        from month_anchors as ma
        cross join offsets
        left join daily
            on daily.meter = ma.meter
            and daily.date_day = dateadd('day', -offsets.day_offset, ma.as_of_date)
    ),

    dow_average as (
        select
            meter
            , billing_month
            , dow
            , avg(quantity) as avg_quantity
        from trailing_days
        group by meter, billing_month, dow
    ),

    daily_run_rate as (
        select
            meter
            , billing_month
            , avg(quantity) as daily_run_rate
        from trailing_days
        group by meter, billing_month
    ),

    day_numbers as (
        select 1 as day_number
        union all
        select 2 as day_number
        union all
        select 3 as day_number
        union all
        select 4 as day_number
        union all
        select 5 as day_number
        union all
        select 6 as day_number
        union all
        select 7 as day_number
        union all
        select 8 as day_number
        union all
        select 9 as day_number
        union all
        select 10 as day_number
        union all
        select 11 as day_number
        union all
        select 12 as day_number
        union all
        select 13 as day_number
        union all
        select 14 as day_number
        union all
        select 15 as day_number
        union all
        select 16 as day_number
        union all
        select 17 as day_number
        union all
        select 18 as day_number
        union all
        select 19 as day_number
        union all
        select 20 as day_number
        union all
        select 21 as day_number
        union all
        select 22 as day_number
        union all
        select 23 as day_number
        union all
        select 24 as day_number
        union all
        select 25 as day_number
        union all
        select 26 as day_number
        union all
        select 27 as day_number
        union all
        select 28 as day_number
        union all
        select 29 as day_number
        union all
        select 30 as day_number
        union all
        select 31 as day_number
    ),

    remaining_days as (
        select
            ma.meter
            , ma.billing_month
            , dateadd('day', day_numbers.day_number - 1, ma.billing_month) as calendar_date
            , dayofweekiso(
                dateadd('day', day_numbers.day_number - 1, ma.billing_month)
            ) as dow
        from month_anchors as ma
        cross join day_numbers
        where day_numbers.day_number <= day(ma.month_end)
            and dateadd('day', day_numbers.day_number - 1, ma.billing_month) > ma.as_of_date
    ),

    remaining_expected as (
        select
            rd.meter
            , rd.billing_month
            , rd.calendar_date
            , coalesce(da.avg_quantity, 0) as expected_quantity
            , sum(coalesce(da.avg_quantity, 0)) over (
                partition by rd.meter, rd.billing_month
                order by rd.calendar_date
                rows between unbounded preceding and current row
            ) as cumulative_expected
        from remaining_days as rd
        left join dow_average as da
            on da.meter = rd.meter
            and da.billing_month = rd.billing_month
            and da.dow = rd.dow
    ),

    remaining_summary as (
        select
            meter
            , billing_month
            , sum(expected_quantity) as total_expected_remaining
        from remaining_expected
        group by meter, billing_month
    ),

    final as (
        select
            
md5(cast(coalesce(cast(ma.meter as TEXT), '') || '-' || coalesce(cast(ma.billing_month as TEXT), '') as TEXT))
                as consumption_forecast_id
            , ma.billing_month
            , ma.meter
            , mtd.month_to_date_quantity
            , cast(null as integer) as allowance
            , drr.daily_run_rate
            , mtd.month_to_date_quantity + coalesce(rs.total_expected_remaining, 0)
                as forecast_month_end_quantity
            , cast(null as timestamp) as forecast_exceeded_date
            , cast(null as float) as pct_of_allowance_used
            , ma.days_remaining
            , cast(null as boolean) as is_on_pace_to_exceed
        from month_anchors as ma
        inner join month_to_date as mtd
            on mtd.meter = ma.meter and mtd.billing_month = ma.billing_month
        left join daily_run_rate as drr
            on drr.meter = ma.meter and drr.billing_month = ma.billing_month
        left join remaining_summary as rs
            on rs.meter = ma.meter and rs.billing_month = ma.billing_month
    )

select *
from final
  );

