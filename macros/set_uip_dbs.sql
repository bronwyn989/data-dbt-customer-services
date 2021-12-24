--returns a dictionary with 
-- 1. the uip databases to loop through (currently uip old and new, 
--      may want to just load new and store the transformed old tables to be concatenated)
-- 2. the ecommerce service ids for loading in the outgoing calls


{% macro set_uip_dbs() %}
    {{ return([{'db': 'uip_old', 'services': '31,32'}, {'db': 'uip_new', 'services': '54,8'}]) }}
{% endmacro %}