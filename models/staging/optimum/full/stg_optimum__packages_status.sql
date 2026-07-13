with 

source as (

    select * from {{ source('optimum', 'packages_status') }}

),

renamed as (

    select
        package_status_id,
        package_status_name,
        package_status_description

    from source

)

select * from renamed