with source as (
    
    select *
    from {{ ref('stg_optimum__package_details') }}

),

ranked as (

    select
        package_id,
        package_detail_id,
        article_code,
        product_quantity,
        prix_achat_catalogue,
        ttc_discount_percentage,
        prix_achat_magasin,
        prix_vente_magasin,
        prix_vente_remise_ht,
        rabais_et_remise_ttc,
        ttc_net_sale_price,
        sale_tva_rate,

        row_number() over (
            partition by package_detail_id
            order by export_date desc
        ) as row_num

    from source

)

select
    package_id,
    package_detail_id ,
    article_code,
    product_quantity,
    prix_achat_catalogue,
    ttc_discount_percentage,
    prix_achat_magasin,
    prix_vente_magasin,
    prix_vente_remise_ht,
    rabais_et_remise_ttc,
    --ttc_net_sale_price,
    sale_tva_rate

from ranked
where row_num = 1
