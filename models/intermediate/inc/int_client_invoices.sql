with source as (

    select *
    from {{ ref('stg_optimum__clients_invoices') }}

),

ranked as (

    select
        client_invoice_id,
        no_facture,
        client_id,
        client_invoice_creation_date,
        update_datetime,
        items_number,
        shop_id,

        row_number() over (
            partition by client_invoice_id
            order by update_datetime desc
        ) as row_num

    from source

)

select
    client_invoice_id,
    no_facture,
    client_id,
    client_invoice_creation_date,
    update_datetime,
    items_number,
    shop_id
from ranked
where row_num = 1
