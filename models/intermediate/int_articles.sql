with source as (

    select *
    from {{ ref('stg_optimum__articles') }}

),

ranked as (

    select
        article_id,
        creation_datetime,
        manufacturer_code,
        article_code,
        article_name,
        quantity,
        shop_id,
        article_type_id,
       

        row_number() over (
            partition by article_id
            order by update_datetime desc
        ) as row_num

    from source

)

select
      article_id,
      shop_id,
        article_code,
        article_name,
        article_type_id
from ranked
where row_num = 1
