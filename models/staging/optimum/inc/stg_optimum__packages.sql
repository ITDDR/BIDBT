with 

source as (

    select * from {{ source('optimum', 'packages') }}

)

select
    package_id,
    package_status_id,
    proposal_id,
    cast(creation_datetime as date) as package_creation_date,
    update_datetime,
    to_review_sale_offer
from source