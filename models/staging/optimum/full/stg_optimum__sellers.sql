with source as (
    select * from {{ source('optimum', 'sellers') }}
)

select
    seller_id,
    concat(last_name, ' ',first_name) as nom_vendeur
from source