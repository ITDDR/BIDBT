with 

source as (

    select * from {{ source('optimum', 'packages_status') }}

),

renamed as (

    select
        package_status_id,
        package_status_name,
        package_status_description,
        source_file_name,
        export_date

    from source

)

select * from renamed