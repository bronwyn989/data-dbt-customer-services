     {% set datasets = ["fct_csm_events","fct_ism_events"] %}

    with

    {% for dataset in datasets %}

    {{dataset}} as (

    SELECT
            [Event Type],
            [EventLink],
	        [Contact Type],
            [DateKey]
    FROM {{ref(dataset)}}
    ),

    {% endfor %}

    final_table as (

        {% for dataset in datasets %}

        select * from {{dataset}}

        {% if not loop.last -%} union all {%- endif %}

    {% endfor %}
    )

    select * from final_table