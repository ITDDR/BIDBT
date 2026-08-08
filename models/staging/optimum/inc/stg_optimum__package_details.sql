with source as (

    select *
    from {{ source('optimum', 'package_details') }}

)

select
    detail_id as package_detail_id,
    package_id,
    article_code,
    product_quantity,
    ht_crude_purchase_price as prix_achat_catalogue,
    ht_net_purchase_price as prix_achat_magasin,
    ttc_net_sale_price / (1 + (sale_tva_rate/100)) as prix_vente_remise_ht,
    detail_type_id,
    export_date
from source
