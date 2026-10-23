select
        package_status_id,
        package_status,
        definition_statut_package
from {{ ref('stg_optimum__packages_status') }}