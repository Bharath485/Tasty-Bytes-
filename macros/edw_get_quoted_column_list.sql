{% macro edw_get_quoted_column_list(relation, exclude_columns) %}
    {% set columns = adapter.get_columns_in_relation(relation) %}
    {% set column_names = columns | map(attribute='name') | list %}
    {% set filtered = [] %}
    {% for col in column_names %}
        {% if col not in exclude_columns %}
            {% do filtered.append('"' ~ col ~ '"') %}
        {% endif %}
    {% endfor %}
    {{ return(filtered) }}
{% endmacro %}
