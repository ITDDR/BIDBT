with source as (

    select *
    from {{ ref('stg_optimum__clients') }}

),

ranked as (

    select
        client_id,
        client_origin,
        client_vente_directe,
        client_facing_fixe,
        row_number() over (
            partition by client_id
            order by update_datetime desc
        ) as row_num

    from source

)

select
   client_id,
        client_origin,
        client_vente_directe,
        client_facing_fixe

from ranked
where row_num = 1
