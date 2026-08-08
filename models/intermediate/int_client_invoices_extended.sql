select 
    cl.client_origin, 
    cl.client_vente_directe,
    cl.client_facing_fixe,

    ci.no_facture,
    pd.product_quantity,
    ft.frame_type_name,
    case pdt.package_datail_type_name 
    when 'monture'
     then concat('monture ', ft.frame_type_name ) 
     else
     pdt.package_datail_type_name
     end as package_detail_type_ddr,
    pdt.package_datail_type_name,
    a.article_name,
    cid.content,
    cid.eye_side,
    pd.prix_achat_catalogue,
    pd.prix_achat_magasin,
    pd.prix_vente_remise_ht,
    ps.package_status,
    ps.package_status_definition,
    prs.proposal_status,
    prs.proposal_status_definition,
    s.ville_magasin, 
    ci.client_invoice_creation_date, 
    p.package_creation_date,
    v.visit_creation_date,
    cpc.date_premiere_facture,
    cl.client_id,
    s.shop_id,
    a.article_code,
    sel.seller_name,
    so.sale_offer_name,
    pres.prescriptor_name
from 
{{ ref('int_client_invoices') }} ci 

join {{ ref('int_client_invoices_details') }} as cid using (client_invoice_id) 
left join {{ ref('int_clients') }} as cl using(client_id)
left join {{ ref('client_premiere_facture') }} as cpc using(client_id)
join {{ ref('int_packages') }} as p using (package_id)
left join {{ ref('int_packages_status') }} as ps using (package_status_id)
left join {{ ref('int_package_details') }} as pd using  (package_detail_id)

join {{ ref('int_shops') }} as s using(shop_id)

left join  {{ ref('int_articles') }} as a using(shop_id,article_code)
left join  {{ ref('int_articles_types') }} as aty using(article_type_id)

left join {{ ref('int_proposals') }} as pr using (proposal_id)

left join {{ ref('int_proposals_status') }} prs using (proposal_status_id )
left join {{ ref('int_visits') }} as v using  (visit_id)
left join {{ ref('int_sellers') }} as sel using(seller_id)

left join {{ ref('int_packages_details_types') }} as pdt on pdt.package_detail_type_id = pd.detail_type_id
left join {{ ref('int_package_frame_properties') }} as pfp using (package_detail_id) 
left join {{ ref('int_frame_types') }} as ft using (frame_type_id)

left join {{ ref('int_visit_prescription_properties') }} vpp using(visit_id)
left join {{ ref('int_prescriptors') }} pres using (prescriptor_id)
left join {{ ref('int_sales_offers') }} so on so.sale_offer_id = p.to_review_sale_offer
