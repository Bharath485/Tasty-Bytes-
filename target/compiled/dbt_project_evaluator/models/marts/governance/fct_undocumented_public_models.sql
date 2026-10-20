with 

all_resources as (
    select * from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_graph_resources
    where is_excluded = cast(0 as boolean)
),

final as (
    select
        resource_name,
        access,
        is_described,
        total_defined_columns,
        total_described_columns

    from all_resources
    where
        is_public = cast(1 as boolean)
        and (
            -- no model level description
            is_described = cast(0 as boolean)
            -- not all columns defined have descriptions
            or total_described_columns < total_defined_columns
            -- no columns defined at all
            or total_defined_columns = 0
        )
)

select * from final



    

    
    

    

    

