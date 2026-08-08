
    select
        article_type_id

    from {{ ref('stg_optimum__articles_types') }}