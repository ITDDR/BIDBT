select shop_id, 
        seller_id,
        concat(last_name, ' ',first_name) as seller_name
from {{ ref('stg_optimum__sellers') }}