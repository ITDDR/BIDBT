with 

source as (

    select * from {{ source('optimum', 'credit_notes_invoices') }}

),

renamed as (

    select
        credit_note_invoice_id,
        client_invoice_id,
        client_id,
        credit_note_invoice_ref,
        cast(creation_datetime as date) as creation_date,
        update_datetime,
        transmission_datetime,
        credit_note_invoice_value,
        action_facture_type_id,
        shop_id,
        source_file_name,
        export_date

    from source

)

select * from renamed