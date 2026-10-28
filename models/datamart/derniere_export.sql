-- Single-row table: when the source data was last exported, independent of
-- any transaction/invoice date. Based on clients_invoices since it's the
-- most frequently updated source table.
select max(export_date) as date_dernier_export
from {{ ref('stg_optimum__clients_invoices') }}
