{% set db_dictionary = [{'db': 'uip_old', 'services': '31,32'}, {'db': 'uip_new', 'services': '54,8'}]  %}

with 

{% for dict_item in db_dictionary %}

{{ dict_item['db'] }} as (

SELECT 
	[CallStartDt] [Call Start Date Time]
	,[SeqNum]	
	,Service_Id
	,Disp_Id
	,CallActionId
	,CallActionReasonId
	,[User_Id] [UIP Agent]
	,null [Queue Start Date Time]
	,null [Queue End Date Time]
	,null [Queue Time Seconds]
	,convert(float,(CONVERT(DATETIME,[CallEndDt])-CONVERT(DATETIME,[CallStartDt])))*24*60*60	as [Call Time Seconds]
	,null [Answered within SLA]
	,null [Caller ID]
	,[CallEndDt] [Call End Date Time]
	,case when [CallEndDt] <> [CallStartDt] then 1
		else 0
		end				as [Flag Answered]
	,case when [CallEndDt] <> [CallStartDt] then 'Answered'
		else 'Not Answered'
		end				as [Is Answered]
	,convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,[CallEndDt]))))) AS DateKey,
    'Outbound UIP Call' as [Contact Type],
	'Outbound Call' as [Call Type],
	'{{ dict_item["db"] }}' as DatabaseSource                       
FROM {{ source(dict_item['db'], 'AgentDispoDetail') }} (NOLOCK) 
where WorkGroup_Id=16 and CallTypeId=9 and Service_Id in ({{ dict_item['services'] }})

),

{% endfor %}

final_table as (

	{% for dict_item in db_dictionary %}
	
	select * from {{ dict_item['db'] }}
	
	{% if not loop.last -%} union all {%- endif %}
	
	{% endfor %}
)

select * from final_table