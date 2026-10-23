with 

source as (

    select * from {{ source('optimum', 'visits') }}

)

select
    visit_id,
    client_id as idClient,
    shop_id as idMagasin,
    seller_id,
    cast(creation_datetime as date) as date_creation_visite,
    update_datetime,
    export_date
from source