with 
fuse_tickets as (

SELECT 
	convert(varchar,[Ticket Number]) + '|' + [Contact Type] as [EventLink],
	[Contact Type],
	[Ticket Type], 
	[Ticket Number],
	[Source],
	[Ticket Created Date Time], 
	[Resolved By Date Time], 
	[Created Date],
	[Resolved Date],
	[Ticket Status], 
	Company,
	[Service], 
	Category, 
	SubCategory,
	[Owner Team], 
	[Open Days],
	case when [Open Days] = 0 then '< 24 Hours'
		 when [Open Days] = 1 then '1 Day'
		 when [Open Days] = 2 then '2 Days'
		 when [Open Days] = 3 then '3 Days'
		 when [Open Days] >3 and [Open Days] <10 then '4 - 10 Days'
		 when [Open Days] >=10 and [Open Days] <21 then '10 - 20 Days'
		 when [Open Days] >=21 and [Open Days] <42 then '21 - 42 Days'
		 else '> 42 Days' end as [Open Days Age],	
	case when [Open Days] = 0 then 1
		 when [Open Days] = 1 then 2
		 when [Open Days] = 2 then 3
		 when [Open Days] = 3 then 4
		 when [Open Days] >3 and [Open Days] <10 then 5
		 when [Open Days] >=10 and [Open Days] <21 then 6
		 when [Open Days] >=21 and [Open Days] <42 then 7
		 else 8 end as [Open Days Age Sort],
	[Resolved Days]
FROM {{ref('stg_fuse_tickets')}} (NOLOCK) 

),

final_table as (
	select * from fuse_tickets
)

select * from final_table