with 

source as (

    select * from {{ source('optimum', 'sales_offers') }}

),

renamed as (

    select
        sale_offer_id,
        sale_offer_name,
        sale_offer_comment,
        creation_datetime,
        update_datetime,
        is_disabled,
        source_file_name,
        export_date

    from source

)

select * from renamed