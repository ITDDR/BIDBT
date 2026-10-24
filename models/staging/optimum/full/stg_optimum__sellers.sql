with source as (
    select * from {{ source('optimum', 'sellers') }}
)

select
    seller_id,
    concat(coalesce(last_name, ''), ' ', coalesce(first_name, '')) as nom_vendeur
from source