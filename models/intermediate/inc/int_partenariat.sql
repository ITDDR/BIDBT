with clients as (

    select *
    from {{ ref('int_clients') }}

),

canaux_acquisition as (

    select *
    from {{ ref('stg_gsheets__canaux_acquisition') }}

),

chefs_partenariat as (

    select
        clients.idClient_chefFamille,
        clients.nomFamille,
        clients.provenance,
        clients.creation_datetime

    from clients
    inner join canaux_acquisition
        on clients.provenance = canaux_acquisition.provenance
    where clients.idClient = clients.idClient_chefFamille
        and upper(canaux_acquisition.famille_canal) = 'PARTENARIAT'

),

member_provenance_counts as (

    select
        idClient_chefFamille,
        coalesce(provenance, 'NULL') as provenance,
        count(*) as nb_clients_provenance

    from clients
    where idClient_chefFamille is not null
        and idClient_chefFamille != idClient

    group by idClient_chefFamille, provenance

),

members_agg as (

    select
        idClient_chefFamille,
        sum(nb_clients_provenance) as nb_membres_famille,
        string_agg(
            provenance || ' (' || cast(nb_clients_provenance as string) || ')',
            ', '
            order by nb_clients_provenance desc
        ) as provenances_membres

    from member_provenance_counts
    group by idClient_chefFamille

),

invoices as (

    select *
    from {{ ref('int_client_invoices') }}

),

shops as (

    select *
    from {{ ref('int_shops') }}

),

family_shop_invoice_counts as (

    select
        clients.idClient_chefFamille,
        coalesce(cast(shops.shop_id as string), 'NULL') as shop_id,
        count(distinct invoices.client_invoice_id) as nb_factures_magasin

    from clients
    inner join invoices
        on clients.idClient = invoices.idClient
    left join shops
        on invoices.shop_id = shops.shop_id
    where clients.idClient_chefFamille is not null

    group by clients.idClient_chefFamille, shops.shop_id

),

family_invoices_agg as (

    select
        idClient_chefFamille,
        sum(nb_factures_magasin) as nb_factures_famille,
        string_agg(
            shop_id || ' (' || cast(nb_factures_magasin as string) || ')',
            ', '
            order by nb_factures_magasin desc
        ) as magasins_factures_famille

    from family_shop_invoice_counts
    group by idClient_chefFamille

)

select
    extract(year from chefs_partenariat.creation_datetime) as annee_creation,
    extract(month from chefs_partenariat.creation_datetime) as mois_creation,
    chefs_partenariat.nomFamille,
    chefs_partenariat.idClient_chefFamille,
    chefs_partenariat.provenance as provenance_chef,
    coalesce(members_agg.nb_membres_famille, 0) as nb_membres_famille,
    members_agg.provenances_membres,
    coalesce(family_invoices_agg.nb_factures_famille, 0) as nb_factures_famille,
    family_invoices_agg.magasins_factures_famille

from chefs_partenariat
left join members_agg
    on chefs_partenariat.idClient_chefFamille = members_agg.idClient_chefFamille
left join family_invoices_agg
    on chefs_partenariat.idClient_chefFamille = family_invoices_agg.idClient_chefFamille
