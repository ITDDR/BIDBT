-- Credit note lines: own reference, date, quantity and amount; everything else
-- (client, shop, article, package...) comes from the invoice line being cancelled.
select
    e.provenance,

    cn.credit_note_invoice_ref as no_facture,
    -1 * cnd.quantity as quantite_produit,
    e.package_detail_type_ddr,
    e.nom_article,
    e.content,
    -1 * e.prix_achat_catalogue_ht as prix_achat_catalogue_ht,
    -1 * e.prix_achat_magasin_ht as prix_achat_magasin_ht,
    -1 * cnd.credit_note_value_with_vat as prix_vente_remise_ttc,
    -1 * e.rabais_et_remise_ttc as rabais_et_remise_ttc,
    e.taux_tva,
    e.definition_statut_package,
    cn.creation_date as date_creation_facture,
    e.date_creation_package,
    e.date_creation_visite,
    e.date_proposition,
    e.date_premiere_facture,
    e.idClient,
    e.date_operation_partenariat,
    e.provenance_chef_famille,
    e.operation_partenariat,
    e.idMagasin,
    e.nom_magasin,
    e.nom_article_package,
    e.nom_vendeur_proposition,
    e.sale_offer_name,
    e.nom_prescripteur

from {{ ref('int_credit_notes_invoices') }} as cn
join {{ ref('int_credit_notes_invoices_details') }} as cnd using (credit_note_invoice_id)
join {{ ref('int_factures_details_enriched') }} as e using (facture_detail_id)
