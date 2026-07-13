with source as (
    select * from {{ source('optimum', 'prescriptors') }}
)

select
    prescriptor_id,
    prescriptor_name,
    prescriptor_first_name,
    concat(coalesce(prescriptor_name,''), ' ',coalesce(prescriptor_first_name,'')) as prescriptor_full_name
from source