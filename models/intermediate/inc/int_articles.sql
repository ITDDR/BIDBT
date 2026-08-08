with source as (

    select *
    from {{ ref('stg_optimum__articles') }}

),

ranked as (

    select
        article_code,
        nom_article,
        shop_id,
        article_type_id,

        row_number() over (
            partition by shop_id, article_code
            order by update_datetime desc
        ) as row_num

    from source

)

select
    shop_id,
    article_code,
    nom_article,
    article_type_id
from ranked
where row_num = 1
