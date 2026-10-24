-- Same row set as baseOp (the previous version, before proposals were
-- added): invoiced lines + credit notes, from 2026 onward. Union of the two
-- lean fact tables, with quantity/amount columns negated on the avoirs leg
-- so a plain SUM() nets invoices and refunds correctly. avoirs itself keeps
-- these positive since it's used standalone. The null placeholders below
-- exist only so UNION ALL BY NAME matches the full shape of factures —
-- avoirs itself doesn't carry these columns.
select * from {{ ref('factures') }}
union all by name
select
    no_facture,
    noAvoir,
    -1 * quantite_produit as quantite_produit,
    cast(null as string) as package_detail_type_ddr,
    cast(null as string) as nom_article,
    cast(null as string) as nom_article_package,
    cast(null as string) as content,
    cast(null as float64) as prix_achat_catalogue_ht,
    cast(null as float64) as prix_achat_magasin_ht,
    -1 * prix_vente_remise_ttc as prix_vente_remise_ttc,
    -1 * rabais_et_remise_ttc as rabais_et_remise_ttc,
    taux_tva,
    cast(null as string) as definition_statut_package,
    cast(null as date) as date_creation_facture,
    cast(null as date) as date_creation_package,
    cast(null as date) as date_creation_visite,
    cast(null as date) as date_proposition,
    idMagasin,
    nom_magasin,
    idClient,
    cast(null as string) as operation_partenariat,
    nom_vendeur_proposition,
    sale_offer_name,
    nom_prescripteur,
    date_creation_avoir,
    cast(null as int64) as avoir_quantite,
    cast(null as float64) as avoir_montant_ht
from {{ ref('avoirs') }}
