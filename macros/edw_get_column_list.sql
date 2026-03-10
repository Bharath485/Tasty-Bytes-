{% macro edw_get_column_list(relation) %}
    {% set columns = adapter.get_columns_in_relation(relation) %}
    {% set column_list = columns | map(attribute='name') | list %}
    {{ return(column_list) }}
{% endmacro %}
