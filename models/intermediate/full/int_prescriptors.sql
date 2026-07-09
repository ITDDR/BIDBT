select prescriptor_id,
        
        
        concat(prescriptor_name, ' ',prescriptor_first_name) as prescriptor_name
from {{ ref('stg_optimum__prescriptors') }}