with unioned as (

    select

        provenance,
        no_facture,
        quantite_produit,
        package_detail_type_ddr,
        nom_article,
        nom_article_package,
        content,

        prix_achat_catalogue_ht,
        prix_achat_magasin_ht,
        prix_vente_remise_ttc,
        rabais_et_remise_ttc,
        taux_tva,
        definition_statut_package,

        date_creation_facture,
        date_creation_package,
        date_creation_visite,
        date_proposition,
        date_premiere_facture,
        idMagasin,
        nom_vendeur_proposition,
        idClient,
        date_operation_partenariat,
        sale_offer_name,
        nom_prescripteur,

        date_avoir,
        avoir_quantite,
        avoir_montant_ht


    from
    {{ ref('int_factures_extended') }}
    union all by name
    select

        provenance,
        no_facture,
        quantite_produit,
        package_detail_type_ddr,
        nom_article,
        nom_article_package,
        content,
        prix_achat_catalogue_ht,
        prix_achat_magasin_ht,
        prix_vente_remise_ttc ,
        rabais_et_remise_ttc,
        taux_tva,
        'Avoir' as definition_statut_package,
        --vat_rate,
        date_creation_facture,
        date_creation_package,
        date_creation_visite,
        date_proposition,
        date_premiere_facture,
        idMagasin,
        nom_vendeur_proposition,
        idClient,
        date_operation_partenariat,
        sale_offer_name,
        nom_prescripteur,

        cast(null as date) as date_avoir,
        cast(null as int64) as avoir_quantite,
        cast(null as float64) as avoir_montant_ht

    from
    {{ ref('int_credit_notes_invoices_extended') }}

)

-- Only bills (or credit notes, which carry their own date here) from 2026 onward.
select *
from unioned
where date_creation_facture >= '2026-01-01'
