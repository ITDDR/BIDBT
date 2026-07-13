with source as (
    select * from {{ source('optimum', 'packages_details_types') }}
)

select
    package_detail_type_id,
    package_datail_type_name
from source