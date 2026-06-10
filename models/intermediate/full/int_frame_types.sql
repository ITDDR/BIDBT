select frame_type_id,
        frame_type_name,
        frame_type_description,
from {{ ref('stg_optimum__frame_types') }}