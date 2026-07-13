with 

source as (

    select * from {{ source('optimum', 'proposals') }}

),

renamed as (

    select
        proposal_id,
        visit_id,
        proposals_status_id as proposal_status_id,
        is_with_glass,
        is_with_lens,
        is_with_hearing_aid,
        vision_is_vl,
        vision_is_vp,
        vision_is_vi,
        vision_is_vl_vp,
        has_full_health_basket,
        has_refund_offer,
        --sale_offer_pack, --only null values
        cast(creation_datetime as date) as creation_date,
        update_datetime,
        is_deleted,
        source_file_name,
        export_date

    from source

)

select * from renamed