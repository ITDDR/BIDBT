with source as (

    select *
    from {{ ref('stg_optimum__packages_packages_statuts_types') }}

),

ranked as (

    select
        package_id,
        proposition_date,
        proposition_personne_id,

        row_number() over (
            partition by package_id
            order by export_date desc
        ) as row_num

    from source

)

select
    package_id,
        proposition_date,
        proposition_personne_id
from ranked
where row_num = 1
