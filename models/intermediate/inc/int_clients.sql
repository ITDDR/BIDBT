with source as (

    select *
    from {{ ref('stg_optimum__clients') }}

),

ranked as (

    select
        idClient,
        provenance,
        client_vente_directe,
        client_facing_fixe,
        row_number() over (
            partition by idClient
            order by update_datetime desc
        ) as row_num

    from source

)

select
   idClient,
        provenance,
        client_vente_directe,
        client_facing_fixe

from ranked
where row_num = 1
