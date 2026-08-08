with 

source as (

    select * from {{ source('optimum', 'articles') }}

),

renamed as (

    select
        article_id,
        creation_datetime,
        manufacturer_code,
        article_code,
        article_name,
        quantity,
        shop_id,
        article_type_id,
        is_article_import,
        article_barcode,
        is_unique_barcode,
        is_article_hide,
        commercial_name,
        class,
        update_datetime,
        source_file_name,
        export_date

    from source

)

select * from renamed