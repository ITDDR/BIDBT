with 

source as (

    select * from {{ source('optimum', 'frame_types') }}

),

renamed as (

    select
        frame_type_id,
        frame_type_name,
        frame_type_description

    from source

)

select * from renamed