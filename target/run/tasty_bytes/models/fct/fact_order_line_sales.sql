-- back compat for old kwarg name
  
  begin;
    
        
            
	    
	    
            
        
    

    

    merge into DBT_POC.DEV.fact_order_line_sales as DBT_INTERNAL_DEST
        using DBT_POC.DEV.fact_order_line_sales__dbt_tmp as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.order_detail_id = DBT_INTERNAL_DEST.order_detail_id))

    
    when matched then update set
        "ORDER_DETAIL_ID" = DBT_INTERNAL_SOURCE."ORDER_DETAIL_ID","ORDER_ID" = DBT_INTERNAL_SOURCE."ORDER_ID","DATE_KEY" = DBT_INTERNAL_SOURCE."DATE_KEY","LOCATION_KEY" = DBT_INTERNAL_SOURCE."LOCATION_KEY","TRUCK_KEY" = DBT_INTERNAL_SOURCE."TRUCK_KEY","LINE_SALES_AMOUNT_USD" = DBT_INTERNAL_SOURCE."LINE_SALES_AMOUNT_USD"
    

    when not matched then insert
        ("ORDER_DETAIL_ID", "ORDER_ID", "DATE_KEY", "LOCATION_KEY", "TRUCK_KEY", "LINE_SALES_AMOUNT_USD")
    values
        ("ORDER_DETAIL_ID", "ORDER_ID", "DATE_KEY", "LOCATION_KEY", "TRUCK_KEY", "LINE_SALES_AMOUNT_USD")

;
    commit;