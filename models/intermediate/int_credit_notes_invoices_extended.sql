select
    cl.provenance,
    cl.client_vente_directe,
    cl.client_facing_fixe,

    credit_note_invoice_ref as no_facture,
    -1 * cnd.quantity as quantite_produit,
    ft.frame_type_name,
    case pdt.package_datail_type_name
    when 'monture'
     then concat('monture ', ft.frame_type_name )
     else
     pdt.package_datail_type_name
     end as package_detail_type_ddr,
    pdt.package_datail_type_name,
    a.nom_article,
    cid.content,
    cid.eye_side,
    -1 * pd.prix_achat_catalogue as prix_achat_catalogue,
    -1 * pd.prix_achat_magasin as prix_achat_magasin,
    -1 * credit_note_value_without_vat as prix_vente_remise_ht,
    -1 * rabais_et_remise_ttc as rabais_et_remise_ttc,
    ps.package_status,
    ps.package_status_definition,
    prs.proposal_status,
    prs.proposal_status_definition,
    s.ville_magasin,
    cn.creation_date as client_invoice_creation_date,
    p.package_creation_date,
    v.visit_creation_date,
    cpc.date_premiere_facture,
    cl.idClient,
    s.shop_id,
    a.article_code,
    sel.nom_vendeur as nom_vendeur_proposition,
    so.sale_offer_name,
    pres.nom_prescripteur

from
{{ ref('int_credit_notes_invoices') }} as cn
join {{ ref('int_credit_notes_invoices_details') }} as cnd using (credit_note_invoice_id)
left join {{ ref('client_premiere_facture') }} as cpc using(idClient)
join {{ ref('int_client_invoices_details') }} as cid using (client_invoice_detail_id)
left join {{ ref('int_clients') }} cl using(idClient)
join {{ ref('int_packages') }} p using (package_id)
left join {{ ref('int_packages_status') }} ps using (package_status_id)
left join {{ ref('int_package_details') }} pd using  (package_detail_id)

join {{ ref('int_shops') }} s using(shop_id)
left join  {{ ref('int_articles') }} a using(shop_id,article_code)
left join  {{ ref('int_articles_types') }} aty using(article_type_id)

left join {{ ref('int_proposals') }} pr using (proposal_id)
left join {{ ref('int_proposals_status') }} prs using (proposal_status_id )
left join {{ ref('int_visits') }} v using  (visit_id)
left join {{ ref('int_packages_packages_statuts_types') }} as ppst using (package_id) 
left join {{ ref('int_sellers') }} as sel on sel.seller_id = ppst.proposition_personne_id --using(seller_id)

left join {{ ref('int_packages_details_types') }} pdt on pdt.package_detail_type_id = pd.detail_type_id
left join {{ ref('int_package_frame_properties') }} pfp using (package_detail_id) 
left join {{ ref('int_frame_types') }} ft using (frame_type_id)

left join {{ ref('int_visit_prescription_properties') }} vpp using(visit_id)
left join {{ ref('int_prescriptors') }} pres using (prescriptor_id)
left join {{ ref('int_sales_offers') }} so on so.sale_offer_id = p.to_review_sale_offer