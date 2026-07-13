with 

source as (

    select * from {{ source('optimum', 'articles_types') }}

),

renamed as (

    select
        article_type_id,
        name

    from source

)

select * from renamed