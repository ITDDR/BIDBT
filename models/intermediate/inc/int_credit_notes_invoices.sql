with source as (

    select *
    from {{ ref('stg_optimum__credit_notes_invoices') }}

),

ranked as (

    select
        credit_note_invoice_id,
        idClient,
        credit_note_invoice_ref,
        creation_date,
        shop_id,

        row_number() over (
            partition by credit_note_invoice_id
            order by export_date desc
        ) as row_num

    from source

)

select
    credit_note_invoice_id,
    idClient,
    credit_note_invoice_ref,
    creation_date,
    shop_id
from ranked
where row_num = 1
