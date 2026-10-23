with source as (
    select * from {{ source('optimum', 'packages_status') }}
)

select
    package_status_id,
    package_status_name as package_status,
    package_status_description as definition_statut_package
from source