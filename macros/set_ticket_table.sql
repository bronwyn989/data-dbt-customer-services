{% macro set_ticket_table(ticket_type) %}

{% if ticket_type == 'Service_Request' %}
    {{return ( source('ism_tickets', 'vwServiceReq')  )}}

{% elif ticket_type == 'Problem' %}
    {{return ( source('ism_tickets', 'vwProblem')  )}}

{% elif ticket_type == 'Incident' %}
    {{return ( source('ism_tickets', 'vwIncident')  )}}

{% endif %}

{% endmacro %}