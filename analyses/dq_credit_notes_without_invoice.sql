-- Data quality: credit note (avoir) lines that reference an invoice line we
-- don't have. Run with: dbt show --select dq_credit_notes_without_invoice --limit 100
select
    cn.credit_note_invoice_id,
    cn.credit_note_invoice_ref,
    cn.creation_date as credit_note_date,
    cn.idClient,
    cn.idMagasin,
    cnd.facture_detail_id as missing_facture_detail_id,
    cnd.quantity,
    cnd.credit_note_value_with_vat

from {{ ref('int_credit_notes_invoices_details') }} as cnd
join {{ ref('int_credit_notes_invoices') }} as cn using (credit_note_invoice_id)
left join {{ ref('int_factures_details_enriched') }} as e using (facture_detail_id)
where e.facture_detail_id is null
order by cn.creation_date desc
