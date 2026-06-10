with source as (
    
    select *
    from {{ ref('stg_optimum__package_frame_properties') }}

),

ranked as (

    select
        package_detail_id,
        frame_type,
        row_number() over (
            partition by package_detail_id
            order by export_date desc
        ) as row_num

    from source

)

select
    package_detail_id,
    frame_type as frame_type_id

from ranked
where row_num = 1
