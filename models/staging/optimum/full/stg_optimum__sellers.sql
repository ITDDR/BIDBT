with source as (
    select * from {{ source('optimum', 'sellers') }}
)

select
    seller_id,
    shop_id,
    last_name,
    first_name,
    concat(last_name, ' ',first_name) as seller_name
from source