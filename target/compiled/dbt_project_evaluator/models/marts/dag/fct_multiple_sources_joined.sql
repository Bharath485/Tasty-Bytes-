-- this model finds cases where a model references more than one source
with direct_source_relationships as (
    select distinct
        child,
        parent
    from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_dag_relationships
    where distance = 1
    and parent_resource_type = 'source'
    and parent_is_excluded = cast(0 as boolean)
    and child_is_excluded = cast(0 as boolean)
    
    -- we order the CTE so that listagg returns values correctly sorted for some warehouses
    order by 1, 2
    
),

multiple_sources_joined as (
    select
        child,
        
    listagg(
        parent,
        ', '
        )
        within group (order by parent) as source_parents
    from direct_source_relationships
    group by child
    having count(*) > 1
)

select * from multiple_sources_joined



    

    
    

    

    

