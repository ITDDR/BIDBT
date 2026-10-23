-- Data quality: for every definition_statut_package, how the lines split
-- across three populations — never invoiced (a genuine open quote/proposal),
-- invoiced with no avoir, and invoiced with an avoir against it. This is the
-- combined view: it separates the large, expected "devis réalisé" population
-- (real open quotes, never billed) from the small one caused by a refund
-- reverting an already-invoiced package back to devis.
-- Run with: dbt show --select dq_package_status_vs_refunds --limit 100
with refunded_detail_ids as (

    select distinct facture_detail_id
    from {{ ref('int_credit_notes_invoices_details') }}

)

select
    e.definition_statut_package,
    countif(e.no_facture is null) as nb_never_invoiced,
    countif(e.no_facture is not null and r.facture_detail_id is null) as nb_invoiced_no_avoir,
    countif(e.no_facture is not null and r.facture_detail_id is not null) as nb_invoiced_with_avoir,
    count(*) as nb_total,
    round(sum(if(e.no_facture is null, e.prix_vente_remise_ttc, 0)), 0) as ca_ttc_never_invoiced,
    round(sum(if(e.no_facture is not null and r.facture_detail_id is null, e.prix_vente_remise_ttc, 0)), 0) as ca_ttc_invoiced_no_avoir,
    round(sum(if(e.no_facture is not null and r.facture_detail_id is not null, e.prix_vente_remise_ttc, 0)), 0) as ca_ttc_invoiced_with_avoir

from {{ ref('int_proposals_details_enriched') }} as e
left join refunded_detail_ids as r on r.facture_detail_id = e.facture_detail_id
group by e.definition_statut_package
order by nb_total desc
