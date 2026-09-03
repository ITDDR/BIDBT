with source as (
    
    select *
    from {{ ref('stg_optimum__package_details') }}

),

ranked as (

    select
        package_detail_id,
        article_code,
        nom_article_package,
        quantite_produit,
        prix_achat_catalogue,
        prix_achat_magasin,
        prix_vente_remise_ht,
        rabais_et_remise_ttc,
        detail_type_id,
        row_number() over (
            partition by package_detail_id
            order by export_date desc
        ) as row_num

    from source

)

select
    package_detail_id,
    article_code,
    nom_article_package,
    quantite_produit,
    prix_achat_catalogue,
    prix_achat_magasin,
    prix_vente_remise_ht,
    rabais_et_remise_ttc,
    detail_type_id

from ranked
where row_num = 1
