with 

source as (

    select * from {{ source('optimum', 'proposals') }}

)

select
    proposal_id,
    visit_id,
    proposals_status_id as proposal_status_id,
    update_datetime
from source