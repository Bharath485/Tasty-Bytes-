-- all models with inappropriate (or lack of) pre-fix
-- ensure dbt project has consistent naming conventions





with all_graph_resources as (
    select * from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.int_all_graph_resources
    where is_excluded = cast(0 as boolean)
    -- exclude required time spine
    
),

naming_convention_prefixes as (
    select * from DBT_PROJECT_EVALUVATOR.RAW_EVALUATION.stg_naming_convention_prefixes
    
    -- we order the CTE so that listagg returns values correctly sorted for some warehouses
    order by prefix_value
    
),

appropriate_prefixes as (
    select
        model_type,
        
    listagg(
        prefix_value,
        ', '
        )
        within group (order by prefix_value) as appropriate_prefixes
    from naming_convention_prefixes
    group by model_type
), 

models as (
    select
        all_graph_resources.resource_name,
        all_graph_resources.prefix,
        all_graph_resources.model_type,
        naming_convention_prefixes.prefix_value
    from all_graph_resources 
    left join naming_convention_prefixes
        on all_graph_resources.model_type = naming_convention_prefixes.model_type
        and all_graph_resources.prefix = naming_convention_prefixes.prefix_value
    where resource_type = 'model'
),

inappropriate_model_names as (
    select 
        models.resource_name,
        models.prefix,
        models.model_type,
        appropriate_prefixes.appropriate_prefixes
    from models
    left join appropriate_prefixes
        on models.model_type = appropriate_prefixes.model_type
    where nullif(models.prefix_value, '') is null

)

select * from inappropriate_model_names



    

    
    

    

    

