select shop_id, ville_magasin
from {{ ref('stg_optimum__shops') }}