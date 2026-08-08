with source as (

    select *
    from {{ ref('stg_optimum__visits') }}

),

ranked as (

    select
        visit_id,
        seller_id,
        visit_creation_date,
        row_number() over (
            partition by visit_id
            order by update_datetime desc
        ) as row_num

    from source

)

select
    visit_id,
    seller_id,
    visit_creation_date
from ranked
where row_num = 1