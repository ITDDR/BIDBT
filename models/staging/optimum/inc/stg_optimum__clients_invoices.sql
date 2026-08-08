with 

source as (

    select * from {{ source('optimum', 'clients_invoices') }}

)

select
    client_invoice_id,
    client_invoice_ref as no_facture,
    client_id as idClient,
    cast(creation_datetime as date) as client_invoice_creation_date,
    update_datetime,
    shop_id
from source