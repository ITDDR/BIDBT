select
    c.idClient,
    c.provenance,
    c.nomFamille,
    c.operation_partenariat,
    c.date_creation,
    c.provenance_chef_famille,
    charge_de_dev,
    cpc.date_premiere_facture

from {{ ref('int_clients') }} as c
left join {{ ref('client_premiere_facture') }} as cpc on cpc.idClient = c.idClient

