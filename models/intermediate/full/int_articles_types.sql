
    select
        article_type_id,
        article_type_name

    from {{ ref('stg_optimum__articles_types') }}