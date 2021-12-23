    {% set datasets = ["Created","Resolved","Active"] %}

    with

    {% for dataset in datasets %}

    {{dataset}} as (

    SELECT
            '{{dataset}}' AS [Event Type],
            [EventLink],
	        [Contact Type],
            case when '{{dataset}}'='Created' then [Created Date]
                when '{{dataset}}'='Active' then [Created Date]
                when '{{dataset}}'='Resolved' then [Resolved Date]
                end as  DateKey    
    FROM {{ref('fct_fuse_tickets')}}
    ),

    {% endfor %}

    final_table as (

        {% for dataset in datasets %}

        select * from {{dataset}}

        {% if not loop.last -%} union all {%- endif %}

    {% endfor %}
    )

    select * from final_table
