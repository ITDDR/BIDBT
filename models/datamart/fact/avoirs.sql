-- Refund (credit note) lines only, from 2026 onward. No client-table data
-- here on purpose (no provenance, no provenance_chef_famille, etc.) — only
-- the relationship keys (idClient, operation_partenariat, idMagasin). Join
-- to the client/operations_partenariat/shops dimensions for anything else.
select
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
    idMagasin,
    nom_magasin,
    idClient,
    operation_partenariat,
    nom_vendeur_proposition,
    sale_offer_name,
    nom_prescripteur,
    cast(null as date) as date_avoir,
    cast(null as int64) as avoir_quantite,
    cast(null as float64) as avoir_montant_ht
from {{ ref('int_credit_notes_invoices_extended') }}
where date_creation_facture >= '2026-01-01'
