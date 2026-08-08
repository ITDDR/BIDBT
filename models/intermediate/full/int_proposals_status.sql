 select
        proposal_status_id,
        proposal_status,
        proposal_status_definition
from {{ ref('stg_optimum__proposals_status') }}