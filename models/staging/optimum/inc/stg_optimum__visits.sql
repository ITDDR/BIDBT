with 

source as (

    select * from {{ source('optimum', 'visits') }}

)

select
    visit_id,
    seller_id,
    cast(creation_datetime as date) as visit_creation_date,
    update_datetime
from source