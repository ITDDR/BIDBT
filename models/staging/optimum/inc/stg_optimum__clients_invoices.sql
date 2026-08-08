with 

source as (

    select * from {{ source('optimum', 'clients_invoices') }}

)

select
    client_invoice_id,
    client_invoice_ref as no_facture,
    client_id,
    cast(creation_datetime as date) as client_invoice_creation_date,
    update_datetime,
    transmission_datetime,
    payment_datetime,
    items_number,
    client_invoice_value,
    action_facture_type_id,
    shop_id
from source