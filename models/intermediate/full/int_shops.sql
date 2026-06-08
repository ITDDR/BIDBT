select shop_id, shop_name, address_city
from {{ ref('stg_optimum__shops') }}