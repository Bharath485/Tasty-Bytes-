
  create or replace   view DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.fct_chained_views_dependencies
  
  
  
  
  as (
    with all_relationships as (
    select  
        *
    from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_dag_relationships
    where distance <> 0
    and parent_is_excluded = cast(0 as boolean)
    and child_is_excluded = cast(0 as boolean)
),

final as (
    select
        parent,
        child, -- the model with potentially long run time / compilation time, improve performance by breaking the upstream chain of views
        distance,
        path
    from all_relationships
    where is_dependent_on_chain_of_views = cast(1 as boolean)
    and child_resource_type = 'model'
    and distance > 5
)

select * from final



    

    
    

    

    


order by distance desc

  );

