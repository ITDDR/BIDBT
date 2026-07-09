with 

source as (

    select * from {{ source('optimum', 'prescriptors') }}

),

renamed as (

    select
        prescriptor_id,
        prescriptor_name,
        prescriptor_first_name,
        national_id,
        source_file_name,
        export_date

    from source

)

select * from renamed