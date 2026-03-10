{% macro edw_batch_control(v_dbt_job_name, v_schema, v_alias, v_tags, v_materialized) %}
    {% set watermark = ['2020-01-01 00:00:00.000', '2099-12-31 23:59:59.999', modules.datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.000'), '1'] %}
    {{ return(watermark) }}
{% endmacro %}
