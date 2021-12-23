with 
stg_csm_tickets as (

SELECT Recid,
	'CSM Ticket' as [Contact Type],
	i.ReputationType [Ticket Type], 
	i.ReputationNumber [Ticket Number],
	i.Source [Source],
	i.CreatedDateTime [Ticket Created Date Time], 
	i.[ResolvedByDateTime] [Resolved By Date Time], 
	i.RespondedByDateTime [Responded By Date Time],
	convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,CreatedDateTime))))) AS [Created Date],
	convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,ResolvedByDateTime))))) [Resolved Date],
	i.Status [Ticket Status], 
	i.Company,
	i.Service [Service], 
	i.Category, 
	isnull(i.SubCategory,'Not Assigned') as  SubCategory,
	i.OwnerTeam [Owner Team], 
	i.Brand,
	isnull(i.[Owner],'Not Assigned') as [Owner], 
	datediff(dd,i.CreatedDateTime, getdate()) as [Open Days],
	datediff(dd,CreatedDateTime, RespondedByDateTime) AS [Response Days],
	datediff(dd,CreatedDateTime, ResolvedByDateTime) AS [Resolved Days],
	case when datediff(dd,CreatedDateTime, ResolvedByDateTime) =0 then 1 else 0 end as [Flag <24 Hours Resolved],
	case when datediff(hour,CreatedDateTime,RespondedByDateTime) <3 then 1 else 0 end as [Flag <2 Hours Responded]
FROM {{ source('csm_tickets', 'vwReputation') }} i (NOLOCK) 

),

final as (
	select * from stg_csm_tickets
)

select * from final