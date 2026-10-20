-- Credit note lines: own reference, date, quantity and amount; everything else
-- (client, shop, article, package...) comes from the invoice line being cancelled.
select
    e.provenance,
    e.client_vente_directe,
    e.client_facing_fixe,

    cn.credit_note_invoice_ref as no_facture,
    -1 * cnd.quantity as quantite_produit,
    e.frame_type_name,
    e.package_detail_type_ddr,
    e.package_datail_type_name,
    e.nom_article,
    e.content,
    e.eye_side,
    -1 * e.prix_achat_catalogue_ht as prix_achat_catalogue_ht,
    -1 * e.prix_achat_magasin_ht as prix_achat_magasin_ht,
    -1 * cnd.credit_note_value_with_vat as prix_vente_remise_ttc,
    -1 * e.rabais_et_remise_ttc as rabais_et_remise_ttc,
    e.taux_tva,
    e.package_status,
    e.package_status_definition,
    e.proposal_status,
    e.proposal_status_definition,
    e.ville_magasin,
    cn.creation_date as client_invoice_creation_date,
    e.package_creation_date,
    e.visit_creation_date,
    e.date_premiere_facture,
    e.idClient,
    e.shop_id,
    e.article_code,
    e.nom_article_package,
    e.nom_vendeur_proposition,
    e.sale_offer_name,
    e.nom_prescripteur

from {{ ref('int_credit_notes_invoices') }} as cn
join {{ ref('int_credit_notes_invoices_details') }} as cnd using (credit_note_invoice_id)
join {{ ref('int_client_invoices_details_enriched') }} as e using (client_invoice_detail_id)
