-- Name-only vendeur dimension, so factures/factures_et_avoirs and
-- propositions_sans_facture can both relate to it independently (on
-- nom_vendeur_proposition) without a direct relationship between them.
select distinct nom_vendeur as nom_vendeur_proposition
from {{ ref('int_sellers') }}
where nom_vendeur is not null
