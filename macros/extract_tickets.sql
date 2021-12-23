{% macro extract_tickets(ticket_type,id_field,table_name) %}

{% set extract_tickets_query %}
SELECT 
	'{{ticket_type}}' [ISM Ticket Type],
	{{id_field}}	[Ticket Number],
	Source [ISM Source],
	CreatedDateTime [Ticket Created Date Time], 
	[ResolvedDateTime] [Resolved By Date Time], 
	[LastModDateTime] [Last Modified Date Time],
	convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,CreatedDateTime))))) AS [Created DateKey],
	'2021-01-01 00:00:00'  AS   [Open DateKey],
	convert(DATETIME,floor(convert(float,(CONVERT(DATETIME,ResolvedDateTime))))) [Resolved DateKey],
	Status [Ticket Status], 
	Company,
	Service [ISM Service], 
	Category, 
	isnull(SubCategory,'Not Assigned') as  SubCategory,
	OwnerTeam [Owner Team], 
	Environment,
	datediff(dd,CreatedDateTime, i.[ResolvedDateTime]) AS [Resolved Days],
	datediff(dd,CreatedDateTime, getdate()) as [Open Days],
	case when datediff(dd,CreatedDateTime, getdate()) = 0 then '< 24 Hours'
		 when datediff(dd,CreatedDateTime, getdate()) = 1 then '1 Day'
		 when datediff(dd,CreatedDateTime, getdate()) = 2 then '2 Days'
		 when datediff(dd,CreatedDateTime, getdate()) = 3 then '3 Days'
		 when datediff(dd,CreatedDateTime, getdate()) >3 and datediff(dd,CreatedDateTime, getdate()) <10 then '4 - 10 Days'
		 when datediff(dd,CreatedDateTime, getdate()) >=10 and datediff(dd,CreatedDateTime, getdate()) <21 then '10 - 20 Days'
		 when datediff(dd,CreatedDateTime, getdate()) >=21 and datediff(dd,CreatedDateTime, getdate()) <42 then '21 - 42 Days'
		 else '> 42 Days' end as [Open Days Age],	
	case when datediff(dd,CreatedDateTime, getdate()) = 0 then 1
		 when datediff(dd,CreatedDateTime, getdate()) = 1 then 2
		 when datediff(dd,CreatedDateTime, getdate()) = 2 then 3
		 when datediff(dd,CreatedDateTime, getdate()) = 3 then 4
		 when datediff(dd,CreatedDateTime, getdate()) >3 and datediff(dd,CreatedDateTime, getdate()) <10 then 5
		 when datediff(dd,CreatedDateTime, getdate()) >=10 and datediff(dd,CreatedDateTime, getdate()) <21 then 6
		 when datediff(dd,CreatedDateTime, getdate()) >=21 and datediff(dd,CreatedDateTime, getdate()) <42 then 7
		 else 8 end as [Open Days Age Sort]
FROM {{"DW_DATAHUB_SMDB.HEAT_Rep_polybase."~table_name}} i (NOLOCK) 
{% endset %}


{% do run_query(extract_tickets_query) %}

{% endmacro %}