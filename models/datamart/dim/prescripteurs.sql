-- Name-only prescripteur dimension, so factures/factures_et_avoirs and
-- avoirs can both relate to it independently (on nom_prescripteur) without
-- a direct relationship between them.
select distinct nom_prescripteur
from {{ ref('int_prescriptors') }}
where nom_prescripteur is not null
