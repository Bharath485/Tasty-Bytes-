
  
    

create or replace transient table DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.fct_source_fanout
    
    
    
    
    

    as (-- this model finds cases where a source is used in multiple direct downstream models
with direct_source_relationships as (
    select  
        *
    from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_dag_relationships
    where distance = 1
    and parent_resource_type = 'source'
    and child_resource_type = 'model'
    and parent_is_excluded = cast(0 as boolean)
    and child_is_excluded = cast(0 as boolean)
    
    -- we order the CTE so that listagg returns values correctly sorted for some warehouses
    order by child
    
),

source_fanout as (
    select
        parent,
        
    listagg(
        child,
        ', '
        )
        within group (order by child) as model_children
    from direct_source_relationships
    group by parent
    having count(*) > 1
)

select * from source_fanout



    

    
    

    

    


    )
;


  