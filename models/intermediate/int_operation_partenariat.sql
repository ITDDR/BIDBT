-- The single place that computes operation-partenariat data: one row per
-- distinct (operation_partenariat, provenance) combination, from clients
-- whose own provenance belongs to the "PARTENARIAT" acquisition channel
-- group. date_operation_partenariat is parsed from the name itself (trailing
-- YY_MM, e.g. "MH92 PARIS 26_09" -> 2026-09-01). charge_de_dev is the
-- first name extracted from provenance when it starts with "Zz_ Contrat"
-- (e.g. "Zz_ Contrat Coline" -> "Coline").
-- Everything downstream (the clients dimension, the operations_partenariat
-- dimension, baseOp/baseOpWithProposals) joins back to this instead of
-- recomputing any of it.
with partenariat_clients as (

    select distinct
        idClient,
        c.operation_partenariat,
        c.provenance_chef_famille,
        ville,
        date_operation_partenariat,
        charge_de_dev

    from {{ ref('int_clients') }} as c
    inner join {{ ref('stg_gsheets__canaux_acquisition') }} as ca
        on c.provenance_chef_famille = ca.provenance
    where upper(ca.famille_canal) = 'PARTENARIAT'
        and c.operation_partenariat is not null
        and provenance_chef_famille is not null
        and starts_with(provenance_chef_famille, 'Zz_')
        and idClient = IdClient_chefFamille

),
withCount as 
(
select distinct
    operation_partenariat,
    provenance_chef_famille as provenance,
    ville,
    date_operation_partenariat,
    charge_de_dev,
    (select count(*) from {{ ref('int_clients') }} c where c.idClient_ChefFamille = partenariat_clients.idClient) as cntClient
from partenariat_clients
)

select * from withCount
where cntClient >1

