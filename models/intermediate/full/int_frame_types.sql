select frame_type_id,
        frame_type_name
from {{ ref('stg_optimum__frame_types') }}