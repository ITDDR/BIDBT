with 

source as (

    select * from {{ source('optimum', 'package_frame_properties') }}

),

renamed as (

    select
        visit_id,
        package_id,
        package_detail_id,
        frame_material,
        gender,
        edi_color_code,
        frame_color,
        frame_style,
        frame_model,
        frame_size,
        frame_type,
        brand,
        is_deleted,
        source_file_name,
        export_date

    from source

)

select * from renamed