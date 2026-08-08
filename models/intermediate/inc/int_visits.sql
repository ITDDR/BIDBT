with source as (

    select *
    from {{ ref('stg_optimum__visits') }}

),

ranked as (

    select
        visit_id,
        client_id,
        seller_id,
        is_with_prescription,
        visit_status_id,
        amo_name,
        rc1_name,
        visit_creation_date,
        row_number() over (
            partition by visit_id
            order by update_datetime desc
        ) as row_num

    from source

)

select
    visit_id,
    client_id,
    seller_id,
    is_with_prescription,
    visit_status_id,
    amo_name,
    rc1_name,
    visit_creation_date
from ranked
where row_num = 1