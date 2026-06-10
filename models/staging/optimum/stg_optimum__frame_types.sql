with 

source as (

    select * from {{ source('optimum', 'frame_types') }}

),

renamed as (

    select
        frame_type_id,
        frame_type_name,
        frame_type_description,
        source_file_name,
        export_date

    from source

)

select * from renamed