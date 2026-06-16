with 

source as (

    select * from {{ source('optimum', 'credit_notes_invoices_details') }}

),

renamed as (

    select
        credit_note_invoice_detail_id,
        credit_note_invoice_id,
        content,
        quantity,
        eye_side,
        credit_note_value_without_vat,
        credit_note_value_with_vat,
        sale_datetime,
        client_invoice_detail_id,
        source_file_name,
        export_date

    from source

)

select * from renamed