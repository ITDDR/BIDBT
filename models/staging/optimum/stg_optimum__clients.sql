with 

source as (

    select * from {{ source('optimum', 'clients') }}

),

renamed as (

    select
        client_id,
        client_group_id,
        client_group_id_creation_datetime,
        client_migration_id,
        shop_id,
        client_origin,
        civility_id,
        case 
            when REGEXP_CONTAINS( upper(last_name), 'VENTE_LIBRE') or
             (REGEXP_CONTAINS( upper(last_name), 'VENTE') and REGEXP_CONTAINS( upper(first_name), 'DIRECTE'))
        then 1
        else 0
        end as client_vente_directe,
        case 
            when REGEXP_CONTAINS( upper(last_name), 'FACING') 
        then 1
        else 0
        end as client_facing_fixe,
        maiden_name,
        social_security_code,
        mobile_phone,
        home_phone,
        office_phone,
        email_adress,
        birth_date,
        address_1,
        address_2,
        zip_code as code_postal,
        city as ville,
        country as pays,
        rgpd_marktg_update_date,
        rgpd_is_marktg_ko,
        rgpd_is_marktg_ok,
        rgpd_transf_update_date,
        rgpd_is_data_transfer,
        npai,
        dead_client,
        multishop_share_client,
        job_type_id,
        mrktg_emailing,
        mrktg_sms,
        mrktg_postal,
        creation_datetime,
        update_datetime,
        is_deleted,
        family_chief_client_id,
        consentement_marketing_partenaire,
        mobile_phone_indicatif,
        source_file_name,
        export_date

    from source

)

select * from renamed