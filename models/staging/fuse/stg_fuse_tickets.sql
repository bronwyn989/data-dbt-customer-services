with 
stg_fuse_tickets as (

SELECT 
	'Fuse Ticket' as [Contact Type],
	BusinessUnit [Ticket Type], 
	RefNumber [Ticket Number],
	Source [Source],
	CreatedDateTime [Ticket Created Date Time], 
	[ResolvedOnDateTime] [Resolved By Date Time],
	convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,CreatedDateTime))))) AS [Created Date],
	convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,ResolvedOnDateTime))))) [Resolved Date],
	Status [Ticket Status], 
	Company,
	Service [Service], 
	Category, 
	isnull(SubCategory,'Not Assigned') as  SubCategory,
	OwnerTeam [Owner Team], 
	datediff(dd,CreatedDateTime, getdate()) as [Open Days],
	datediff(dd,CreatedDateTime, ResolvedOnDateTime) AS [Resolved Days]
FROM {{ source('fuse_tickets', 'vwFuseServices') }}  (NOLOCK) 

),

final_table as (
	select * from stg_fuse_tickets
)

select * from final_table