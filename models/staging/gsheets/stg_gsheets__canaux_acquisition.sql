
select
    trim(provenance)              as provenance,
    trim(groupe)                  as groupe,
    trim(famille_canal)           as famille_canal,
    nullif(trim(couts), '')       as couts
from {{ source('gsheets', 'canaux_acquisition') }}
where nullif(trim(provenance), '') is not null
