with conuntry_mart as (
    select * from {{source('tb_101','COUNTRY')}} 
)

select * from conuntry_mart