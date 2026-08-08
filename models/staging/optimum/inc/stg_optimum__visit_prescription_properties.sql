with

source as (

    select * from {{ source('optimum', 'visit_prescription_properties') }}

)

select
    visit_id,
    prescriptor_id,
    update_datetime
from source
