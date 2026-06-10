with 

source as (

    select * from {{ source('optimum', 'packages_details_types') }}

),

renamed as (

    select
        package_detail_type_id,
        package_datail_type_name,
        source_file_name,
        export_date

    from source

)

select * from renamed