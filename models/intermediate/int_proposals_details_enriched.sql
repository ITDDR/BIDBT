-- One row per package detail line, whether or not it has ever been invoiced.
-- Mirrors int_factures_details_enriched but rooted at package details
-- (via int_packages/int_proposals) instead of invoice lines, so proposals
-- that never became an invoice (devis, proposition, vente) are included too.
-- Client/shop come from the invoice when one exists, falling back to the
-- visit tied to the proposal otherwise (the two agree on idMagasin 100% of
-- the time and on idClient ~99.7% of the time, per the October 2026 audit).
select
    pd.package_detail_id,
    cid.facture_detail_id,
    cid.facture_id,
    ci.no_facture,
    ci.date_creation_facture,

    v.idClient as idClient_visite,
    ci.idClient as idClient_facture,
    clv.provenance as provenance_client_visite,
    cl.provenance as provenance_client_facture,
    clv.creation_date as date_creation_client_visite,
    cl.creation_date as date_creation_client_facture,

    clv.date_operation_partenariat as date_operation_partenariat_visite,
    cl.date_operation_partenariat as date_operation_partenariat_facture,

    clv.provenance_chef_famille as provenance_chef_famille_visite,
    cl.provenance_chef_famille as provenance_chef_famille_facture,

    cpci.date_premiere_facture as date_premiere_facture_client,

    v.idMagasin,
    s.nom_magasin,

    cid.content,

    a.nom_article,
    pd.nom_article_package,
    pd.quantite_produit,
    pd.prix_achat_catalogue_ht,
    pd.prix_achat_magasin_ht,
    pd.taux_tva,
    pd.prix_vente_remise_ttc,
    pd.rabais_et_remise_ttc,

    case pdt.package_datail_type_name
        when 'monture' then concat('monture ', ft.frame_type_name)
        else pdt.package_datail_type_name
    end as package_detail_type_ddr,

    ps.definition_statut_package,
    prs.definition_statut_proposition,

    p.date_creation_package,
    v.date_creation_visite,
    pr.date_proposition,

    sel.nom_vendeur as nom_vendeur_proposition,
    so.sale_offer_name,
    pres.nom_prescripteur,

    cn.creation_date as date_avoir,
    cnd.quantity as avoir_quantite,
    round(cnd.credit_note_value_with_vat / (1 + pd.taux_tva / 100), 2) as avoir_montant_ht

from {{ ref('int_package_details') }} as pd
left join {{ ref('int_packages') }} as p using (package_id)
left join {{ ref('int_factures_details') }} as cid using (package_detail_id)
left join {{ ref('int_factures') }} as ci using (facture_id)
left join {{ ref('int_proposals') }} as pr on pr.proposal_id = p.proposal_id
left join {{ ref('int_visits') }} as v on v.visit_id = coalesce(p.visit_id, pr.visit_id)

left join {{ ref('int_clients') }} as cl on cl.idClient = ci.idClient
left join {{ ref('int_clients') }} as clv on clv.idClient = v.idClient

left join {{ ref('client_premiere_facture') }} as cpci on cpci.idClient = ci.idClient
left join {{ ref('int_shops') }} as s on s.idMagasin = v.idMagasin

left join {{ ref('int_packages_status') }} as ps on ps.package_status_id = p.package_status_id
left join {{ ref('int_proposals_status') }} as prs on prs.proposal_status_id = pr.proposal_status_id
left join {{ ref('int_articles') }} as a
    on a.idMagasin = v.idMagasin and a.article_code = pd.article_code

left join {{ ref('int_packages_packages_statuts_types') }} as ppst on ppst.package_id = p.package_id
left join {{ ref('int_sellers') }} as sel on sel.seller_id = ppst.proposition_personne_id

left join {{ ref('int_packages_details_types') }} as pdt on pdt.package_detail_type_id = pd.detail_type_id
left join {{ ref('int_package_frame_properties') }} as pfp using (package_detail_id)
left join {{ ref('int_frame_types') }} as ft using (frame_type_id)

left join {{ ref('int_visit_prescription_properties') }} as vpp on vpp.visit_id = v.visit_id
left join {{ ref('int_prescriptors') }} as pres using (prescriptor_id)
left join {{ ref('int_sales_offers') }} as so on so.sale_offer_id = p.to_review_sale_offer

left join {{ ref('int_credit_notes_invoices_details') }} as cnd using (facture_detail_id)
left join {{ ref('int_credit_notes_invoices') }} as cn using (credit_note_invoice_id)
