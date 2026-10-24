select
        package_detail_type_id,
        nom_type_detail_package
from {{ ref('stg_optimum__packages_details_types') }}