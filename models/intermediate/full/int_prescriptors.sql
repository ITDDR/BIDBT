select
    prescriptor_id,
    prescriptor_full_name as prescriptor_name
from {{ ref('stg_optimum__prescriptors') }}