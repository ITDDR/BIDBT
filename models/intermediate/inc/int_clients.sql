with source as (

    select *
    from {{ ref('stg_optimum__clients') }}

),

ranked as (

    select
        idClient,
        idMagasin,
        provenance,
        nomFamille,
        operation_partenariat,
        idClient_chefFamille,
        date_creation,
        ville,
        row_number() over (
            partition by idClient
            order by update_datetime desc, export_date desc
        ) as row_num

    from source

),

deduped as (

    select
        idClient,
        idMagasin,
        provenance,
        nomFamille,
        operation_partenariat,
        idClient_chefFamille,
        date_creation,
        ville

    from ranked
    where row_num = 1

),

withChef as (
    select
    d.idClient,
    d.idMagasin,
    d.provenance,
    d.nomFamille,
    d.operation_partenariat,
    d.idClient_chefFamille,
    d.date_creation,

    chef.provenance as provenance_chef_famille,
    d.ville

from deduped as d
left join deduped as chef on d.idClient_chefFamille = chef.idClient)

select * ,
    date(
        2000 + safe_cast(regexp_extract(operation_partenariat, r'([0-9]{2})_[0-9]{2}') as int64),
        safe_cast(regexp_extract(operation_partenariat, r'[0-9]{2}_([0-9]{2})') as int64),
        1
    ) as date_operation_partenariat,
    regexp_extract(provenance_chef_famille, r'Contrat\s+(\S+)') as charge_de_dev
from withChef
