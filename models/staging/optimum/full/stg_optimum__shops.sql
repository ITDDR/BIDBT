select shop_id as idMagasin, shop_name as nom_magasin
from {{ source('optimum', 'shops') }}
