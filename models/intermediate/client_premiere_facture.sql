select
    idClient,
    min(client_invoice_creation_date) as date_premiere_facture
from {{ ref('int_client_invoices') }}
group by idClient