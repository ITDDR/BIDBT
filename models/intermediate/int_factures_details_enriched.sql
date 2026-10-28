-- One row per client invoice line, with its invoice header (client, shop) and everything
-- that hangs off the line (package, package detail, article, proposal, visit, seller,
-- prescriptor, frame, sale offer).
-- Shared by int_factures_extended and int_credit_notes_invoices_extended:
-- a credit note line always has the same client and shop as the invoice line it cancels.
select
    cid.facture_detail_id,
    cid.facture_id,
    ci.no_facture,
    ci.date_creation_facture,

    cl.idClient,
    cl.provenance,
    cl.provenance_chef_famille,
    cl.operation_partenariat,
    cl.date_operation_partenariat,
    cpc.date_premiere_facture,

    s.idMagasin,
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

    case pdt.nom_type_detail_package
        when 'monture' then concat('monture ', ft.frame_type_name)
        else pdt.nom_type_detail_package
    end as package_detail_type_ddr,

    ps.definition_statut_package,

    p.date_creation_package,
    v.date_creation_visite,
    pr.date_proposition,

    sel.nom_vendeur as nom_vendeur_proposition,
    so.sale_offer_name,
    pres.nom_prescripteur,

    cn.creation_date as date_creation_avoir,
    cn.noAvoir,
    cnd.quantity as avoir_quantite,
    round(cnd.credit_note_value_with_vat / (1 + pd.taux_tva / 100), 2) as avoir_montant_ht

from {{ ref('int_factures_details') }} as cid
join {{ ref('int_factures') }} as ci using (facture_id)
left join {{ ref('int_clients') }} as cl using (idClient)

left join {{ ref('client_premiere_facture') }} as cpc using (idClient)
join {{ ref('int_shops') }} as s on s.idMagasin = ci.idMagasin

join {{ ref('int_packages') }} as p using (package_id)
left join {{ ref('int_packages_status') }} as ps using (package_status_id)
left join {{ ref('int_package_details') }} as pd using (package_detail_id)
left join {{ ref('int_articles') }} as a on a.idMagasin = s.idMagasin and a.article_code = pd.article_code

left join {{ ref('int_proposals') }} as pr using (proposal_id)
left join {{ ref('int_visits') }} as v on v.visit_id = pr.visit_id
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
