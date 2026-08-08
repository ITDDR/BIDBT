select
    prescriptor_id,
    nom_prescripteur
from {{ ref('stg_optimum__prescriptors') }}