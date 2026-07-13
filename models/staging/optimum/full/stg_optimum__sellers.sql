with 

source as (

    select * from {{ source('optimum', 'sellers') }}

),

renamed as (

    select
        seller_id,
        shop_id,
        last_name,
        first_name

    from source

)

select * from renamed