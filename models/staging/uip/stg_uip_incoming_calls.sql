{% set db_dictionary = set_uip_dbs() -%}

with 

{% for dict_item in db_dictionary %}

{{ dict_item['db'] }} as (

SELECT 
	[CallStartDt] [Call Start Date Time]
	,[SeqNum]	
	,Service_Id
	,AgentDispId as Disp_Id
	,CallActionId
	,CallActionReasonId
	,[User_Id] [UIP Agent]
	,[QueueStartDt] [Queue Start Date Time]
	,[QueueEndDt] [Queue End Date Time]
	,ISNULL(convert(float,(CONVERT(DATETIME,[QueueEndDt])-CONVERT(DATETIME,[QueueStartDt])))*24*60*60,0) as [Queue Time Seconds]
	,convert(float,(CONVERT(DATETIME,[CallEndDt])-CONVERT(DATETIME,[CallStartDt])))*24*60*60	as [Call Time Seconds]
	,case when ISNULL(convert(float,(CONVERT(DATETIME,[QueueEndDt])-CONVERT(DATETIME,[QueueStartDt])))*24*60*60,0)<=20 then 'Yes' else 'No' end as [Answered within SLA]
	,[CallerId] [Caller ID]
	,[CallEndDt] [Call End Date Time]
	, IIF([CallEndDt] <> [CallStartDt], 1, 0) 	as [Flag Answered]
	,IIF([CallEndDt] <> [CallStartDt], 'Answered', 'Not Answered') 			as [Is Answered]
	,convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,[CallEndDt]))))) AS DateKey,
    'Inbound UIP Call' as [Contact Type],
	'Inbound Call' as [Call Type] ,
	'{{ dict_item["db"] }}' 	as DatabaseSource                     
FROM {{ source(dict_item['db'] , 'ACDCallDetail') }} (NOLOCK) 

),

{% endfor %}

final_table as (

	{% for dict_item in db_dictionary %}
	
	select * from {{ dict_item['db'] }}
	
	{% if not loop.last -%} union all {%- endif %}
	
	{% endfor %}
)

select * from final_table