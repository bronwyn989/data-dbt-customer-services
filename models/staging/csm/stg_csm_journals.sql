with 
stg_csm_journals as (

select parentlink_recid, 
        count(*) as 'IncomingEmails'
from  {{ source('csm_tickets', 'vwJournal') }} (nolock) 
where parentlink_Category = 'reputation' and journaltype = 'email' and category = 'incoming email' 
group by parentlink_recid

),

final_table as (
	select * from stg_csm_journals
)

select * from final_table