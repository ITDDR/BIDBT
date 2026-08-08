select shop_id, shop_name, ville_magasin
from {{ ref('stg_optimum__shops') }}