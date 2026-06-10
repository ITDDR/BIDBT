select
        package_detail_type_id,
        package_datail_type_name
from {{ ref('stg_optimum__packages_details_types') }}