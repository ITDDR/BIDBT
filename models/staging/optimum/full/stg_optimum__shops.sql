select shop_id, shop_name as nom_magasin
from {{ source('optimum', 'shops') }}
