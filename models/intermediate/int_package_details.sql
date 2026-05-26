with source as (
    
    select *
    from {{ ref('stg_optimum__package_details') }}

),

ranked as (

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
        sale_tva_rate,
        ttc_pec_ro_amount,
        ttc_pec_rc1_amount,
        ttc_pec_rc2_amount,
        purchase_date,
        detail_type_id,
        is_deleted,
        prestation_type,

        row_number() over (
            partition by detail_id
            order by export_date desc
        ) as row_num

    from source

)

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
    sale_tva_rate,
    ttc_pec_ro_amount,
    ttc_pec_rc1_amount,
    ttc_pec_rc2_amount,
    purchase_date,
    detail_type_id,
    is_deleted,
    prestation_type
from ranked
where row_num = 1
