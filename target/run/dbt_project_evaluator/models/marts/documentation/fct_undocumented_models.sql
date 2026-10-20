
  create or replace   view DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.fct_undocumented_models
  
  
  
  
  as (
    with

all_resources as (
    select * from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_graph_resources
    where is_excluded = cast(0 as boolean)

),

final as (

    select
        resource_name,
        model_type

    from all_resources
    where is_described = cast(0 as boolean) and resource_type = 'model'

)

select * from final



    

    
    

    

    


  );

