with 

source as (

    select * from {{ source('optimum', 'clients') }}

)

select
    client_id as idClient,
    client_origin as provenance,
    family_name,
    case
        when regexp_contains(family_name, r'[0-9]{2}_[0-9]{2}') then family_name
        else null
    end as operation_partenariat,
    family_chief_client_id as idClient_chefFamille,
    cast(creation_datetime as date) as creation_date,
    city as ville,
    update_datetime,
    export_date
from source