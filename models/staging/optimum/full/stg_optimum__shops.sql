select shop_id, shop_name as nom_magasin, address_city as ville_magasin
from {{ source('optimum', 'shops') }}
