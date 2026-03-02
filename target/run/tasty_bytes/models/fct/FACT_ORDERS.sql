-- back compat for old kwarg name
  
  begin;
    
        
            
	    
	    
            
        
    

    

    merge into DBT_POC.DEV.FACT_ORDERS as DBT_INTERNAL_DEST
        using DBT_POC.DEV.FACT_ORDERS__dbt_tmp as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.order_id = DBT_INTERNAL_DEST.order_id))

    
    when matched then update set
        "ORDER_ID" = DBT_INTERNAL_SOURCE."ORDER_ID","ORDER_TIMESTAMP" = DBT_INTERNAL_SOURCE."ORDER_TIMESTAMP","TOTAL_LINE_AMOUNT" = DBT_INTERNAL_SOURCE."TOTAL_LINE_AMOUNT","TOTAL_QUANTITY" = DBT_INTERNAL_SOURCE."TOTAL_QUANTITY"
    

    when not matched then insert
        ("ORDER_ID", "ORDER_TIMESTAMP", "TOTAL_LINE_AMOUNT", "TOTAL_QUANTITY")
    values
        ("ORDER_ID", "ORDER_TIMESTAMP", "TOTAL_LINE_AMOUNT", "TOTAL_QUANTITY")

;
    commit;