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
        clients.provenance,
        clients.creation_datetime

    from clients
    inner join canaux_acquisition
        on clients.provenance = canaux_acquisition.provenance
    where clients.idClient_chefFamille is null
        and upper(canaux_acquisition.famille_canal) = 'PARTENARIAT'

),

invoices as (

    select *
    from {{ ref('int_client_invoices') }}

),

shops as (

    select *
    from {{ ref('int_shops') }}

),

client_shop_invoice_counts as (

    select
        invoices.idClient,
        coalesce(cast(shops.shop_id as string), 'NULL') as shop_id,
        count(distinct invoices.client_invoice_id) as nb_factures_magasin

    from invoices
    left join shops
        on invoices.shop_id = shops.shop_id

    group by invoices.idClient, shops.shop_id

),

client_invoices_agg as (

    select
        idClient,
        sum(nb_factures_magasin) as nb_factures,
        string_agg(
            shop_id || ' (' || cast(nb_factures_magasin as string) || ')',
            ', '
            order by nb_factures_magasin desc
        ) as magasins_factures

    from client_shop_invoice_counts
    group by idClient

)

select
    extract(year from clients_partenariat.creation_datetime) as annee_creation,
    extract(month from clients_partenariat.creation_datetime) as mois_creation,
    clients_partenariat.idClient,
    clients_partenariat.provenance,
    coalesce(client_invoices_agg.nb_factures, 0) as nb_factures,
    client_invoices_agg.magasins_factures

from clients_partenariat
left join client_invoices_agg
    on clients_partenariat.idClient = client_invoices_agg.idClient
