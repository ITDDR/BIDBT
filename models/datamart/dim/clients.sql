select
    idClient,
    provenance,
    nomFamille,
    idClient_chefFamille,
    creation_date,
    annee_creation,
    mois_creation,
    provenance_chef_famille,
    date_operation_partenariat
from {{ ref('int_clients') }}
