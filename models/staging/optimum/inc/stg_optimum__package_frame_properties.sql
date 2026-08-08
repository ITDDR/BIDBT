with 

source as (

    select * from {{ source('optimum', 'package_frame_properties') }}

)

select
    package_detail_id,
    frame_type,
    export_date
from source