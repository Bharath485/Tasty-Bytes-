
  create or replace   view DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.fct_missing_primary_key_tests
  
  
  
  
  as (
    with

tests as (
    select * from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_model_test_summary
    where resource_type in
    (
        'model'
        
    )
),

final as (

    select
        resource_name,
        resource_type,
        model_type,
        is_primary_key_tested,
        number_of_tests_on_model,
        number_of_constraints_on_model
    from tests
    where is_primary_key_tested = cast(0 as boolean)

)

select * from final



    

    
    

    

    


  );

