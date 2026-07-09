with source as (

    select *
    from {{ ref('stg_optimum__packages') }}

),

ranked as (

    select
        package_id,
        package_status_id,
        proposal_id,
        to_review_sale_offer,
        creation_date,
        

        row_number() over (
            partition by package_id
            order by update_datetime desc
        ) as row_num

    from source

)

select
     package_id,
        package_status_id,
        proposal_id,
        to_review_sale_offer,
        creation_date
from ranked
where row_num = 1
