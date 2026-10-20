
  
    

create or replace transient table DBT_PROJECTS_TASTY_BYTES_DEV.mart.customer_loyalty_metrics
    
    
    
    
    

    as (SELECT 
    cl.customer_id,
    cl.city,
    cl.country,
    cl.first_name,
    cl.last_name,
    cl.phone_number,
    cl.e_mail,
    SUM(oh.order_total) AS total_sales,
    ARRAY_AGG(DISTINCT oh.location_id) AS visited_location_ids_array
FROM DBT_PROJECTS_TASTY_BYTES_DEV.DEV.raw_customer_customer_loyalty cl
JOIN DBT_PROJECTS_TASTY_BYTES_DEV.DEV.raw_pos_order_header oh
ON cl.customer_id = oh.customer_id
GROUP BY cl.customer_id, cl.city, cl.country, cl.first_name,
cl.last_name, cl.phone_number, cl.e_mail
    )
;


  