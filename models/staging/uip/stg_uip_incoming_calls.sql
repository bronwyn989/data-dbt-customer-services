{% set uip_dbs = ["uip_old", "uip_new"] %}

with 

{% for uip_db in uip_dbs %}

{{ uip_db }} as (

SELECT 
	[CallStartDt] [Call Start Date Time]
	,[SeqNum]	
	,Service_Id
	,AgentDispId as DispId
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
	,case when [CallEndDt] <> [QueueEndDt] then 1
		else 0
		end				as [Flag Answered]
	,case when [CallEndDt] <> [QueueEndDt] then 'Answered'
		else 'Not Answered'
		end				as [Is Answered]
	,convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,[CallEndDt]))))) AS DateKey,
    'Inbound UIP Call' as [Contact Type],
	'Inbound Call' as [Call Type] ,
	'{{ uip_db }}' 	as DatabaseSource                     
FROM {{ source(uip_db, 'ACDCallDetail') }} (NOLOCK) 

),

{% endfor %}

final_table as (

	{% for uip_db in uip_dbs %}
	
	select * from {{ uip_db }}
	
	{% if not loop.last -%} union all {%- endif %}
	
	{% endfor %}
)

select * from final_table