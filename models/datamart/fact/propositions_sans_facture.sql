-- Visit/proposal lines that never became an invoice, from 2026 onward
-- (by date_proposition, since there's no invoice date). No client-table
-- data here on purpose (no provenance, no provenance_chef_famille, etc.)
-- — only the relationship keys (idClient, operation_partenariat, idMagasin).
-- idClient/operation_partenariat come from the visit side only: since
-- there's no invoice, the facture-side client never exists for these rows.
select
    idClient_visite as idClient,
    operation_partenariat_visite as operation_partenariat,
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
    definition_statut_proposition,
    date_creation_package,
    date_creation_visite,
    date_proposition,
    idMagasin,
    nom_magasin,
    nom_vendeur_proposition,
    sale_offer_name,
    nom_prescripteur
from {{ ref('int_proposals_details_enriched') }}
where no_facture is null
    and date_proposition >= '2026-01-01'
