-- One row per client invoice line, with its invoice header (client, shop) and everything
-- that hangs off the line (package, package detail, article, proposal, visit, seller,
-- prescriptor, frame, sale offer).
-- Shared by int_client_invoices_extended and int_credit_notes_invoices_extended:
-- a credit note line always has the same client and shop as the invoice line it cancels.
select
    cid.client_invoice_detail_id,
    cid.client_invoice_id,
    ci.no_facture,
    ci.client_invoice_creation_date,

    cl.idClient,
    cl.provenance,
    cl.client_vente_directe,
    cl.client_facing_fixe,
    cpc.date_premiere_facture,

    s.shop_id,
    s.ville_magasin,

    cid.content,
    cid.eye_side,

    a.article_code,
    a.nom_article,
    pd.nom_article_package,
    pd.quantite_produit,
    pd.prix_achat_catalogue_ht,
    pd.prix_achat_magasin_ht,
    pd.taux_tva,
    pd.prix_vente_remise_ttc,
    pd.rabais_et_remise_ttc,

    ft.frame_type_name,
    case pdt.package_datail_type_name
        when 'monture' then concat('monture ', ft.frame_type_name)
        else pdt.package_datail_type_name
    end as package_detail_type_ddr,
    pdt.package_datail_type_name,

    ps.package_status,
    ps.package_status_definition,
    prs.proposal_status,
    prs.proposal_status_definition,

    p.package_creation_date,
    v.visit_creation_date,

    sel.nom_vendeur as nom_vendeur_proposition,
    so.sale_offer_name,
    pres.nom_prescripteur

from {{ ref('int_client_invoices_details') }} as cid
join {{ ref('int_client_invoices') }} as ci using (client_invoice_id)
left join {{ ref('int_clients') }} as cl using (idClient)
left join {{ ref('client_premiere_facture') }} as cpc using (idClient)
join {{ ref('int_shops') }} as s using (shop_id)

join {{ ref('int_packages') }} as p using (package_id)
left join {{ ref('int_packages_status') }} as ps using (package_status_id)
left join {{ ref('int_package_details') }} as pd using (package_detail_id)
left join {{ ref('int_articles') }} as a using (shop_id, article_code)
left join {{ ref('int_articles_types') }} as aty using (article_type_id)

left join {{ ref('int_proposals') }} as pr using (proposal_id)
left join {{ ref('int_proposals_status') }} as prs using (proposal_status_id)
left join {{ ref('int_visits') }} as v using (visit_id)
left join {{ ref('int_packages_packages_statuts_types') }} as ppst using (package_id)
left join {{ ref('int_sellers') }} as sel on sel.seller_id = ppst.proposition_personne_id

left join {{ ref('int_packages_details_types') }} as pdt on pdt.package_detail_type_id = pd.detail_type_id
left join {{ ref('int_package_frame_properties') }} as pfp using (package_detail_id)
left join {{ ref('int_frame_types') }} as ft using (frame_type_id)

left join {{ ref('int_visit_prescription_properties') }} as vpp using (visit_id)
left join {{ ref('int_prescriptors') }} as pres using (prescriptor_id)
left join {{ ref('int_sales_offers') }} as so on so.sale_offer_id = p.to_review_sale_offer
