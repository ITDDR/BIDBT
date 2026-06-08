with 

source as (

    select * from {{ source('optimum', 'packages') }}

),

renamed as (

    select
        package_id,
        package_status_id,
        proposal_id,
        is_with_prescription,
        is_with_glass,
        is_with_lens,
        vision_is_vl,
        vision_is_vp,
        vision_is_vi,
        vision_is_vl_vp,
        package_class,
        is_refund_offer,
        is_tp_ro,
        is_tr_ro,
        is_tp_rc,
        is_tr_rc,
        package_sequence,
        cast(creation_datetime as date) as creation_date,
        update_datetime,
        is_deleted,
        to_review_sale_offer,
        visit_id,
        is_with_hearing_aid,
        is_after_sale_service,
        source_file_name,
        export_date

    from source

)

select * from renamed