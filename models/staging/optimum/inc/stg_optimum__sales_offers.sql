with 

source as (

    select * from {{ source('optimum', 'sales_offers') }}

)

select
    sale_offer_id,
    sale_offer_name,
    update_datetime
from source