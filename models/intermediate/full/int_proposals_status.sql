 select
        proposal_status_id,
        proposal_status_name,
        proposal_status_description
from {{ ref('stg_optimum__proposals_status') }}