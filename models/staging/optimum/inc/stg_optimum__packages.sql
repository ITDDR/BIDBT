with 

source as (

    select * from {{ source('optimum', 'packages') }}

)

select
    package_id,
    package_status_id,
    proposal_id,
    visit_id,
    cast(creation_datetime as date) as date_creation_package,
    update_datetime,
    export_date,
    to_review_sale_offer
from source