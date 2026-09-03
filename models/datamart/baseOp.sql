select

    provenance,
    client_vente_directe,
    client_facing_fixe,
    no_facture,
    quantite_produit,
    frame_type_name,
    package_detail_type_ddr,
    package_datail_type_name,
    nom_article,
    nom_article_package,
    content,
    eye_side,
    case
     when prix_achat_magasin <> 0 then
        prix_vente_remise_ht * quantite_produit - prix_achat_magasin
        else
        prix_vente_remise_ht * quantite_produit - prix_achat_catalogue
        end
    as marge_brute,
    prix_achat_catalogue,
    prix_achat_magasin,

    prix_vente_remise_ht * quantite_produit as prix_vente_remise_ht,
    rabais_et_remise_ttc,

    package_status,
    package_status_definition,
    proposal_status,
    proposal_status_definition,

    ville_magasin,
    client_invoice_creation_date,
    package_creation_date,
    visit_creation_date,
    date_premiere_facture,
    article_code,
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
    frame_type_name,
    package_detail_type_ddr,
    package_datail_type_name,
    nom_article,
    nom_article_package,
    content,
    eye_side,
    prix_achat_catalogue,
    prix_achat_magasin,
    -1 * prix_vente_remise_ht * quantite_produit as marge_brute,
    prix_vente_remise_ht,
    rabais_et_remise_ttc,

    'Avoir' as package_status,
    'Avoir' as package_status_definition,
    proposal_status,
    proposal_status_definition,
    --vat_rate,
    ville_magasin,
    client_invoice_creation_date,
    package_creation_date,
    visit_creation_date,
    date_premiere_facture,
    article_code,
    shop_id,
    nom_vendeur_proposition,
    idClient,
    sale_offer_name,
    nom_prescripteur

from
{{ ref('int_credit_notes_invoices_extended') }}