with source as (

    select *
    from {{ source('optimum', 'package_details') }}

)

select
    detail_id as package_detail_id,
    article_code,
    name as nom_article_package,
    product_quantity as quantite_produit,
    ht_crude_purchase_price as prix_achat_catalogue_ht,
    ht_net_purchase_price as prix_achat_magasin_ht,
    sale_tva_rate as taux_tva,
    ttc_net_sale_price as prix_vente_remise_ttc,
    ttc_sale_discount as rabais_et_remise_ttc,
    detail_type_id,
    export_date
from source
