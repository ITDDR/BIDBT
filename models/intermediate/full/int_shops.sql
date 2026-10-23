select idMagasin, nom_magasin
from {{ ref('stg_optimum__shops') }}