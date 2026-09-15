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
        prix_achat_catalogue_ht,
        prix_achat_magasin_ht,
        taux_tva,
        prix_vente_remise_ttc,
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
    prix_achat_catalogue_ht,
    prix_achat_magasin_ht,
    taux_tva,
    prix_vente_remise_ttc,
    rabais_et_remise_ttc,
    detail_type_id

from ranked
where row_num = 1
