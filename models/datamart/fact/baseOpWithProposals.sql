-- Same as baseOp, but rooted at package details instead of invoice lines, so
-- packages/proposals that never became an invoice (devis, proposition,
-- vente) are included too, with invoice-only fields left null for them.
-- idClient/provenance/client_creation_date are kept separate per source
-- (visit vs invoice) instead of coalesced: the two agree on idMagasin 100% of
-- the time (so idMagasin is taken from the visit only) but idClient only
-- ~99.7% of the time, so both are exposed for Power BI to reconcile.
-- date_premiere_facture is invoice-side only (no visit-side equivalent).
with unioned as (

    select

        idClient_visite,
        idClient_facture,
        provenance_client_visite,
        provenance_client_facture,
        date_creation_client_visite,
        date_creation_client_facture,
        date_operation_partenariat_visite,
        date_operation_partenariat_facture,
        provenance_chef_famille_visite,
        provenance_chef_famille_facture,
        operation_partenariat_visite,
        operation_partenariat_facture,
        date_premiere_facture_client,

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
        definition_statut_proposition,

        date_creation_facture,
        date_creation_package,
        date_creation_visite,
        date_proposition,
        idMagasin,
        nom_magasin,
        nom_vendeur_proposition,
        sale_offer_name,
        nom_prescripteur,

        date_avoir,
        avoir_quantite,
        avoir_montant_ht


    from
    {{ ref('int_proposals_details_enriched') }}
    union all by name
    select

        cast(null as int64) as idClient_visite,
        idClient as idClient_facture,
        cast(null as string) as provenance_client_visite,
        provenance as provenance_client_facture,
        cast(null as date) as date_creation_client_visite,
        cast(null as date) as date_creation_client_facture,
        cast(null as date) as date_operation_partenariat_visite,
        date_operation_partenariat as date_operation_partenariat_facture,
        cast(null as string) as provenance_chef_famille_visite,
        provenance_chef_famille as provenance_chef_famille_facture,
        cast(null as string) as operation_partenariat_visite,
        operation_partenariat as operation_partenariat_facture,
        date_premiere_facture as date_premiere_facture_client,

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
        cast(null as string) as definition_statut_proposition,
        --vat_rate,
        date_creation_facture,
        date_creation_package,
        date_creation_visite,
        date_proposition,
        idMagasin,
        nom_magasin,
        nom_vendeur_proposition,
        sale_offer_name,
        nom_prescripteur,

        cast(null as date) as date_avoir,
        cast(null as int64) as avoir_quantite,
        cast(null as float64) as avoir_montant_ht

    from
    {{ ref('int_credit_notes_invoices_extended') }}

)

-- Only bills (or credit notes, which carry their own date here) from 2026
-- onward; a never-invoiced proposal is kept too, but only when there's no
-- invoice date at all and the proposal itself is from 2026 onward.
select *
from unioned
where date_creation_facture >= '2026-01-01'
    or (date_creation_facture is null and date_proposition >= '2026-01-01')
