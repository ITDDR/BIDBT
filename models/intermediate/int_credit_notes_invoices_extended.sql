select 
    cl.code_postal,
    cl.ville as ville_client,
    cl.pays as pays_client,
    cl.client_origin, 
    v.amo_name,
    v.rc1_name,
    credit_note_invoice_ref as no_facture,--ci.client_invoice_ref as no_facture,
    -1 * cnd.quantity as product_quantity,-- pd.product_quantity,
    aty.article_type_name,
    ft.frame_type_name,
    case package_datail_type_name 
    when 'monture'
     then concat('monture ', frame_type_name ) 
     else
     package_datail_type_name
     end as    package_detail_type_ddr,
    pdt.package_datail_type_name,
    a.article_name,
    cid.content,
    cid.eye_side,
    -1 * pd.prix_achat_catalogue as prix_achat_catalogue,
    --pd.ttc_discount_percentage,
    -1 * pd.prix_achat_magasin as prix_achat_magasin,
    -1 * pd.prix_vente_magasin as prix_vente_magasin,
    pd.rabais_et_remise_ttc,
    -1 * credit_note_value_without_vat as prix_vente_remise_ht,  --pd.prix_vente_remise_ht,
    -1 * pd.ttc_net_sale_price as ttc_net_sale_price,
    pd.sale_tva_rate,
    ps.package_status_name as package_status,
    ps.package_status_description as package_status_definition,
    prs.proposal_status_name as proposal_status,
    prs.proposal_status_description as proposal_status_definition,
    cid.vat_rate,
    s.address_city as ville_magasin, 
    cn.creation_date as client_invoice_creation_date, 
    p.creation_date as package_creation_date,
    v.creation_date as visit_creation_date,
    cpc.date_premiere_facture,
    ps.package_status_id,
    cid.client_invoice_detail_id,
    cid.client_invoice_id,
    cl.client_id,
    p.package_id,
    --ps.package_status_id,
    pd.package_detail_id,
    s.shop_id,
    a.article_code,
    aty.article_type_id,
    pr.proposal_id,
    prs.proposal_status_id,
    v.visit_id

from 
{{ ref('int_credit_notes_invoices') }} cn
join {{ ref('int_credit_notes_invoices_details') }} cnd using (credit_note_invoice_id) 
left join {{ ref('client_premiere_facture') }} cpc using(client_id)
join {{ ref('int_client_invoices_details') }} cid using (client_invoice_detail_id) 
left join {{ ref('int_clients') }} cl using(client_id)
join {{ ref('int_packages') }} p using (package_id)
left join {{ ref('int_packages_status') }} ps using (package_status_id)
left join {{ ref('int_package_details') }} pd using  (package_detail_id)

join {{ ref('int_shops') }} s using(shop_id)
left join  {{ ref('int_articles') }} a using(shop_id,article_code)
left join  {{ ref('int_articles_types') }} aty using(article_type_id)

left join {{ ref('int_proposals') }} pr using (proposal_id)
left join {{ ref('int_proposals_status') }} prs using (proposal_status_id )
left join {{ ref('int_visits') }} v using  (visit_id)
left join {{ ref('int_packages_details_types') }} pdt on pdt.package_detail_type_id = pd.detail_type_id
left join {{ ref('int_package_frame_properties') }} pfp using (package_detail_id) 
left join {{ ref('int_frame_types') }} ft using (frame_type_id)