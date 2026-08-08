select shop_id, shop_name, address_city as ville_magasin
from {{ source('optimum', 'shops') }}
