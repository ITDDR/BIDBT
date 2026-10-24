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
        clients.operation_partenariat as nomFamille,
        clients.provenance,
        clients.creation_date

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
    from {{ ref('int_factures') }}

),

family_invoices_agg as (

    select
        clients.idClient_chefFamille,
        count(distinct invoices.facture_id) as nb_factures_famille

    from clients
    inner join invoices
        on clients.idClient = invoices.idClient
    where clients.idClient_chefFamille is not null

    group by clients.idClient_chefFamille

),

family_month_invoice_counts as (

    select
        chefs_partenariat.idClient_chefFamille,
        format_date('%Y-%m', invoices.date_creation_facture) as mois_facture,
        count(distinct invoices.facture_id) as nb_factures_mois,
        count(distinct if(
            invoices.date_creation_facture < chefs_partenariat.creation_date,
            invoices.facture_id,
            null
        )) as nb_factures_mois_avant_creation

    from chefs_partenariat
    inner join clients
        on chefs_partenariat.idClient_chefFamille = clients.idClient_chefFamille
    inner join invoices
        on clients.idClient = invoices.idClient

    group by chefs_partenariat.idClient_chefFamille, mois_facture

),

family_months_agg as (

    select
        idClient_chefFamille,
        string_agg(
            mois_facture || ' (' || cast(nb_factures_mois as string) || ')',
            ', '
            order by mois_facture
        ) as mois_factures_famille,
        sum(nb_factures_mois_avant_creation) as nb_factures_avant_creation_chef,
        string_agg(
            if(
                nb_factures_mois_avant_creation > 0,
                mois_facture || ' (' || cast(nb_factures_mois_avant_creation as string) || ')',
                null
            ),
            ', '
            order by mois_facture
        ) as mois_factures_avant_creation_chef

    from family_month_invoice_counts
    group by idClient_chefFamille

),

invoice_lines as (

    select *
    from {{ ref('int_factures_extended') }}

),

family_ca_agg as (

    select
        chefs_partenariat.idClient_chefFamille,
        sum(
            invoice_lines.prix_vente_remise_ttc / (1 + invoice_lines.taux_tva / 100)
            * abs(invoice_lines.quantite_produit)
        ) as ca_ht_apres_creation_chef

    from chefs_partenariat
    inner join clients
        on chefs_partenariat.idClient_chefFamille = clients.idClient_chefFamille
    inner join invoice_lines
        on clients.idClient = invoice_lines.idClient
    where invoice_lines.date_creation_facture >= chefs_partenariat.creation_date

    group by chefs_partenariat.idClient_chefFamille

)

select
    chefs_partenariat.nomFamille,
    chefs_partenariat.idClient_chefFamille,
    chefs_partenariat.provenance as provenance_chef,
    coalesce(members_agg.nb_membres_famille, 0) as nb_membres_famille,
    members_agg.provenances_membres,
    coalesce(family_invoices_agg.nb_factures_famille, 0) as nb_factures_famille,
    family_months_agg.mois_factures_famille,
    coalesce(family_months_agg.nb_factures_avant_creation_chef, 0) as nb_factures_avant_creation_chef,
    family_months_agg.mois_factures_avant_creation_chef,
    coalesce(family_ca_agg.ca_ht_apres_creation_chef, 0) as ca_ht_apres_creation_chef

from chefs_partenariat
left join members_agg
    on chefs_partenariat.idClient_chefFamille = members_agg.idClient_chefFamille
left join family_invoices_agg
    on chefs_partenariat.idClient_chefFamille = family_invoices_agg.idClient_chefFamille
left join family_months_agg
    on chefs_partenariat.idClient_chefFamille = family_months_agg.idClient_chefFamille
left join family_ca_agg
    on chefs_partenariat.idClient_chefFamille = family_ca_agg.idClient_chefFamille
