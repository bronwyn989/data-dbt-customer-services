{% macro set_ticket_id_column(ticket_type) %}

{% if ticket_type == 'Service_Request'%}
    {{return ('ServiceReqNumber') }}

{% elif ticket_type == 'Problem'%}
    {{ return ('ProblemNumber') }}

{% elif ticket_type == 'Incident'%}
    {{ return ('IncidentNumber')}}
{% endif %}

{% endmacro %}