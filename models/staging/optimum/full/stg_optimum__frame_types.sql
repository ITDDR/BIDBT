with source as (
    select * from {{ source('optimum', 'frame_types') }}
)

select
    frame_type_id,
    frame_type_name
from source