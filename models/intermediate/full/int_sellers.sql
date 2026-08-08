select
    seller_id,
    nom_vendeur
from {{ ref('stg_optimum__sellers') }}