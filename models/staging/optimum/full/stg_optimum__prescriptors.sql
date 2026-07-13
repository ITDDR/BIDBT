with 

source as (

    select * from {{ source('optimum', 'prescriptors') }}

),

renamed as (

    select
        prescriptor_id,
        prescriptor_name,
        prescriptor_first_name

    from source

)

select * from renamed