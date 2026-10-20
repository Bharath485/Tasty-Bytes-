
  create or replace   view DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.fct_sources_without_freshness
  
  
  
  
  as (
    with

all_resources as (
    select * from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_graph_resources
    where is_excluded = cast(0 as boolean)

),

final as (

    select distinct
        resource_name

    from all_resources
    where is_freshness_enabled = cast(0 as boolean) and resource_type = 'source'

)

select * from final



    

    
    

    

    


  );

