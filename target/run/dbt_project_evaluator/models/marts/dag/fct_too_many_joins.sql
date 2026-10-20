
  
    

create or replace transient table DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.fct_too_many_joins
    
    
    
    
    

    as (with all_dag_relationships as (
    select
        *
    from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_dag_relationships
    where child_is_excluded = cast(0 as boolean)
    and child_resource_type = 'model'
),

final as (
    select
        child as resource_name,
        child_file_path as file_path,
        cast(count(distinct parent) as integer) as join_count
    from all_dag_relationships
    where distance = 1
    group by child, child_file_path
    having count(distinct parent) >= 7
)

select * from final



    

    
    

    

    


    )
;


  