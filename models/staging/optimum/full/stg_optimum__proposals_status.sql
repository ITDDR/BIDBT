with source as (
    select * from {{ source('optimum', 'proposals_status') }}
)

select
    proposal_status_id,
    proposal_status_name as proposal_status,
    proposal_status_description as definition_statut_proposition
from source