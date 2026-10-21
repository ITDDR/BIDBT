with 

source as (

    select * from {{ source('optimum', 'clients_invoices_details') }}

)

select
    client_invoice_detail_id,
    client_invoice_id,
    content,
    package_id,
    package_detail_id,
    export_date
from source