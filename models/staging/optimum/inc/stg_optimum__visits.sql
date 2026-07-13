with 

source as (

    select * from {{ source('optimum', 'visits') }}

)

select
    visit_id,
    client_id,
    seller_id,
    is_with_prescription,
    visit_status_id,
    amo_id,
    amo_name,
    rc1_id,
    rc1_name,
    rc1_network_name,
    rc2_id,
    rc2_name,
    rc2_network_name,
    cast(creation_datetime as date) as visit_creation_date,
    update_datetime,
    is_deleted,
    shop_id,
    source_file_name,
    export_date
from source