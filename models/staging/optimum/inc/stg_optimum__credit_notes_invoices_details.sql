with 

source as (

    select * from {{ source('optimum', 'credit_notes_invoices_details') }}

)

select
    credit_note_invoice_id,
    quantity,
    credit_note_value_without_vat,
    client_invoice_detail_id,
    export_date
from source