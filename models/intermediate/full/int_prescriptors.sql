select prescriptor_id,        
        concat(coalesce(prescriptor_name,''), ' ',coalesce(prescriptor_first_name,'')) as prescriptor_name
from {{ ref('stg_optimum__prescriptors') }}