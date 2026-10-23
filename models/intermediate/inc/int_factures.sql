with source as (

    select *
    from {{ ref('stg_optimum__clients_invoices') }}

),

ranked as (

    select
        client_invoice_id as facture_id,
        no_facture,
        idClient,
        client_invoice_creation_date as date_creation_facture,
        update_datetime,
        idMagasin,

        row_number() over (
            partition by client_invoice_id
            order by update_datetime desc, export_date desc
        ) as row_num

    from source

)

select
    facture_id,
    no_facture,
    idClient,
    date_creation_facture,
    update_datetime,
    idMagasin
from ranked
where row_num = 1
