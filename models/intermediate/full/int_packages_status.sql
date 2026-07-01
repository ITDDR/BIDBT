select
        package_status_id,
        package_status_name,
        package_status_description
from {{ ref('stg_optimum__packages_status') }}