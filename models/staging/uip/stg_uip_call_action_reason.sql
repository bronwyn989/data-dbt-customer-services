{% set uip_dbs = ["uip_old", "uip_new"] %}

with 

{% for uip_db in uip_dbs %}

{{ uip_db }} as (

SELECT 
	CallActionReasonId,
	[CallActionReasonDesc]  [Call Action Reason],
	'{{ uip_db }}' 	as DatabaseSource                     
FROM {{ source(uip_db, 'tlkpCallActionReason') }} (NOLOCK) 

),

{% endfor %}

final_table as (

	{% for uip_db in uip_dbs %}
	
	select * from {{ uip_db }}
	
	{% if not loop.last -%} union all {%- endif %}
	
	{% endfor %}
)

select * from final_table