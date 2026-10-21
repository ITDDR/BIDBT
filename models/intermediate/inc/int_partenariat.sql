with clients as (

    select *
    from {{ ref('int_clients') }}

),

canaux_acquisition as (

    select *
    from {{ ref('stg_gsheets__canaux_acquisition') }}

),

chefs_partenariat as (

    select
        clients.idClient_chefFamille,
        clients.nomFamille,
        clients.provenance,
        clients.creation_datetime

    from clients
    inner join canaux_acquisition
        on clients.provenance = canaux_acquisition.provenance
    where clients.idClient = clients.idClient_chefFamille
        and upper(canaux_acquisition.famille_canal) = 'PARTENARIAT'

),

member_provenance_counts as (

    select
        idClient_chefFamille,
        coalesce(provenance, 'NULL') as provenance,
        count(*) as nb_clients_provenance

    from clients
    where idClient_chefFamille is not null
        and idClient_chefFamille != idClient

    group by idClient_chefFamille, provenance

),

members_agg as (

    select
        idClient_chefFamille,
        sum(nb_clients_provenance) as nb_membres_famille,
        string_agg(
            provenance || ' (' || cast(nb_clients_provenance as string) || ')',
            ', '
            order by nb_clients_provenance desc
        ) as provenances_membres

    from member_provenance_counts
    group by idClient_chefFamille

)

select
    extract(year from chefs_partenariat.creation_datetime) as annee_creation,
    extract(month from chefs_partenariat.creation_datetime) as mois_creation,
    chefs_partenariat.nomFamille,
    chefs_partenariat.idClient_chefFamille,
    chefs_partenariat.provenance as provenance_chef,
    coalesce(members_agg.nb_membres_famille, 0) as nb_membres_famille,
    members_agg.provenances_membres

from chefs_partenariat
left join members_agg
    on chefs_partenariat.idClient_chefFamille = members_agg.idClient_chefFamille
