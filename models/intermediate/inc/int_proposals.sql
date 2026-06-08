with source as (

    select *
    from {{ ref('stg_optimum__proposals') }}

),

ranked as (

    select
        proposal_id,
        visit_id,
        proposal_status_id,

        row_number() over (
            partition by proposal_id
            order by update_datetime desc
        ) as row_num

    from source

)

select
    proposal_id,
        visit_id,
        proposal_status_id
from ranked
where row_num = 1
