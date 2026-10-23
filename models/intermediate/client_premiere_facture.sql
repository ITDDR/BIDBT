select
    idClient,
    min(date_creation_facture) as date_premiere_facture
from {{ ref('int_factures') }}
group by idClient