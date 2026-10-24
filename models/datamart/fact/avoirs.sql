-- Refund (credit note) lines only, from 2026 onward. Lean on purpose: only
-- what's needed to count avoirs and compute CA (count, quantity, amounts,
-- taux_tva from the original invoice line). No client-table data (no
-- provenance, no provenance_chef_famille, etc.) — only the relationship
-- keys (idClient, operation_partenariat, idMagasin). Join to the
-- client/operations_partenariat/shops dimensions for anything else.
select
    no_facture,
    noAvoir,
    quantite_produit,
    prix_vente_remise_ttc,
    rabais_et_remise_ttc,
    taux_tva,
    date_creation_avoir,
    idMagasin,
    nom_magasin,
    idClient,
    nom_prescripteur,
    nom_vendeur_proposition,
    sale_offer_name
from {{ ref('int_credit_notes_invoices_extended') }}
where date_creation_avoir >= '2026-01-01'
