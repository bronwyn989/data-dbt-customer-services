with 

csm_tickets as (

SELECT 	
	[Ticket Number], 
	EventLink,
	[Contact Type],
	[Ticket Type],
	[Source],
	[Ticket Created Date Time], 
	[Resolved By Date Time], 
	[Ticket Status], 
	Company,
	[Service], 
	Category, 
	SubCategory,
	[Owner Team], 
	[Owner],
	[Brand],
	NULL AS [Environment],
	[Response Days],
	[Resolved Days],
	[Open Days],
	[Open Days Age],	
	[Open Days Age Sort],
	[Flag <24 Hours Resolved],
	[Flag <2 Hours Responded],
	[Incoming Emails]
	
FROM {{ ref('fct_csm_tickets') }} i (NOLOCK) 

),

ism_tickets as (

SELECT 	
	[Ticket Number], 
	EventLink,
	[Contact Type],
	[Ticket Type],
	[Source],
	[Ticket Created Date Time], 
	[Resolved By Date Time], 
	[Ticket Status], 
	Company,
	[Service], 
	Category, 
	SubCategory,
	[Owner Team], 
	NULL AS [Owner],
	NULL AS [Brand],
	[Environment],
	NULL AS [Response Days],
	[Resolved Days],
	[Open Days],
	[Open Days Age],	
	[Open Days Age Sort],
	NULL AS [Flag <24 Hours Resolved],
	NULL AS [Flag <2 Hours Responded],
	NULL AS [Incoming Emails]
	
FROM {{ ref('fct_ism_tickets') }} i (NOLOCK) 

),



final_table as (
		
	select * from csm_tickets
	
	union all 

	select * from ism_tickets

)

select * from final_table