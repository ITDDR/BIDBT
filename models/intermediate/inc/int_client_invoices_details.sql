with source as (

    select *
    from {{ ref('stg_optimum__clients_invoices_details') }}

),

ranked as (

    select
        client_invoice_detail_id,
        client_invoice_id,
        content,
        package_id,
        package_detail_id,
        eye_side,

        row_number() over (
            partition by client_invoice_detail_id
            order by export_date desc
        ) as row_num

    from source

)

select
    client_invoice_detail_id,
    client_invoice_id,
    content,
    package_id,
    package_detail_id,
    eye_side
from ranked
where row_num = 1
