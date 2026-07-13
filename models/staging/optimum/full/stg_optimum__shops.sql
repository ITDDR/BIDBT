select shop_id, shop_name, address_city
from {{ source('optimum', 'shops') }}
