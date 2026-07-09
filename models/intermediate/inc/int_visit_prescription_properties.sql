with source as (

    select *
    from {{ ref('stg_optimum__visit_prescription_properties') }}

),

ranked as (

    select
        visit_id,
        prescriptor_id,
        seller_id,

        row_number() over (
            partition by visit_id
            order by update_datetime desc
        ) as row_num

    from source

)

select
        visit_id,
        prescriptor_id,
        seller_id,
from ranked
where row_num = 1
