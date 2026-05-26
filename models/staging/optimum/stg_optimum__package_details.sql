with source as (

    select *
    from {{ source('optimum', 'package_details') }}

),

renamed as (

    select
        detail_id,
        package_id,
        article_code,
        manufacturer_code,
        name,
        designation,
        eye_side,
        product_class,
        product_lpp_code,
        product_quantity,
        ht_crude_purchase_price,
        ttc_discount_percentage,
        ht_net_purchase_price,
        ttc_crude_sale_price,
        ttc_sale_discount,
        ttc_net_sale_price,
        sale_tva_rate,
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
