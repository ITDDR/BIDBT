with source as (

    select *
    from {{ ref('stg_optimum__visits') }}

),

ranked as (

    select
        visit_id,
        idClient,
        idMagasin,
        seller_id,
        date_creation_visite,
        row_number() over (
            partition by visit_id
            order by update_datetime desc, export_date desc
        ) as row_num

    from source

)

select
    visit_id,
    idClient,
    idMagasin,
    seller_id,
    date_creation_visite
from ranked
where row_num = 1