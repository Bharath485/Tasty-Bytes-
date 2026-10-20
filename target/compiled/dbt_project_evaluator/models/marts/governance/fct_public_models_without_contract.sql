with 

all_resources as (
    select * from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_graph_resources
    where is_excluded = cast(0 as boolean)
),

final as (

    select 
        resource_name,
        is_public,
        is_contract_enforced
        
    from all_resources
    where 
        is_public = cast(1 as boolean)
        and is_contract_enforced = cast(0 as boolean)
)

select * from final



    

    
    

    

    

