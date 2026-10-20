with

all_resources as (
    select * from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_graph_resources
    where is_excluded = cast(0 as boolean)

),

final as (

    select
        resource_name

    from all_resources
    where is_described = cast(0 as boolean) and resource_type = 'source'

)

select * from final



    

    
    

    

    

