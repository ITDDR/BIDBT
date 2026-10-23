with source as (

    select *
    from {{ ref('stg_optimum__clients') }}

),

ranked as (

    select
        idClient,
        provenance,
        nomFamille,
        idClient_chefFamille,
        creation_date,
        annee_creation,
        mois_creation,
        row_number() over (
            partition by idClient
            order by update_datetime desc, export_date desc
        ) as row_num

    from source

),

deduped as (

    select
        idClient,
        provenance,
        nomFamille,
        idClient_chefFamille,
        creation_date,
        annee_creation,
        mois_creation

    from ranked
    where row_num = 1

)

select
    d.idClient,
    d.provenance,
    d.nomFamille,
    d.idClient_chefFamille,
    d.creation_date,
    d.annee_creation,
    d.mois_creation,

    chef.provenance as provenance_chef_famille,

    date(
        2000 + safe_cast(regexp_extract(d.nomFamille, r'([0-9]{2})_[0-9]{2}') as int64),
        safe_cast(regexp_extract(d.nomFamille, r'[0-9]{2}_([0-9]{2})') as int64),
        1
    ) as date_operation_partenariat

from deduped as d
left join deduped as chef on d.idClient_chefFamille = chef.idClient
