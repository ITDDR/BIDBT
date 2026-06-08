
    select
        article_type_id,
        name as article_type_name

    from {{ ref('stg_optimum__articles_types') }}