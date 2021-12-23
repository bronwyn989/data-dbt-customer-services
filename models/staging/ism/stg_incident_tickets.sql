with 

Incident as (

SELECT 
	'Incident' [Ticket Type],
	'ISM Ticket' as [Contact Type],
	IncidentNumber	[Ticket Number],
	Source [Source],
	CreatedDateTime [Ticket Created Date Time], 
	[ResolvedDateTime] [Resolved By Date Time], 
	[LastModDateTime] [Last Modified Date Time],
	convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,CreatedDateTime))))) AS [Created Date],
	convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,ResolvedDateTime))))) [Resolved Date],
	Status [Ticket Status], 
	Company,
	Service [Service], 
	Category, 
	isnull(SubCategory,'Not Assigned') as  SubCategory,
	OwnerTeam [Owner Team], 
	Environment,
	datediff(dd,CreatedDateTime, [ResolvedDateTime]) AS [Resolved Days],
	datediff(dd,CreatedDateTime, getdate()) as [Open Days]
FROM {{ source('ism_tickets', 'vwIncident') }} (NOLOCK) 

),

final_table as (

	select * from Incident
	
)

select * from final_table