with 

source as (

    select * from {{ source('optimum', 'clients') }}

)

select
    client_id as idClient,
    client_origin as provenance,
    family_name as nomFamille,
    family_chief_client_id as idClient_chefFamille,
    cast(creation_datetime as date) as creation_date,
    extract(year from creation_datetime) as annee_creation,
    extract(month from creation_datetime) as mois_creation,
    update_datetime,
    export_date
from source