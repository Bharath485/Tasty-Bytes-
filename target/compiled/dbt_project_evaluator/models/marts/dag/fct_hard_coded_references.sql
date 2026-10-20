-- this model finds cases where a model has hard coded references

with models as (
    select * from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_graph_resources
    where resource_type = 'model'
    and is_excluded = cast(0 as boolean)
),

final as (
    select
        resource_name as model,
        hard_coded_references
    from models
    where hard_coded_references != ''
)

select * from final



    

    
    

    

    

