select  
    client_id,
    min(creation_date) as date_premiere_facture
from {{ ref('int_client_invoices') }}
group by client_id