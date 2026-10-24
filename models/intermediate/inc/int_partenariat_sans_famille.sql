with clients as (

    select *
    from {{ ref('int_clients') }}

),

canaux_acquisition as (

    select *
    from {{ ref('stg_gsheets__canaux_acquisition') }}

),

clients_partenariat as (

    select
        clients.idClient,
        clients.nomFamille,
        clients.provenance,
        clients.date_creation

    from clients
    inner join canaux_acquisition
        on clients.provenance = canaux_acquisition.provenance
    where clients.idClient_chefFamille is null
        and upper(canaux_acquisition.famille_canal) = 'PARTENARIAT'

),

invoices as (

    select *
    from {{ ref('int_factures') }}

),

factures_agg as (

    select
        idClient,
        count(distinct facture_id) as nb_factures

    from invoices
    group by idClient

),

client_month_invoice_counts as (

    select
        clients_partenariat.idClient,
        format_date('%Y-%m', invoices.date_creation_facture) as mois_facture,
        count(distinct invoices.facture_id) as nb_factures_mois,
        count(distinct if(
            invoices.date_creation_facture < clients_partenariat.date_creation,
            invoices.facture_id,
            null
        )) as nb_factures_mois_avant_creation

    from clients_partenariat
    inner join invoices
        on clients_partenariat.idClient = invoices.idClient

    group by clients_partenariat.idClient, mois_facture

),

client_months_agg as (

    select
        idClient,
        string_agg(
            mois_facture || ' (' || cast(nb_factures_mois as string) || ')',
            ', '
            order by mois_facture
        ) as mois_factures,
        sum(nb_factures_mois_avant_creation) as nb_factures_avant_creation,
        string_agg(
            if(
                nb_factures_mois_avant_creation > 0,
                mois_facture || ' (' || cast(nb_factures_mois_avant_creation as string) || ')',
                null
            ),
            ', '
            order by mois_facture
        ) as mois_factures_avant_creation

    from client_month_invoice_counts
    group by idClient

),

invoice_lines as (

    select *
    from {{ ref('int_factures_extended') }}

),

client_ca_agg as (

    select
        clients_partenariat.idClient,
        sum(
            invoice_lines.prix_vente_remise_ttc / (1 + invoice_lines.taux_tva / 100)
            * abs(invoice_lines.quantite_produit)
        ) as ca_ht_apres_creation

    from clients_partenariat
    inner join invoice_lines
        on clients_partenariat.idClient = invoice_lines.idClient
    where invoice_lines.date_creation_facture >= clients_partenariat.date_creation

    group by clients_partenariat.idClient

)

select
    clients_partenariat.idClient,
    clients_partenariat.nomFamille,
    clients_partenariat.provenance,
    coalesce(factures_agg.nb_factures, 0) as nb_factures,
    client_months_agg.mois_factures,
    coalesce(client_months_agg.nb_factures_avant_creation, 0) as nb_factures_avant_creation,
    client_months_agg.mois_factures_avant_creation,
    coalesce(client_ca_agg.ca_ht_apres_creation, 0) as ca_ht_apres_creation

from clients_partenariat
left join factures_agg
    on clients_partenariat.idClient = factures_agg.idClient
left join client_months_agg
    on clients_partenariat.idClient = client_months_agg.idClient
left join client_ca_agg
    on clients_partenariat.idClient = client_ca_agg.idClient
