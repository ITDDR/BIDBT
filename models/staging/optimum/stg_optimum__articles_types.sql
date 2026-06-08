with 

source as (

    select * from {{ source('optimum', 'articles_types') }}

),

renamed as (

    select
        article_type_id,
        name,
        description,
        sector_activity_type_id,
        source_file_name,
        export_date

    from source

)

select * from renamed