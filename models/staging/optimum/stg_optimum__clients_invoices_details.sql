with 

source as (

    select * from {{ source('optimum', 'clients_invoices_details') }}

),

renamed as (

    select
        client_invoice_detail_id,
        client_invoice_id,
        content,
        quantity,
        package_id,
        package_detail_id,
        eye_side,
        vat_rate,
        sale_datetime,
        lpp_code,
        export_date

    from source

)

select * from renamed