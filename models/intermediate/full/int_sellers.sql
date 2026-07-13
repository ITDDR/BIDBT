select
    shop_id,
    seller_id,
    seller_name
from {{ ref('stg_optimum__sellers') }}