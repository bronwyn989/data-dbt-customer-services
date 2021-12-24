## Customer Services Project:
#### Original Author: Bronwyn Smith
#### Created using DBT

This project transforms the data needed for Customer Services analysis.

This includes data from:
- CSM Tickets (customer tickets)
- ISM Tickets (internal tickets) 
- UIP Call Centre (call data, currently there is a current db and a historical db)
- Fuse Tickets (HR tickets)

Currently the data is being sync'd to EDW and then transformed ready for analysis.

***

### Current Analysis Ready Datasets are:

#### CSM:
- models/transformed/csm/fct_csm_tickets 
- models/transformed/csm/fct_csm_events

#### ISM:
- models/transformed/ism/fct_ism_tickets
- models/transformed/ism/fct_ism_events

#### Fuse:
- models/transformed/ism/fct_fuse_tickets
- models/transformed/ism/fct_fuse_events

#### Combined: (currently CSM, ISM and Fuse Tickets)
- models/transformed/combined/fct_combined_tickets
- models/transformed/combined/fct_combined_events


***


### DBT Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
