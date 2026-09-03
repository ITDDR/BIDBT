with 

source as (

    select * from {{ source('optimum', 'packages_packages_statuts_types') }}

),

renamed as (

    select
        package_id,
        proposition_date,
        proposition_personne_id,
        export_date
        
    from source

)

select * from renamed