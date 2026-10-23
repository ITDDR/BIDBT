 select
        proposal_status_id,
        proposal_status,
        definition_statut_proposition
from {{ ref('stg_optimum__proposals_status') }}