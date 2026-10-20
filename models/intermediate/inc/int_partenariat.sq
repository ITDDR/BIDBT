with clients as (

    select *
    from {{ ref('int_clients') }}

),

canaux_acquisition as (

    select *
    from {{ ref('stg_gsheets__canaux_acquisition') }}

),

family_members as (

    select
        idClient_chefFamille,
        count(*) as nb_autres_clients_famille

    from clients
    where idClient_chefFamille is not null
        and idClient_chefFamille != idClient

    group by idClient_chefFamille

),

joined as (

    select
        clients.idClient,
        clients.provenance,
        clients.nomFamille,
        clients.idClient_chefFamille,
        extract(year from clients.creation_datetime) as annee_creation,
        extract(month from clients.creation_datetime) as mois_creation,
        canaux_acquisition.famille_canal,
        coalesce(family_members.nb_autres_clients_famille, 0) as nb_autres_clients_famille

    from clients
    inner join canaux_acquisition
        on clients.provenance = canaux_acquisition.provenance
    left join family_members
        on clients.idClient = family_members.idClient_chefFamille

)

select
    idClient,
    provenance,
    nomFamille,
    annee_creation,
    mois_creation,
    idClient_chefFamille,
    nb_autres_clients_famille

from joined
where upper(famille_canal) = 'PARTENARIAT'
    and idClient_chefFamille = idClient