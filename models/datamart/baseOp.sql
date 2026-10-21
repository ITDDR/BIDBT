select

    provenance,
    client_vente_directe,
    client_facing_fixe,
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
    package_status_definition,

    client_invoice_creation_date,
    package_creation_date,
    visit_creation_date,
    date_premiere_facture,
    shop_id,
    nom_vendeur_proposition,
    idClient,
    sale_offer_name,
    nom_prescripteur


from
{{ ref('int_client_invoices_extended') }}
union all by name
select

    provenance,
    client_vente_directe,
    client_facing_fixe,
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
    'Avoir' as package_status_definition,
    --vat_rate,
    client_invoice_creation_date,
    package_creation_date,
    visit_creation_date,
    date_premiere_facture,
    shop_id,
    nom_vendeur_proposition,
    idClient,
    sale_offer_name,
    nom_prescripteur

from
{{ ref('int_credit_notes_invoices_extended') }}