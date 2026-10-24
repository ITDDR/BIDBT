select
    c.idClient,
    c.provenance,
    c.operation_partenariat,
    c.idClient_chefFamille,
    c.creation_date,
    c.provenance_chef_famille,
    date_operation_partenariat,
    charge_de_dev,
    cpc.date_premiere_facture

from {{ ref('int_clients') }} as c
left join {{ ref('client_premiere_facture') }} as cpc on cpc.idClient = c.idClient

