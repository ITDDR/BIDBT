-- The shared conformed dimension that client and baseOp/baseOpWithProposals
-- both relate to independently (on operation_partenariat), so they can be
-- filtered together without a direct relationship between them. All the
-- actual computation lives in int_operation_partenariat; this is a plain
-- passthrough.
select
    operation_partenariat,
    ville,
    provenance,
    date_operation_partenariat,
    charge_de_dev,
    cntClient
from {{ ref('int_operation_partenariat') }}
