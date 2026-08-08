with source as (
    select * from {{ source('optimum', 'prescriptors') }}
)

select
    prescriptor_id,
    concat(coalesce(prescriptor_name,''), ' ',coalesce(prescriptor_first_name,'')) as nom_prescripteur
from source