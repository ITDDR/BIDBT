with 

source as (

    select * from {{ source('optimum', 'clients') }}

)

select
    client_id as idClient,
    client_origin as provenance,
    case 
        when REGEXP_CONTAINS(upper(last_name), 'VENTE_LIBRE') or
             (REGEXP_CONTAINS(upper(last_name), 'VENTE') and REGEXP_CONTAINS(upper(first_name), 'DIRECTE'))
        then 1
        else 0
    end as client_vente_directe,
    case 
        when REGEXP_CONTAINS(upper(last_name), 'FACING') 
        then 1
        else 0
    end as client_facing_fixe,
    update_datetime
from source