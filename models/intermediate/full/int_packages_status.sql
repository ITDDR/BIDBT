select
        package_status_id,
        package_status,
        package_status_definition
from {{ ref('stg_optimum__packages_status') }}