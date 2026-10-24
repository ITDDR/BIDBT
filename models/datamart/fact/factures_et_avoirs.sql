-- Same row set as baseOp (the previous version, before proposals were
-- added): invoiced lines + credit notes, from 2026 onward. Just the union
-- of the two lean fact tables, so it carries no client-table data either.
select * from {{ ref('factures') }}
union all by name
select * from {{ ref('avoirs') }}
