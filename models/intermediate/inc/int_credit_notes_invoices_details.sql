with source as (

    select *
    from {{ ref('stg_optimum__credit_notes_invoices_details') }}

),

ranked as (

    select
        credit_note_invoice_id,
        quantity,
        credit_note_value_without_vat,
        client_invoice_detail_id,

        row_number() over (
            partition by credit_note_invoice_id, client_invoice_detail_id
            order by export_date desc
        ) as row_num

    from source

)

select
    credit_note_invoice_id,
    quantity,
    credit_note_value_without_vat,
    client_invoice_detail_id
from ranked
where row_num = 1
