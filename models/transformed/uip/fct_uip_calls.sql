{% set calltypes = ["stg_uip_incoming_calls", "stg_uip_outgoing_calls"] %}

with 

{% for calltype in calltypes %}

{{ calltype }} as (

SELECT  t1.[Call Start Date Time]
		,t1.[SeqNum]	
		,t1.[UIP Agent]
		,t1.[Queue Start Date Time]
		,t1.[Queue End Date Time]
		,t1.[Queue Time Seconds]
		,t1.[Call Time Seconds]
		,t1.[Answered within SLA]
		,t1.[Caller ID]
		,t1.[Call End Date Time]
		,[Call Action]
		,[Call Action Reason]
		,[Service]
		,t1.[Flag Answered]
		,t1.[Is Answered]
		,t5.[SubCategory]
		,t1.DateKey,
        ,t1.[Contact Type]
	    ,t1.[Call Type]
FROM {{ref(calltype)}} t1 with (NOLOCK)
inner join {{ref('stg_uip_call_action_reason')}} t2 (NOLOCK) on t1.[CallActionReasonId] =t2.[CallActionReasonId] and t1.DatabaseSource = t2.DatabaseSource
inner join {{ref('stg_uip_call_action')}} t3 (NOLOCK) on t1.[CallActionId] =t3.[CallActionId] and t1.DatabaseSource = t3.DatabaseSource
inner join {{ref('stg_uip_service')}} t4 (NOLOCK) on t1.[Service_Id] =t4.[Service_Id] and t1.DatabaseSource = t4.DatabaseSource
left outer join {{ref('stg_uip_disposition')}} t5 (NOLOCK) on t1.[Disp_Id] =t5.[Disp_Id] and t1.DatabaseSource = t5.DatabaseSource

),

{% endfor %}

final_table as (

	{% for calltype in calltypes %}
	
	select * from {{ calltype }}
	
	{% if not loop.last -%} union all {%- endif %}
	
	{% endfor %}
)

select * from final_table