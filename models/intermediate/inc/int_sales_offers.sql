with source as (

    select *
    from {{ ref('stg_optimum__sales_offers') }}

),

ranked as (

    select
        sale_offer_id,
        sale_offer_name,

        row_number() over (
            partition by sale_offer_id
            order by update_datetime desc
        ) as row_num

    from source

)

select
   sale_offer_id,
        sale_offer_name,
from ranked
where row_num = 1
