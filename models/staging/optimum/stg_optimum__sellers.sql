with 

source as (

    select * from {{ source('optimum', 'sellers') }}

),

renamed as (

    select
        seller_id,
        shop_id,
        last_name,
        first_name,
        civility_id,
        login_name,
        is_deleted_shop,
        is_deleted,
        creation_datetime,
        creation_datetime_shop,
        email,
        source_file_name,
        export_date

    from source

)

select * from renamed