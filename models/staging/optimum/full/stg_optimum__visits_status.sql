with source as (
    select * from {{ source('optimum', 'visits_status') }}
)

select
    visit_status_id,
    visit_status_name,
    visit_status_description,
    source_file_name,
    export_date
from source