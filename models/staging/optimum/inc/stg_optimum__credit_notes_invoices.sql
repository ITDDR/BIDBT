with 

source as (

    select * from {{ source('optimum', 'credit_notes_invoices') }}

)

select
    credit_note_invoice_id,
    client_id as idClient,
    credit_note_invoice_ref,
    cast(creation_datetime as date) as creation_date,
    shop_id,
    export_date
from source