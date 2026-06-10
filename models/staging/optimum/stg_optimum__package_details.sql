with source as (

    select *
    from {{ source('optimum', 'package_details') }}

),

renamed as (

    select
        detail_id as package_detail_id,
        package_id,
        article_code,
        manufacturer_code,
        name,
        designation,
        eye_side,
        product_class,
        product_lpp_code,
        product_quantity,
        ht_crude_purchase_price as prix_achat_catalogue,
        ttc_discount_percentage,
        ht_net_purchase_price as prix_achat_magasin,
        ttc_crude_sale_price as prix_vente_magasin, --prix de vente brut TTC
  
        ttc_sale_discount as rabais_et_remise_ttc,
        --(ttc_crude_sale_price -ttc_sale_discount ) * 1.00 / (1 + (sale_tva_rate/100)) as prix_vente_remise_ht, --prix de vente brut HT
        ttc_net_sale_price / (1 + (sale_tva_rate/100)) as prix_vente_remise_ht,--prix de vente brut HT
        ttc_net_sale_price,
        sale_tva_rate, --taux de TVA
        ttc_pec_ro_amount,
        ttc_pec_rc1_amount,
        ttc_pec_rc2_amount,
        purchase_date,
        detail_type_id,
        is_deleted,
        prestation_type,
        export_date

    from source

)

select *
from renamed
