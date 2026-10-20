
  
    

create or replace transient table DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.base_exposure_relationships
    
    
    
    
    

    as (


    


/* Bigquery won't let us `where` without `from` so we use this workaround */
with dummy_cte_exposure_relationships as (
    select 1 as foo
) 

select 
    cast(null as TEXT) as resource_id,
    cast(null as TEXT) as direct_parent_id,
    cast(1 as boolean) as is_primary_relationship

from dummy_cte_exposure_relationships
where 1=0
    )
;


  