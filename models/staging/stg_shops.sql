select *
from {{ source('raw_optimum', 'shops') }}
